import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/category.dart';
import '../models/sub_category.dart';
import '../repository/banner_slider_repository.dart';
import '../repository/category_repository.dart';
import '../repository/sub_category_repository.dart';

class HomeController extends ControllerMVC {
  List<String> bannerSlider = <String>[];
  List<Category> categories = <Category>[];
  List<SubCategory> subCategories = <SubCategory>[];

  HomeController() {
    listenForBanners();
  }

  Future<void> listenForBanners() async {
    bannerSlider.clear();
    final Stream<String> stream = await getBanners();
    stream.listen((String _banner) {
      setState(() => bannerSlider.add(_banner));
    }, onError: (a) {
      print("##################");
      print("######### Error getBanners #########");
      print("##################");
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories(String cityId) async {
    categories.clear();
    final Stream<Category> stream = await getCategories(cityId);
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print("##################");
      print("######### Error getCategories #########");
      print("##################");
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForSubCategories(String parentId) async {
    subCategories.clear();
    final Stream<SubCategory> stream = await getSubCategories(parentId);
    stream.listen((SubCategory _subCategory) {
      setState(() => subCategories.add(_subCategory));
    }, onError: (a) {
      print("##################");
      print("######### Error getSubCategories #########");
      print("##################");
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForSubCategoriesByCity(String cityId) async {
    subCategories.clear();
    final Stream<SubCategory> stream = await getSubCategoriesByCity(cityId);
    stream.listen((SubCategory _subCategory) {
      setState(() => subCategories.add(_subCategory));
    }, onError: (a) {
      print("##################");
      print("######### Error getSubCategoriesByCity #########");
      print("##################");
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshHome() async {
    setState(() {
      bannerSlider.clear();
      categories.clear();
      subCategories.clear();
    });
    await listenForBanners();
  }
}
