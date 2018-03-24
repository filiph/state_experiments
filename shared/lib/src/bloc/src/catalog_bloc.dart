import 'dart:async';

import 'package:reactive_exploration/src/bloc/src/bloc.dart';
import 'package:reactive_exploration/src/shared/models/catalog.dart';
import 'package:rxdart/subjects.dart';

class CatalogBloc extends Bloc {
  final _requestRefreshController = new StreamController<Null>();

  final BehaviorSubject<Catalog> _catalogSubject =
      new BehaviorSubject<Catalog>(seedValue: new Catalog.empty());

  final BehaviorSubject<bool> _loading =
      new BehaviorSubject<bool>(seedValue: true);

  CatalogBloc() {
    _requestRefreshController.stream.listen((_) {
      _fetch();
      _loading.add(true);
    });
    _fetch();
  }

  /// This is the stream of the latest state of the cart.
  BehaviorSubject<Catalog> get catalog => _catalogSubject;

  BehaviorSubject<bool> get loading => _loading;

  Sink<Null> get requestRefresh => _requestRefreshController.sink;

  @override
  void dispose() {
    _catalogSubject.close();
    _requestRefreshController.close();
    _loading.close();
    super.dispose();
  }

  void _fetch() {
    fetchCatalog().then((fetched) {
      _catalogSubject.add(fetched);
      _loading.add(false);
    });
  }
}
