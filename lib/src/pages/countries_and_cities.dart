import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/countries_cities_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../library/globals.dart' as globals;
import '../models/city.dart';
import '../models/country.dart';
import '../widgets/city_container.dart';
import '../widgets/city_container_in_dialog.dart';
import '../widgets/counter_container.dart';
import '../widgets/counter_container_in_dialog.dart';

class CountriesAndCities extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CountriesAndCitiesState();
  }
}

class CountriesAndCitiesState extends StateMVC<CountriesAndCities> {
  CountriesCitiesController _con;
  Country _selectedCountry;
  City _selectedCity;

  CountriesAndCitiesState() : super(CountriesCitiesController()) {
    _con = controller;
  }

  @override
  void initState() {
    setState(() {
      if (globals.country != null) {
        _selectedCountry = globals.country;
        _con.listenForCities(globals.country.id);
      } else {
        _selectedCountry = null;
      }
      if (globals.city != null) {
        _selectedCity = globals.city;
      } else {
        _selectedCity = null;
      }
    });
    super.initState();
  }

  Future<void> _refreshHome() async {
    setState(() {
      _con.listenForCountries();
      if (_selectedCountry != null) _con.listenForCities(_selectedCountry.id);
    });
  }

  _showCountryChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Text(S.of(context).country),
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _con.countries.length,
                  (index) {
                    return Container(
                      color: _selectedCountry != null &&
                              _selectedCountry.id == _con.countries[index].id
                          ? Theme.of(context).accentColor
                          : Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: MaterialButton(
                        elevation: 0,
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        onPressed: () async {
                          setState(() {
                            _selectedCountry = _con.countries[index];
                            globals.country = _con.countries[index];
                            _selectedCity = null;
                            if (_con.countries[index] != null)
                              _con.listenForCities(_selectedCountry.id);
                          });
                          Navigator.of(context).pop();
                        },
                        child: _selectedCountry != null &&
                                _selectedCountry.id == _con.countries[index].id
                            ? CountryContainerInDialog(
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? _con.countries[index].en_name
                                    : _con.countries[index].ar_name,
                                _con.countries[index].has_media
                                    ? _con.countries[index].image.url
                                    : null,
                                35,
                                Colors.white,
                              )
                            : CountryContainerInDialog(
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? _con.countries[index].en_name
                                    : _con.countries[index].ar_name,
                                _con.countries[index].has_media
                                    ? _con.countries[index].image.url
                                    : null,
                                35,
                                Colors.black,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showCityChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Text(S.of(context).city),
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _con.cities.length,
                  (index) {
                    return Container(
                      color: _selectedCity != null &&
                              _selectedCity.id == _con.cities[index].id
                          ? Theme.of(context).accentColor
                          : Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: MaterialButton(
                        elevation: 0,
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        onPressed: () async {
                          setState(() {
                            _selectedCity = _con.cities[index];
                            globals.city = _con.cities[index];
                          });
                          Navigator.of(context).pop();
                        },
                        child: _selectedCity != null &&
                                _selectedCity.id == _con.cities[index].id
                            ? CityContainerInDialog(
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? _con.cities[index].en_name
                                    : _con.cities[index].ar_name,
                                35,
                                Colors.white,
                              )
                            : CityContainerInDialog(
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? _con.cities[index].en_name
                                    : _con.cities[index].ar_name,
                                35,
                                Colors.black,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: SafeArea(
        child: Scaffold(
          key: _con.scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              S.of(context).countriesAndCities,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshHome,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 15),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.location_city_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).countriesAndCities,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: Text(S.of(context).selectACountryAndACity),
                  ),
                  SizedBox(height: 10),

                  ///country
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      S.of(context).country + ":",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  _con.countries.isNotEmpty
                      ? Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          child: MaterialButton(
                            elevation: 0,
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            onPressed: () {
                              _showCountryChoiceDialog(context);
                            },
                            child: _selectedCountry != null
                                ? CountryContainer(
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            'en'
                                        ? _selectedCountry.en_name
                                        : _selectedCountry.ar_name,
                                    _selectedCountry.has_media
                                        ? _selectedCountry.image.url
                                        : null,
                                    35,
                                    Colors.black,
                                  )
                                : CountryContainer(
                                    null,
                                    null,
                                    35,
                                    Colors.black,
                                  ),
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                              child: MaterialButton(
                                elevation: 0,
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                onPressed: () {},
                                child: CountryContainer(
                                  null,
                                  null,
                                  35,
                                  Colors.black38,
                                ),
                              ),
                            ),
                            CircularLoadingWidget(
                              height: 35.0,
                            ),
                          ],
                        ),
                  SizedBox(height: 25),

                  ///city
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      S.of(context).city + ":",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  _con.cities.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          child: MaterialButton(
                            elevation: 0,
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            onPressed: () {
                              _showCityChoiceDialog(context);
                            },
                            child: _selectedCity != null
                                ? CityContainer(
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            'en'
                                        ? _selectedCity.en_name
                                        : _selectedCity.ar_name,
                                    35,
                                    Colors.black,
                                  )
                                : CityContainer(
                                    "",
                                    35,
                                    Colors.black,
                                  ),
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                              child: MaterialButton(
                                elevation: 0,
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                onPressed: () {},
                                child: CityContainer(
                                  "",
                                  35,
                                  Colors.black38,
                                ),
                              ),
                            ),
                            CircularLoadingWidget(
                              height: 35.0,
                            ),
                          ],
                        ),
                  SizedBox(height: 50),

                  ///confirm
                  MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      if (_selectedCountry != null &&
                          _selectedCity != null &&
                          _selectedCountry.id != null &&
                          _selectedCity.id != null) {
                        globals.country = _selectedCountry;
                        globals.city = _selectedCity;
                        _con.changeLocation(_selectedCity.id.toString());
                      }
                    },
                    child: Center(
                      child: Text(
                        S.of(context).confirm,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
