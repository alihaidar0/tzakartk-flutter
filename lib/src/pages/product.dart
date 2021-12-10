import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/product_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OptionItemWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/media.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

// ignore: must_be_immutable
class ProductWidget extends StatefulWidget {
  RouteArgument routeArgument;

  ProductWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ProductWidgetState createState() {
    return _ProductWidgetState();
  }
}

class _ProductWidgetState extends StateMVC<ProductWidget> {
  ProductController _con;

  _ProductWidgetState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProduct(productId: widget.routeArgument.id);
    _con.listenForCart();
    super.initState();
  }

  Future<void> _refreshHome() async {
    setState(() {
      _con.product = null;
      _con.listenForProduct(productId: widget.routeArgument.id);
      _con.listenForCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _con.scaffoldKey,
        body: _con.product == null
            ? CircularLoadingWidget(height: 500)
            : RefreshIndicator(
                onRefresh: _refreshHome,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 125),
                      padding: EdgeInsets.only(bottom: 15),
                      child: CustomScrollView(
                        primary: true,
                        shrinkWrap: false,
                        slivers: <Widget>[
                          SliverAppBar(
                            backgroundColor: Theme.of(context)
                                .accentColor
                                .withOpacity(0.9),
                            expandedHeight: 275,
                            elevation: 0,
                            iconTheme: IconThemeData(
                                color: Theme.of(context).primaryColor),
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              background: Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: _con.product.images.length > 1
                                          ? true
                                          : false,
                                      autoPlayInterval: Duration(seconds: 7),
                                      height: 300,
                                      viewportFraction: 1.0,
                                      enableInfiniteScroll: false,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _con.current = index;
                                        });
                                      },
                                    ),
                                    items: _con.product.images
                                        .map((Media image) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return CachedNetworkImage(
                                            height: 300,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            imageUrl: image.url,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/img/loading.gif',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 300,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error_outline),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 22, horizontal: 42),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: _con.product.images
                                          .map((Media image) {
                                        return Container(
                                          width: 20.0,
                                          height: 5.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20.0,
                                              horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: _con.current ==
                                                      _con.product.images
                                                          .indexOf(image)
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Wrap(
                                runSpacing: 8,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? _con.product?.en_name ??
                                                      ''
                                                  : _con.product?.ar_name ??
                                                      '',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                            Text(
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? _con.product.category
                                                          .en_name ??
                                                      ''
                                                  : _con.product.category
                                                          .ar_name ??
                                                      '',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Helper.getPrice(
                                              _con.product.price,
                                              context,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2,
                                            ),
                                            _con.product.featured &&
                                                    _con.product
                                                            .discountPrice >
                                                        0
                                                ? Helper.getPrice(
                                                    _con.product
                                                        .discountPrice,
                                                    context,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .merge(
                                                          TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        ),
                                                  )
                                                : SizedBox(height: 0),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _con.product.capacity != null &&
                                          _con.product.capacity != '' &&
                                          _con.product.unit != null &&
                                          _con.product.unit != '' &&
                                          _con.product.packageItemsCount !=
                                              null &&
                                          _con.product.packageItemsCount != ''
                                      ? Row(
                                          children: <Widget>[
                                            _con.product.capacity != null &&
                                                    _con.product.capacity !=
                                                        'null' &&
                                                    _con.product.capacity !=
                                                        '' &&
                                                    _con.product.unit !=
                                                        null &&
                                                    _con.product.unit !=
                                                        'null' &&
                                                    _con.product.unit != ''
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .focusColor,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(24),
                                                    ),
                                                    child: Text(
                                                      _con.product.capacity +
                                                          " " +
                                                          _con.product.unit,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .merge(TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 0,
                                                    width: 0,
                                                  ),
                                            SizedBox(height: 0, width: 5),
                                            _con.product.packageItemsCount !=
                                                        null &&
                                                    _con.product
                                                            .packageItemsCount !=
                                                        'null' &&
                                                    _con.product
                                                            .packageItemsCount !=
                                                        ''
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 3),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Theme.of(context)
                                                                .focusColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    24)),
                                                    child: Text(
                                                      _con.product
                                                              .packageItemsCount.toString() +
                                                          " " +
                                                          S.of(context).items,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .merge(TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 0,
                                                    width: 0,
                                                  ),
                                          ],
                                        )
                                      : SizedBox(
                                          height: 0,
                                          width: 0,
                                        ),
                                  Divider(height: 20),
                                  Text(
                                    Helper.skipHtml(
                                      Localizations.localeOf(context)
                                                  .languageCode ==
                                              'en'
                                          ? _con.product.en_description
                                          : _con.product.ar_description,
                                    ),
                                  ),
                                  _con.product.optionGroups.isEmpty ||
                                          _con.product.optionGroups == null
                                      ? CircularLoadingWidget(height: 100)
                                      : ListView.separated(
                                          padding: EdgeInsets.all(0),
                                          itemBuilder:
                                              (context, optionGroupIndex) {
                                            var _optionGroup = _con
                                                .product.optionGroups
                                                .elementAt(optionGroupIndex);
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          'en'
                                                      ? _optionGroup.en_name
                                                      : _optionGroup.ar_name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                                Wrap(
                                                  children: List.generate(
                                                    _con.product.options
                                                        .where((option) =>
                                                            option
                                                                .optionGroupId ==
                                                            _optionGroup.id)
                                                        .length,
                                                    (optionIndex) {
                                                      var _option = _con
                                                          .product.options
                                                          .where((option) =>
                                                              option
                                                                  .optionGroupId ==
                                                              _optionGroup.id)
                                                          .elementAt(
                                                              optionIndex);
                                                      return OptionItemWidget(
                                                          optionGroup:
                                                              _optionGroup,
                                                          options: _con
                                                              .product
                                                              .options,
                                                          option: _option,
                                                          onChanged: _con
                                                              .calculateTotal);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 20);
                                          },
                                          itemCount: _con
                                              .product.optionGroups.length,
                                          primary: false,
                                          shrinkWrap: true,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right:
                          Localizations.localeOf(context).languageCode == 'en'
                              ? 20
                              : null,
                      left:
                          Localizations.localeOf(context).languageCode == 'en'
                              ? null
                              : 20,
                      child: _con.loadCart
                          ? SizedBox(
                              width: 60,
                              height: 60,
                              child: RefreshProgressIndicator(),
                            )
                          : ShoppingCartFloatButtonWidget(
                              iconColor: Theme.of(context).primaryColor,
                              labelColor: Theme.of(context).hintColor,
                              routeArgument: RouteArgument(
                                  param: '/Product', id: _con.product.id),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 130,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.15),
                              offset: Offset(0, -2),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).quantity,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          _con.decrementQuantity();
                                        },
                                        iconSize: 30,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        icon:
                                            Icon(Icons.remove_circle_outline),
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Text(
                                        _con.quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _con.incrementQuantity();
                                        },
                                        iconSize: 30,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        icon: Icon(Icons.add_circle_outline),
                                        color: Theme.of(context).hintColor,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Stack(
                                  fit: StackFit.loose,
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: <Widget>[
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width -
                                              110,
                                      child: MaterialButton(
                                        elevation: 0,
                                        onPressed: () {
                                          if (currentUser.value.apiToken ==
                                              null) {
                                            Navigator.of(context)
                                                .pushNamed("/Login");
                                          } else {
                                            _con.addToCart(_con.product);
                                          }
                                        },
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14),
                                        color: Theme.of(context).accentColor,
                                        shape: StadiumBorder(),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Text(
                                            S.of(context).add_to_cart,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Helper.getPrice(
                                        _con.total,
                                        context,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .merge(
                                              TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
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
