import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';

class CustomShoppingCartButtonWidget extends StatefulWidget {
  const CustomShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    this.count,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  final int count;
  final VoidCallback onPressed;

  @override
  _CustomShoppingCartButtonWidgetState createState() =>
      _CustomShoppingCartButtonWidgetState();
}

class _CustomShoppingCartButtonWidgetState
    extends StateMVC<CustomShoppingCartButtonWidget> {
  CartController _con;

  _CustomShoppingCartButtonWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: widget.onPressed,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.shopping_cart_outlined,
            color: this.widget.iconColor,
            size: 28,
          ),
          Container(
            child: Text(
              widget.count != null
                  ? widget.count.toString()
                  : _con.cartCount.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.merge(
                    TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 10),
                  ),
            ),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: this.widget.labelColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(
                minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
