import 'package:reactive_exploration/src/bloc/main.dart' as bloc;
import 'package:reactive_exploration/src/bloc_complex/main.dart'
    as bloc_complex;
import 'package:reactive_exploration/src/redux/main.dart' as redux;
import 'package:reactive_exploration/src/scoped/complete.dart' as scoped;
import 'package:reactive_exploration/src/singleton/main.dart' as singleton;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;

/// This rather unconventional main method allows us to switch to vastly
/// different implementations of the same app without confusing Flutter
/// and the IDE with many `main.dart` files in `lib/`.
///
/// All this main function does is run _another_ main function in one of
/// the imported files. When you're exploring a particular architecture,
/// just change the `flavor = ...` line below and (hot-)restart the app.
void main() {
  final flavor = Architecture.blocComplex;

  print("\n\n===== Running: $flavor =====\n\n");

  switch (flavor) {
    case Architecture.singleton:
      singleton.main();
      return;
    case Architecture.vanilla:
      vanilla.main();
      return;
    case Architecture.valueNotifier:
      value_notifier.main();
      return;
    case Architecture.bloc:
      bloc.main();
      return;
    case Architecture.blocComplex:
      bloc_complex.main();
      return;
    case Architecture.scoped:
      scoped.main();
      return;
    case Architecture.redux:
      redux.main();
      return;
  }
}

enum Architecture {
  bloc,
  blocComplex,
  scoped,
  singleton,
  vanilla,
  valueNotifier,
  redux,
}
