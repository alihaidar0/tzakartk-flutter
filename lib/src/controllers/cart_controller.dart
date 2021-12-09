import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/cart_price.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  CartPrice cartPrice = new CartPrice();
  double subTotal = 0.0;
  double deliveryFee = 0.0;
  double total = 0.0;
  double couponDiscount = 0.0;
  int cartCount = 0;
  double taxAmount = 0.0;

  GlobalKey<ScaffoldState> scaffoldKey;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    getCoupon();
  }

  void listenForCarts({String message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
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
        calculateCartPrice(settingRepo.coupon.code);
      }
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

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
    listenForCarts(message: S.of(state.context).carts_refreshed_successfully);
    listenForCartsCount();
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateCartPrice(settingRepo.coupon.code);
      listenForCartsCount();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S
            .of(state.context)
            .the_product_was_removed_from_your_cart(_cart.product.en_name)),
      ));
    });
  }

  void calculateCartPrice(String code) async {
    final Stream<CartPrice> stream = await getCartPrice(code);
    stream.listen((CartPrice _cartPrice) {
      setState(() {
        subTotal = _cartPrice.sub_total;
        deliveryFee = _cartPrice.delivery_fee;
        total = _cartPrice.total;
        couponDiscount = _cartPrice.couponDiscount;
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
    verifyCoupon(code).then((value) {
      settingRepo.coupon = value;
    }).catchError((e) {
      print("##################");
      print("######### Error doApplyCoupon with SnackBar #########");
      print("##################");
      print(e);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }).whenComplete(() {
      saveCoupon(settingRepo.coupon);
      calculateCartPrice(settingRepo.coupon.code);
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart).then((value) {
        calculateCartPrice(settingRepo.coupon.code);
      });
      listenForCartsCount();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart).then((value) {
        calculateCartPrice(settingRepo.coupon.code);
      });
      listenForCartsCount();
    }
  }

  void goCheckout(BuildContext context) {
    Navigator.of(state.context).pushNamed('/DeliveryPickup');
  }

  Color getCouponIconColor() {
    if (settingRepo.coupon?.enabled == true) {
      return Colors.green;
    } else if (settingRepo.coupon?.enabled == false) {
      return Colors.redAccent;
    }
    return Theme.of(state.context).focusColor.withOpacity(0.7);
  }

  Future<void> getCoupon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('coupon')) {
      settingRepo.coupon =
          Coupon.fromJSON(json.decode(await prefs.get('coupon')));
    }
    return settingRepo.coupon;
  }
}
