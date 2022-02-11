import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../repository/change_location_repository.dart';
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

  void changeLocation(String cityId, {String message}) async {
    changeLocationRepo(cityId).then((value) {
      if (value) {
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 1);
      }
    }).catchError((e) {
      print("##################");
      print("######### Error changeLocation with SnackBar #########");
      print("##################");
      print(e);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    });
  }
}
