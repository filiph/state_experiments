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
import 'package:reactive_exploration/src/bloc_complex/services/catalog.dart';
import 'package:reactive_exploration/src/redux/main.dart' as redux;
import 'package:reactive_exploration/src/scoped/complete.dart' as scoped_model;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;

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

  testWidgets('bloc_complex', (WidgetTester tester) async {
    // We need runAsync here because CatalogBloc uses a Timer
    // (via RX bufferTime). For more info:
    // https://github.com/flutter/flutter/issues/17738
    await tester.runAsync(() async {
      final catalogService = CatalogService();
      final catalog = CatalogBloc(catalogService);
      final cart = CartBloc();
      final app = bloc_complex.MyApp(catalog, cart);

      // The product name is generated in bloc_complex.
      final productName = "Product 43740 (#0)";

      await tester.pumpWidget(app);

      expect(find.text("0"), findsOneWidget);

      await tester.tap(find.byType(CartButton));
      await tester.pumpAndSettle();

      expect(find.text("Empty"), findsOneWidget);

      await tester.pageBack();
      // We need this piece of real asynchrony here so that the bloc can
      // do its thing.
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text(productName));
      await tester.pumpAndSettle();

      expect(find.text("1"), findsOneWidget);

      await tester.tap(find.byType(CartButton));
      await tester.pumpAndSettle();

      expect(find.text("Empty"), findsNothing);
      expect(find.text(productName), findsOneWidget);
    });
  });
}

/// Verifies that the app compiles and runs, and that tapping products
/// adds them to cart.
///
/// This test exists to ensure that the sample works with future versions
/// of Flutter.
Future _performSmokeTest(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);

  expect(find.text("0"), findsOneWidget);

  await tester.tap(find.byType(CartButton));
  await tester.pumpAndSettle();

  expect(find.text("Empty"), findsOneWidget);

  await tester.pageBack();
  await tester.pumpAndSettle(const Duration(seconds: 5));

  await tester.tap(find.text("Socks"));
  await tester.pumpAndSettle();

  expect(find.text("1"), findsOneWidget);

  await tester.tap(find.byType(CartButton));
  await tester.pumpAndSettle();

  expect(find.text("Empty"), findsNothing);
  expect(find.text("Socks"), findsOneWidget);
}
