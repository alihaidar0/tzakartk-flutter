import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/cart_price.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  CartPrice cartPrice = new CartPrice();
  double subTotal = 0.0;
  double deliveryFee = 0.0;
  double total = 0.0;
  int cartCount = 0;
  double taxAmount = 0.0;

  GlobalKey<ScaffoldState> scaffoldKey;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          coupon = _cart.product.applyCoupon(coupon);
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print("##################");
      print("######### Error getCart with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateCartPrice();
      }
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {}

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print("##################");
      print("######### Error getCartCount with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(state.context).carts_refreshed_successfuly);
    listenForCartsCount();
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateCartPrice();
      listenForCartsCount();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S
            .of(state.context)
            .the_product_was_removed_from_your_cart(_cart.product.en_name)),
      ));
    });
  }

  void calculateCartPrice() async {
    final Stream<CartPrice> stream = await getCartPrice();
    stream.listen((CartPrice _cartPrice) {
      setState(() {
        subTotal = _cartPrice.sub_total;
        deliveryFee = _cartPrice.delivery_fee;
        total = _cartPrice.total;
      });
    }, onError: (a) {
      print("##################");
      print("######### Error getCartCount with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    });
  }

  void doApplyCoupon(String code, {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      print("##################");
      print("######### Error verifyCoupon with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      listenForCarts();
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateCartPrice();
      listenForCartsCount();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateCartPrice();
      listenForCartsCount();
    }
  }

  void goCheckout(BuildContext context) {
    // if (!currentUser.value.profileCompleted()) {
    //   ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
    //     content: Text(S.of(state.context).completeYourProfileDetailsToContinue),
    //     action: SnackBarAction(
    //       label: S.of(state.context).settings,
    //       textColor: Theme.of(state.context).accentColor,
    //       onPressed: () {
    //         Navigator.of(state.context).pushNamed('/Settings');
    //       },
    //     ),
    //   ));
    // } else {
    //   Navigator.of(state.context).pushNamed('/DeliveryPickup');
    // }
    Navigator.of(state.context).pushNamed('/DeliveryPickup');
  }

  Color getCouponIconColor() {
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(state.context).focusColor.withOpacity(0.7);
  }
}
