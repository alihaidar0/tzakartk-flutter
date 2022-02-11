import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CategoriesCarouselWidget.dart';
import '../elements/HomeBannerSliderWidget.dart';
import '../elements/OurNewCarouselWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../elements/SubCategoriesCarouselWidget.dart';
import '../library/globals.dart' as globals;
import '../models/city.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  City _selectedCity;
  String _selectedCategoryId;
  bool loadSubCategory;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    setState(() {
      loadSubCategory = false;
      if (globals.city != null && globals.city.id != null) {
        _selectedCity = globals.city;
        _con.changeLocation(_selectedCity.id.toString());
        _con.listenForCategories(globals.city.id);
      } else {
        _selectedCity = null;
      }
      _selectedCategoryId = null;
    });
    super.initState();
  }

  Future<void> _refreshHome() async {
    setState(
      () {
        loadSubCategory = false;
        _con.bannerSlider.clear();
        _con.ourNewSlider.clear();
        _con.categories.clear();
        _con.subCategories.clear();
        _con.listenForBanners();
        _con.listenForOurNew();
        if (_selectedCity != null && _selectedCity.id != null) {
          _con.changeLocation(_selectedCity.id.toString());
          _con.listenForCategories(_selectedCity.id);
        }
        if (_selectedCategoryId != null) {
          _con.listenForSubCategories(_selectedCategoryId);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              labelColor: Theme.of(context).accentColor,
            ),
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
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.only(
                        left: 20.0, top: 10.0, right: 20.0, bottom: 5.0),
                    title: Text(
                      S.of(context).upToDate,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  OurNewCarouselWidget(
                    slides: _con.ourNewSlider,
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.only(
                        left: 20.0, top: 10.0, right: 20.0, bottom: 5.0),
                    title: Text(
                      S.of(context).shopsCategories,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  _selectedCity != null
                      ? CategoriesCarouselWidget(
                          categories: _con.categories,
                          selected: _con.selected,
                          onPressed: (String categoryId, int index) {
                            setState(() {
                              loadSubCategory = true;
                              _con.subCategories.clear();
                              if (_con.selected.length>0 )
                                {
                                  _con.selected = List.generate(_con.categories.length, (index) => false);
                                }
                              if (index != null && _con.selected.isNotEmpty)
                                _con.selected[index] = true;
                              _con.listenForSubCategories(categoryId);
                            });
                          },
                        )
                      : SizedBox(),
                  loadSubCategory
                      ? ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.only(
                              left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
                          title: Text(
                            S.of(context).shops,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        )
                      : SizedBox(height: 0, width: 0),
                  loadSubCategory
                      ? SubCategoriesCarouselWidget(
                          subCategories: _con.subCategories,
                        )
                      : SizedBox(height: 0, width: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
