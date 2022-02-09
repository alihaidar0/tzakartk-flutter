import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/product_repository.dart';

class ProductController extends ControllerMVC {
  Product product;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  bool loadCart = false;
  int current = 0;
  GlobalKey<ScaffoldState> scaffoldKey;

  ProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForProduct({String productId, String message}) async {
    final Stream<Product> stream = await getProduct(productId);
    stream.listen((Product _product) {
      print("######### Product #########");
      print("${_product.id}");
      print("${_product.price}");
      print("${_product.discountPrice}");
      print("${_product.featured}");
      print("##################");
      setState(() {
        if (_product.optionGroups.length > 0 && _product.options.length > 0) {
          _product.optionGroups.forEach((element) {
            Option _option = _product.options.firstWhere(
              (option) {
                return option.optionGroupId == element.id;
              },
              orElse: () => null,
            );
            if (_option != null) {
              _product.options.forEach((element) {
                if (element.id == _option.id) element.checked = true;
              });
            }
          });
        }
        product = _product;
      });
    }, onError: (a) {
      print("##################");
      print("######### Error getProduct with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  void addToCart(Product product) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.product = product;
    _newCart.options =
        product.options.where((element) => element.checked).toList();
    _newCart.quantity = this.quantity;
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity += this.quantity;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_product_was_added_to_cart),
        ));
      });
    } else {
      listenForCart();
      addCart(_newCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_product_was_added_to_cart),
        ));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  void calculateTotal() {
    total = product?.price ?? 0;
    product?.options?.forEach((option) {
      total += option.checked ? option.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }

  Future<void> refreshProduct() async {
    var _id = product.id;
    product = new Product();
    listenForProduct(
        productId: _id,
        message: S.of(state.context).productRefreshedSuccessfully);
  }
}
