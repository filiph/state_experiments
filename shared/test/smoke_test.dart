import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_exploration/common/models/cart.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/src/bloc/main.dart' as bloc;
import 'package:reactive_exploration/src/bloc_complex/cart/cart_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/catalog/catalog_bloc.dart';
import 'package:reactive_exploration/src/bloc_complex/main.dart'
    as bloc_complex;
import 'package:reactive_exploration/src/redux/main.dart' as redux;
import 'package:reactive_exploration/src/scoped/complete.dart' as scoped_model;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;
import 'package:rxdart/rxdart.dart';

void main() {
  testWidgets('vanilla', (WidgetTester tester) async {
    final app = vanilla.MyApp();

    await _performSmokeTest(tester, app);
  });

  testWidgets('value_notifier', (WidgetTester tester) async {
    final cartObservable = value_notifier.CartObservable(Cart());
    final app = value_notifier.MyApp(
      cartObservable: cartObservable,
    );

    await _performSmokeTest(tester, app);
  });

  testWidgets('scoped_model', (WidgetTester tester) async {
    final app = scoped_model.MyApp();

    await _performSmokeTest(tester, app);
  });

  testWidgets('redux', (WidgetTester tester) async {
    final app = redux.MyApp();

    await _performSmokeTest(tester, app);
  });

  testWidgets('bloc', (WidgetTester tester) async {
    final app = bloc.MyApp();

    await _performSmokeTest(tester, app);
  });

  testWidgets('close_stream', (WidgetTester tester) async {
    final controller = new PublishSubject<int>();

    final subscription = controller
        .bufferTime(const Duration(milliseconds: 500))
        .listen((list) => print(list));

    subscription.cancel();
    controller.close();

    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets('bloc_complex:unit', (WidgetTester tester) async {
    final catalog = CatalogBloc();
//    final cart = CartBloc();
//    final product = Product(42, "Test", Color(0xFFFF0000));
//    final grid = MaterialApp(
//        home: ProductSquare(
//      product: product,
//      itemsStream: cart.items,
//    ));
//
//    await tester.pumpWidget(grid);

//    await tester.pumpAndSettle(const Duration(seconds: 1));
    await catalog.dispose();
    await tester.pumpAndSettle(const Duration(seconds: 1));
//    await tester.idle();
    print("end of testWidget");
  });

  testWidgets('bloc_complex', (WidgetTester tester) async {
    final catalog = CatalogBloc();
    final cart = CartBloc();
    final app = bloc_complex.MyApp(catalog, cart);

    await _performSmokeTest(tester, app);
  });
}

Future _performSmokeTest(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);

  await tester.tap(find.byType(CartButton));

  await tester.pumpAndSettle();

  expect(tester.any(find.text("Empty")), isTrue);
}
