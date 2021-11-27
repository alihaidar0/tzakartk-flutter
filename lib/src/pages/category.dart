import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/category_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ProductGridItemWidget.dart';
import '../elements/ProductListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
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
    _con.listenForProductsByCategory(id: widget.routeArgument.id);
    _con.listenForCategory(id: widget.routeArgument.id);
    _con.listenForCart();
    super.initState();
  }

  Future<void> _refreshHome() async {
    setState(() {
      _con.products = <Product>[];
      _con.category = new Category();
      _con.listenForProductsByCategory(id: widget.routeArgument.id);
      _con.listenForCategory(id: widget.routeArgument.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).category,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.5, vertical: 15),
                  child: SizedBox(
                    width: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).accentColor),
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
                  categoryId: _con?.category?.id.toString(),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  title: Text(
                    Localizations.localeOf(context).languageCode == "en"
                        ? _con.category?.en_name ?? ''
                        : _con.category?.ar_name ?? '',
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
                  ? CircularLoadingWidget(height: 500)
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
                              onPressed: () {
                                if (currentUser.value.apiToken == null) {
                                  Navigator.of(context).pushNamed('/Login');
                                } else {
                                  _con.addToCart(
                                    _con.products.elementAt(index),
                                  );
                                }
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
    );
  }
}
