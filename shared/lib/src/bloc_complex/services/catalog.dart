import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:reactive_exploration/common/models/product.dart';
import 'package:reactive_exploration/src/bloc_complex/services/catalog_page.dart';

/// A class that mimics a network-backed service.
class CatalogService {
  /// The amount of products in each returned [CatalogPage].
  ///
  /// Changing this variable while the app is running has undefined behavior.
  /// This is intended as a one-time, initial setup variable.
  static int productsPerPage = 10;

  /// The minimal delay between requesting a page and getting it back,
  /// in milliseconds.
  static int networkDelay = 500;

  /// Fetches a page of products from a database. The [CatalogPage.startIndex]
  /// of the returned value will be [offset].
  Future<CatalogPage> requestPage(int offset) async {
    // Simulate network delay.
    await Future.delayed(Duration(milliseconds: networkDelay));

    // Create a list of random products. We seed the random generator with
    // index so that scrolling back to a position gives the same exact products.
    final random = Random(offset);
    final products = List.generate(productsPerPage, (index) {
      final id = random.nextInt(0xffff);
      final color = Color(0xFF000000 | random.nextInt(0xFFFFFF));
      return Product(id, "Product $id (#${offset + index})", color);
    });
    return CatalogPage(products, offset);
  }
}
