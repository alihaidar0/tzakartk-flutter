import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CategoriesCarouselWidget.dart';
import '../elements/HomeBannerSliderWidget.dart';
import '../elements/HomeOurNewSliderWidget.dart';
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

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    setState(() {
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
      _con.refreshHome;
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
                SizedBox(height: 20,),
                HomeOurNewSliderWidget(
                  slides: _con.ourNewSlider,
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
                            _con.subCategories.clear();
                            // if (categoryId != null) {
                            //   _selectedCategoryId = categoryId;
                            _con.listenForSubCategories(categoryId);
                            // }
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
