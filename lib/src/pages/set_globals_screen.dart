import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../controllers/countries_cities_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../library/globals.dart' as globals;
import '../models/city.dart';
import '../models/country.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../widgets/city_container.dart';
import '../widgets/city_container_in_dialog.dart';
import '../widgets/counter_container.dart';
import '../widgets/counter_container_in_dialog.dart';
import '../widgets/language_container.dart';
import '../widgets/language_container_in_Dialog.dart';

class SetGlobalsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SetGlobalsScreenState();
  }
}

class SetGlobalsScreenState extends StateMVC<SetGlobalsScreen> {
  CountriesCitiesController _con;
  Country _selectedCountry;
  City _selectedCity;
  bool _load = false;

  SetGlobalsScreenState() : super(CountriesCitiesController()) {
    _con = controller;
  }

  @override
  void initState() {
    _selectedCountry = null;
    _selectedCity = null;
    _load = false;
    super.initState();
  }

  _showLanguageChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Text(S.of(context).languages),
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Localizations.localeOf(context).languageCode == "ar"
                        ? Theme.of(context).accentColor
                        : Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: MaterialButton(
                      elevation: 0,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      onPressed: () async {
                        settingsRepo.setting.value.mobileLanguage.value =
                            new Locale('ar');
                        settingsRepo.setting.notifyListeners();
                        Navigator.pop(context);
                      },
                      child:
                          Localizations.localeOf(context).languageCode == "ar"
                              ? LanguageContainerInDialog(S.of(context).arabic,
                                  "assets/img/arabic.png", 35, Colors.white)
                              : LanguageContainerInDialog(S.of(context).arabic,
                                  "assets/img/arabic.png", 35, Colors.black),
                    ),
                  ),
                  Container(
                    color: Localizations.localeOf(context).languageCode == "en"
                        ? Theme.of(context).accentColor
                        : Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: MaterialButton(
                      elevation: 0,
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      onPressed: () async {
                        settingsRepo.setting.value.mobileLanguage.value =
                            new Locale('en');
                        settingsRepo.setting.notifyListeners();
                        Navigator.pop(context);
                      },
                      child:
                          Localizations.localeOf(context).languageCode == "en"
                              ? LanguageContainerInDialog(S.of(context).english,
                                  "assets/img/english.png", 35, Colors.white)
                              : LanguageContainerInDialog(S.of(context).english,
                                  "assets/img/english.png", 35, Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                      color: _selectedCountry == _con.countries[index]
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
                            _con.cities = [];
                            _selectedCity = null;
                            _con.listenForCities(_selectedCountry.id);
                            _load = true;
                          });
                          Navigator.of(context).pop();
                        },
                        child: _selectedCountry == _con.countries[index]
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
                      color: _selectedCity == _con.cities[index]
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
                          });
                          Navigator.of(context).pop();
                        },
                        child: _selectedCity == _con.cities[index]
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
          resizeToAvoidBottomInset: false,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).accentColor,
                  const Color(0xFF220236),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            padding: EdgeInsets.only(
                left: 25.0, top: 30.0, right: 25.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Center(
                    child: settingsRepo.setting.value.on_loading_image != null
                        ? settingsRepo.setting.value.on_loading_image
                                .toLowerCase()
                                .endsWith('.svg')
                            ? SvgPicture.network(
                                settingsRepo.setting.value.on_loading_image,
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    settingsRepo.setting.value.on_loading_image,
                              )
                        : SizedBox(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Center(
                        child: settingsRepo.setting.value.mobile_logo != null
                            ? settingsRepo.setting.value.mobile_logo
                                    .toLowerCase()
                                    .endsWith('.svg')
                                ? SvgPicture.network(
                                    settingsRepo.setting.value.mobile_logo,
                                  )
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        settingsRepo.setting.value.mobile_logo,
                                  )
                            : SizedBox(),
                      ),
                    ),

                    ///language
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        S.of(context).language + ":",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: MaterialButton(
                        elevation: 0,
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        onPressed: () {
                          _showLanguageChoiceDialog(context);
                        },
                        child:
                            Localizations.localeOf(context).languageCode == 'en'
                                ? LanguageContainer(
                                    S.of(context).english,
                                    "assets/img/english.png",
                                    40,
                                  )
                                : LanguageContainer(
                                    S.of(context).arabic,
                                    "assets/img/arabic.png",
                                    40,
                                  ),
                      ),
                    ),

                    ///country
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        S.of(context).country + ":",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _con.countries.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white,
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
                                      40,
                                      Colors.white,
                                    )
                                  : CountryContainer(
                                      null,
                                      null,
                                      40,
                                      Colors.white,
                                    ),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                child: MaterialButton(
                                  elevation: 0,
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  onPressed: () {},
                                  child: CountryContainer(
                                    null,
                                    null,
                                    40,
                                    Colors.white38,
                                  ),
                                ),
                              ),
                              CircularLoadingWidget(
                                height: 40.0,
                              ),
                            ],
                          ),

                    ///city
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        S.of(context).city + ":",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _con.cities.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white,
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
                                      40,
                                      Colors.white,
                                    )
                                  : CityContainer(
                                      "",
                                      40,
                                      Colors.white,
                                    ),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                child: MaterialButton(
                                  elevation: 0,
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  onPressed: () {},
                                  child: CityContainer(
                                    "",
                                    40,
                                    Colors.white38,
                                  ),
                                ),
                              ),
                              _load
                                  ? CircularLoadingWidget(
                                      height: 40.0,
                                    )
                                  : SizedBox(),
                            ],
                          ),

                    ///confirm
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: MaterialButton(
                        elevation: 0,
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        onPressed: () {
                          if (_selectedCountry != null &&
                              _selectedCity != null) {
                            globals.country = _selectedCountry;
                            globals.city = _selectedCity;
                            Navigator.of(context)
                                .pushReplacementNamed('/Pages', arguments: 1);
                          }
                        },
                        child: Center(
                          child: Text(
                            S.of(context).confirm,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Powered By",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () => launch('https://vroad.com'),
                            child: Text(
                              "VRoad LLC",
                              style: TextStyle(
                                  color: Color(0xFFF69BF0), fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
