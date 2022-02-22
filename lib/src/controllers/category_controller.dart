import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../repository/category_repository.dart';
import '../repository/product_repository.dart';
import 'cart_controller.dart';

class CategoryController extends CartController {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForProductsByCategory({String id, String message}) async {
    final Stream<Product> stream = await getProductsByCategory(id);
    stream.listen((Product _product) {
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
        products.add(_product);
      });
    }, onError: (a) {
      print("##################");
      print("######### Error getProductsByCategory with SnackBar #########");
      print("##################");
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCategory({String id, String message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
    }, onError: (a) {
      print("##################");
      print("######### Error getCategory with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }
}
