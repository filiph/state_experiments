import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/product.dart';

class ProductLine extends StatelessWidget {
  final Product product;

  final bool isInCart;

  final void Function() onTap;

  static const _madeUpTaglines = [
    'This product will change your life.',
    'Can you live without this product? The answer is no.',
    'Should you buy this product? Our advice: do.',
    'Some products are good. This one is amazing.',
    'Have you ever wanted to be popular and admired? Buy this.',
    'You can\'t buy happiness but you can buy this product.',
  ];

  const ProductLine(
    this.product, {
    Key key,
    this.onTap,
    this.isInCart = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = product?.color ?? Colors.grey;

    final textColor = product != null ? Colors.black : Colors.grey;

    final boldTitle = Theme.of(context).textTheme.body1.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          color: textColor,
        );

    final splashColor = Color.lerp(color, Colors.white, 0.8);

    final name = product?.name ?? '';

    final tagline = product != null
        ? _madeUpTaglines[product.id % _madeUpTaglines.length]
        : '';

    final image = product != null
        ? Placeholder(
            color: color,
            strokeWidth: isInCart ? 8.0 : 2.0,
          )
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          );

    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: image,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: boldTitle),
                    SizedBox(height: 8.0),
                    Text(
                      tagline,
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
