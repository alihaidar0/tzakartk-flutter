import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/sub_category.dart';
import '../repository/banner_slider_repository.dart';
import '../repository/category_repository.dart';
import '../repository/city_repository.dart';
import '../repository/country_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/sub_category_repository.dart';

class HomeController extends ControllerMVC {
  List<String> bannerSlider = <String>[];
  List<Country> countries = <Country>[];
  List<City> cities = <City>[];
  List<Category> categories = <Category>[];
  List<SubCategory> subCategories = <SubCategory>[];

  HomeController() {
    listenForBanners();
    listenForCountries();
  }

  Future<void> listenForBanners() async {
    final Stream<String> stream = await getBanners();
    stream.listen((String _banner) {
      setState(() => bannerSlider.add(_banner));
    }, onError: (a) {
      print("##################");
      print("######### Error getBanners #########");
      print("##################");
      print(a);
    }, onDone: () {
    });
  }

  Future<void> listenForCountries() async {
    final Stream<Country> stream = await getCountries();
    stream.listen((Country _country) {
      setState(() => countries.add(_country));
    }, onError: (a) {
      print("##################");
      print("######### Error getCountries #########");
      print("##################");
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCities(String countryId) async {
    final Stream<City> stream = await getCities(countryId);
    stream.listen((City _city) {
      setState(() => cities.add(_city));
    }, onError: (a) {
      print("##################");
      print("######### Error getCities #########");
      print("##################");
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories(String cityId) async {
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

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(state.context);
    Overlay.of(state.context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      bannerSlider = <String>[];
      countries = <Country>[];
      cities = <City>[];
      categories = <Category>[];
      subCategories = <SubCategory>[];
    });
    await listenForBanners();
    await listenForCountries();
  }
}
