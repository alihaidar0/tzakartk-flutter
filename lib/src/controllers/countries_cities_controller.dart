import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/city.dart';
import '../models/country.dart';
import '../repository/city_repository.dart';
import '../repository/country_repository.dart';

class CountriesCitiesController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Country> countries = <Country>[];
  List<City> cities = <City>[];

  CountriesCitiesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCountries();
  }

  Future<void> listenForCountries() async {
    countries.clear();
    final Stream<Country> stream = await getCountries();
    stream.listen((Country _country) {
      setState(() => countries.add(_country));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCities(String countryId) async {
    cities.clear();
    final Stream<City> stream = await getCities(countryId);
    stream.listen((City _city) {
      setState(() => cities.add(_city));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshHome() async {
    setState(() {
      countries.clear();
      cities.clear();
    });
    await listenForCountries();
  }
}
