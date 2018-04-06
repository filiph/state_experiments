import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:meta/meta.dart';

class CartButton extends StatefulWidget {
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
  CartButtonState createState() {
    return new CartButtonState();
  }
}

class CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  final Tween<Offset> _badgePositionTween = new Tween(
    begin: const Offset(-0.5, 0.9),
    end: const Offset(0.0, 0.0),
  );

  @override
  Widget build(BuildContext context) {
    final icon = new Icon(Icons.shopping_cart);

    if (widget.itemCount == 0) {
      return new IconButton(
        icon: icon,
        onPressed: widget.onPressed,
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
              child: new SlideTransition(
                position: _badgePositionTween.animate(_animation),
                child: new Material(
                    type: MaterialType.circle,
                    elevation: 2.0,
                    color: Colors.red,
                    child: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Text(
                        widget.itemCount.toString(),
                        style: new TextStyle(
                          fontSize: 13.0,
                          color: widget.badgeTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
        onPressed: widget.onPressed);
  }

  @override
  void didUpdateWidget(CartButton oldWidget) {
    if (widget.itemCount != oldWidget.itemCount) {
      _animationController.reset();
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = new CurvedAnimation(
        parent: _animationController, curve: Curves.elasticOut);
    _animationController.forward();
  }
}
