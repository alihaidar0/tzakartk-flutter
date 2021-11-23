import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CategoriesCarouselWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/HomeBannerSliderWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../elements/SubCategoriesCarouselWidget.dart';
import '../library/globals.dart' as globals;
import '../models/category.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/sub_category.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../widgets/city_container.dart';
import '../widgets/city_container_in_dialog.dart';
import '../widgets/counter_container.dart';
import '../widgets/counter_container_in_dialog.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  Country _selectedCountry;
  City _selectedCity;
  String _selectedCategoryId;

  _HomeWidgetState() : super(HomeController()) {
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
        _con.listenForCategories(globals.city.id);
        _con.listenForSubCategoriesByCity(globals.city.id);
      } else {
        _selectedCity = null;
      }
      _selectedCategoryId = null;
    });
    super.initState();
  }

  Future<void> _refreshHome() async {
    setState(() {
      _con.bannerSlider = <String>[];
      _con.countries = <Country>[];
      _con.cities = <City>[];
      _con.categories = <Category>[];
      _con.subCategories = <SubCategory>[];
      _con.listenForBanners();
      _con.listenForCountries();
      if (_selectedCountry != null) _con.listenForCities(_selectedCountry.id);
      if (_selectedCity != null) _con.listenForCategories(_selectedCity.id);
      if (_selectedCategoryId != null) {
        _con.listenForSubCategories(_selectedCategoryId);
      } else {
        if (_selectedCity != null) {
          _con.listenForSubCategoriesByCity(globals.city.id);
        }
      }
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
                            ;
                            _selectedCity = null;
                            _selectedCategoryId = null;
                            _con.cities = [];
                            _con.categories = <Category>[];
                            _con.subCategories = <SubCategory>[];
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
                            _selectedCategoryId = null;
                            _con.categories = <Category>[];
                            _con.subCategories = <SubCategory>[];
                            if (_con.cities[index] != null) {
                              _con.listenForCategories(_con.cities[index].id);
                            }
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
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                HomeBannerSliderWidget(
                  slides: _con.bannerSlider,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: _con.countries.isNotEmpty
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
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      onPressed: () {},
                                      child: CountryContainer(
                                        null,
                                        null,
                                        35,
                                        Colors.white38,
                                      ),
                                    ),
                                  ),
                                  CircularLoadingWidget(
                                    height: 35.0,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: _con.cities.isNotEmpty
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
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      onPressed: () {},
                                      child: CityContainer(
                                        "",
                                        35,
                                        Colors.black38,
                                      ),
                                    ),
                                  ),
                                  CircularLoadingWidget(
                                    height: 40.0,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 5.0),
                  leading: Icon(
                    Icons.category_outlined,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).product_categories,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                _selectedCity != null
                    ? CategoriesCarouselWidget(
                        categories: _con.categories,
                        onPressed: (String categoryId) {
                          setState(() {
                            _con.subCategories = <SubCategory>[];
                            if (categoryId != null)
                              _selectedCategoryId = categoryId;
                            _con.listenForSubCategories(categoryId);
                          });
                        },
                      )
                    : SizedBox(),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(
                      left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
                  leading: Icon(
                    Icons.category_outlined,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).shops,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SubCategoriesCarouselWidget(
                  subCategories: _con.subCategories,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
