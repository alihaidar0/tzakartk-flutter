import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/CustomShoppingCartButtonWidget.dart';

import '../../generated/l10n.dart';
import '../controllers/category_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/CircularLoadingWidgetWithText.dart';
import '../elements/ProductGridItemWidget.dart';
import '../elements/ProductListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/SearchWidget.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class CategoryWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CategoryWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends StateMVC<CategoryWidget> {
  String layout = 'grid';
  CategoryController _con;

  _CategoryWidgetState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCartsCount();
    _con.listenForProductsByCategory(id: widget.routeArgument.id);
    _con.listenForCategory(id: widget.routeArgument.id);
    super.initState();
  }

  Future<void> _refreshHome() async {
    setState(() {
      _con.listenForCartsCount();
      _con.products = <Product>[];
      _con.category = new Category();
      _con.listenForProductsByCategory(id: widget.routeArgument.id);
      _con.listenForCategory(id: widget.routeArgument.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            Localizations.localeOf(context).languageCode == "en"
                ? _con.category?.en_name ?? ''
                : _con.category?.ar_name ?? '',
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 0)),
          ),
          actions: <Widget>[
            CustomShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor,
              count: _con.cartCount,
              onPressed: (){
                if (currentUser.value.apiToken != null) {
                  Navigator.of(context)
                      .pushNamed(
                    '/Cart',
                    arguments: RouteArgument(param: '/Pages', id: '1'),
                  )
                      .then((value) => _con.listenForCartsCount());
                } else {
                  Navigator.of(context)
                      .pushNamed(
                    '/Login',
                    arguments: true,
                  )
                      .then((value) {
                    if (value)
                      Navigator.of(context)
                          .pushNamed(
                        '/Cart',
                        arguments: RouteArgument(param: '/Pages', id: '1'),
                      )
                          .then((value) => _con.listenForCartsCount());
                  });
                }
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshHome,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBarWidget(
                    onTap: () {
                      Navigator.of(context)
                          .push(SearchModal(_con?.category?.id.toString()))
                          .then((value) => _con.listenForCartsCount());
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    title: Text(
                      S.of(context).products,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              this.layout = 'list';
                            });
                          },
                          icon: Icon(
                            Icons.format_list_bulleted,
                            color: this.layout == 'list'
                                ? Theme.of(context).accentColor
                                : Theme.of(context).focusColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              this.layout = 'grid';
                            });
                          },
                          icon: Icon(
                            Icons.apps,
                            color: this.layout == 'grid'
                                ? Theme.of(context).accentColor
                                : Theme.of(context).focusColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _con.products.isEmpty
                    ? CircularLoadingWidgetWithText(
                        height: 500,
                        text: S.of(context).thereAreNoProductsInThisShop,
                      )
                    : Offstage(
                        offstage: this.layout != 'list',
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.products.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return ProductListItemWidget(
                              heroTag: 'favorites_list',
                              product: _con.products.elementAt(index),
                              onTap: (RouteArgument routeArgument) {
                                Navigator.of(context)
                                    .pushNamed('/Product',
                                        arguments: routeArgument)
                                    .then(
                                        (value) => _con.listenForCartsCount());
                              },
                            );
                          },
                        ),
                      ),
                _con.products.isEmpty
                    ? CircularLoadingWidget(height: 500)
                    : Offstage(
                        offstage: this.layout != 'grid',
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 4,
                          children: List.generate(
                            _con.products.length,
                            (index) {
                              return ProductGridItemWidget(
                                heroTag: 'category_grid',
                                product: _con.products.elementAt(index),
                                onTap: (RouteArgument routeArgument) {
                                  Navigator.of(context)
                                      .pushNamed('/Product',
                                          arguments: routeArgument)
                                      .then((value) =>
                                          _con.listenForCartsCount());
                                },
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
