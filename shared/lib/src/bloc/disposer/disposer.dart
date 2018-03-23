// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is taken from https://github.com/dart-lang/angular_components/tree/master/lib/utils/disposer

import 'dart:async';

const String _oneShotDisposerMemoryLeakWarning =
    'Possible memory leak detected: A disposable should not be added to '
    'one shot disposers after the dispose() method has been called.';

/// A function, that when called, will cleanup any resources or subscriptions.
typedef void DisposeFunction();

/// A class with a [dispose] method for cleaning up resources or subscriptions.
abstract class Disposable {
  /// A disposable that does nothing.
  static const Disposable Noop = const _NoopDisposable();

  /// Creates a simple disposable that just executes [disposeFn].
  factory Disposable(DisposeFunction disposeFn) = _SingleFunctionDisposable;

  /// Disposes this disposable and any resources it has open.
  void dispose();
}

/// A no-op implementation of [Disposable].
class _NoopDisposable implements Disposable {
  const _NoopDisposable();

  @override
  void dispose() {}
}

/// A simple implementation of [Disposable].
class _SingleFunctionDisposable implements Disposable {
  final DisposeFunction _disposeFn;

  _SingleFunctionDisposable(this._disposeFn);

  @override
  void dispose() {
    _disposeFn();
  }
}

/// Tracks disposables that are added to it for later disposal.
///
/// Example usage:
///     final disposer = new Disposer()
///       ..addDisposable(() => print('Clean up');)
///       ..addDisposable(stream.listen())
///       ..addDisposable(myCustomDisposable);
///
///     disposer.dispose();
///
/// Example usage of 'oneShot' mode.  Please use this for cases where there
/// is a single call to dispose as it will help detect potential memory leaks
/// where a disposable is being added after the disposer has been disposed.
/// This is very typical for Angular components where disposer.dispose() is
/// called in ngOnDestroy.
///
///     final disposer = new Disposer.oneShot()
///       ..addDisposable(() => print('Clean up');)
///       ..addDisposable(stream.listen());
///
///     disposer.dispose();
///     // The following call will assert.
///     disposer.addDisposable(myCustomDisposable);
///
/// Prefer typed functions whenever possible:
///   [addEventSink]
///   [addFunction]
///   [addStreamSubscription]
///
/// Note that you should not rely on the disposal sequence for each added
/// [disposable], just treat it random.
class Disposer implements Disposable {
  List<DisposeFunction> _disposeFunctions;
  List<StreamSubscription> _disposeSubs;
  List<EventSink> _disposeSinks;
  List<Disposable> _disposeDisposables;
  final bool _oneShot;
  bool _disposeCalled = false;

  /// Pass [oneShot] as true if no disposables are meant to be added after
  /// the dispose method is called.
  @Deprecated("Please use oneShot or multi instead")
  Disposer({bool oneShot: false}) : _oneShot = oneShot;

  /// Convenience constructor for one shot mode or single dispose mode.
  Disposer.oneShot() : _oneShot = true;

  /// Convenience constructor for supporting multiple calls to dispose.
  Disposer.multi() : _oneShot = false;

  /// Registers [disposable] for disposal when [dispose] is called later.
  ///
  /// Prefer typed functions whenever possible, as this is megamorphic:
  ///   [addEventSink]
  ///   [addStreamSubscription]
  ///   [addFunction]
  T addDisposable<T>(T disposable) {
    dynamic disposable_ = disposable;
    if (disposable_ is Disposable) {
      _disposeDisposables ??= [];
      _disposeDisposables.add(disposable as Disposable);
      _checkIfAlreadyDisposed();
    } else if (disposable_ is StreamSubscription) {
      addStreamSubscription(disposable_);
    } else if (disposable_ is EventSink) {
      addEventSink(disposable_);
    } else if (disposable_ is DisposeFunction) {
      addFunction(disposable_);
    } else {
      throw new ArgumentError.value(disposable, 'disposable');
    }
    return disposable;
  }

  /// Registers [disposable].
  StreamSubscription<T> addStreamSubscription<T>(
      StreamSubscription<T> disposable) {
    _disposeSubs ??= [];
    _disposeSubs.add(disposable);
    _checkIfAlreadyDisposed();
    return disposable;
  }

  /// Registers [disposable].
  EventSink<T> addEventSink<T>(EventSink<T> disposable) {
    _disposeSinks ??= [];
    _disposeSinks.add(disposable);
    _checkIfAlreadyDisposed();
    return disposable;
  }

  /// Registers [disposable].
  DisposeFunction addFunction(DisposeFunction disposable) {
    assert(disposable != null);
    _disposeFunctions ??= [];
    _disposeFunctions.add(disposable);
    _checkIfAlreadyDisposed();
    return disposable;
  }

  // In dev-mode, throws if a oneShot disposer was already disposed.
  void _checkIfAlreadyDisposed() {
    assert(!(_oneShot && _disposeCalled), _oneShotDisposerMemoryLeakWarning);
  }

  @override
  void dispose() {
    if (_disposeSubs != null) {
      int len = _disposeSubs.length;
      for (var i = 0; i < len; i++) {
        _disposeSubs[i].cancel();
      }
      _disposeSubs = null;
    }
    if (_disposeSinks != null) {
      int len = _disposeSinks.length;
      for (var i = 0; i < len; i++) {
        _disposeSinks[i].close();
      }
      _disposeSinks = null;
    }
    if (_disposeDisposables != null) {
      int len = _disposeDisposables.length;
      for (var i = 0; i < len; i++) {
        _disposeDisposables[i].dispose();
      }
      _disposeDisposables = null;
    }
    if (_disposeFunctions != null) {
      int len = _disposeFunctions.length;
      for (var i = 0; i < len; i++) {
        _disposeFunctions[i]();
      }
      _disposeFunctions = null;
    }
    _disposeCalled = true;
  }
}