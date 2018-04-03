import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CartButton extends StatelessWidget {
  /// The function to call when the icon button is pressed.
  final VoidCallback onPressed;

  /// Number of items in the basket. When this is `0`, no badge will be shown.
  final int itemCount;

  final Color badgeColor;

  final Color badgeTextColor;

  CartButton({
    Key key,
    @required this.itemCount,
    this.onPressed,
    this.badgeColor: Colors.red,
    this.badgeTextColor: Colors.white,
  })  : assert(itemCount >= 0),
        assert(badgeColor != null),
        assert(badgeTextColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = new Icon(Icons.shopping_cart);

    if (itemCount == 0) {
      return new IconButton(
        icon: icon,
        onPressed: onPressed,
      );
    }

    return new IconButton(
        icon: new Stack(
          overflow: Overflow.visible,
          children: [
            new Icon(Icons.shopping_cart),
            new Positioned(
              top: -8.0,
              right: -3.0,
              child: new Material(
                  type: MaterialType.circle,
                  elevation: 2.0,
                  color: Colors.red,
                  child: new Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: new Text(
                      itemCount.toString(),
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: badgeTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        onPressed: onPressed);
  }
}
