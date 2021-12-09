import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/CreditCardsWidget.dart';
import '../helpers/helper.dart';

class CheckoutWidget extends StatefulWidget {
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends StateMVC<CheckoutWidget> {
  CheckoutController _con;

  _CheckoutWidgetState() : super(CheckoutController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).checkout,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: _con.carts.isEmpty
            ? CircularLoadingWidget(height: 400)
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 185),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.payment,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).payment_mode,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                S
                                    .of(context)
                                    .select_your_preferred_payment_mode,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          new CreditCardsWidget(
                            creditCard: _con.creditCard,
                            onChanged: (creditCard) {
                              _con.updateCreditCard(creditCard);
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 215,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                blurRadius: 5.0)
                          ]),
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
                                    S.of(context).subtotal,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(_con.subTotal, context,
                                    style:
                                        Theme.of(context).textTheme.subtitle1)
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).delivery_fee,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(
                                  _con.deliveryFee,
                                  context,
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).couponDiscount,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(
                                  _con.couponDiscount,
                                  context,
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              ],
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).total,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Helper.getPrice(_con.total, context,
                                    style:
                                        Theme.of(context).textTheme.headline6)
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: MaterialButton(
                                elevation: 0,
                                onPressed: () {
                                  if (_con.creditCard.validated()) {
                                    _con.addOrder();
                                  } else {
                                    ScaffoldMessenger.of(
                                            _con.scaffoldKey?.currentContext)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          S
                                              .of(context)
                                              .your_credit_card_not_valid,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                padding: EdgeInsets.symmetric(vertical: 14),
                                color: Theme.of(context).accentColor,
                                shape: StadiumBorder(),
                                child: Text(
                                  S.of(context).confirm_payment,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
