import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/DatePickerWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/ShopWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../library/globals.dart' as globals;
import '../library/receiver_info.dart' as receiverInfo;
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _con.listenForNote();
      await _con.listenForDelivery();
      if (_con.freeDelivery && _con.note != null)
        createAlertDialog(
            context,
            Localizations.localeOf(context).languageCode == "en"
                ? _con.note.freeDeliveryNote.english_note
                : _con.note.freeDeliveryNote.arabic_note);
    });
  }

  createAlertDialog(BuildContext context, String note) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              S.of(context).note,
              style: Theme.of(context).textTheme.headline6,
            ),
            content: Text(
              note,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.of(context).ok,
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            ],
          );
        });
  }

  InputDecoration getInputDecoration(
      {String hintText, String labelText, String prefixText}) {
    return new InputDecoration(
      prefixText: prefixText,
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
    }
    return SafeArea(
      child: Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: CartBottomDetailsWidget(con: _con),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).delivery,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ],
        ),
        floatingActionButton: _con.freeDelivery
            ? SizedBox(
                height: 0,
                width: 0,
              )
            : FloatingActionButton(
                onPressed: () async {
                  await createAlertDialog(
                      context,
                      Localizations.localeOf(context).languageCode == "en"
                          ? _con.note.deliveryNote.english_note
                          : _con.note.deliveryNote.arabic_note);
                  Address _newAddress = new Address();
                  DeliveryAddressDialog(
                    context: context,
                    address: _newAddress,
                    onChanged: (Address _address) {
                      _con.addAddress(_address);
                    },
                  );
                },
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                ),
              ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.map_outlined,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).delivery_date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    S.of(context).select_a_delivery_date,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              Center(
                child: DatePickerWidget(
                  deliveryDay: _con.deliveryDay,
                  onChanged: (deliveryDay) {
                    _con.updateDeliveryDay(deliveryDay);
                  },
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                  child: Column(
                    children: [
                      !_con.freeDelivery
                          ? SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : new TextFormField(
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                              keyboardType: TextInputType.text,
                              decoration: getInputDecoration(
                                labelText: S.of(context).receiverFullName,
                              ),
                              // initialValue: receiverInfo.receiverName,
                              onChanged: (input) {
                                setState(() {
                                  receiverInfo.receiverName = input;
                                });
                              },
                            ),
                      !_con.freeDelivery
                          ? SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : new TextFormField(
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                              keyboardType: TextInputType.phone,
                              decoration: getInputDecoration(
                                  labelText: S.of(context).receiver_phone,
                                  prefixText: "${globals.country.code} "),
                              // initialValue:
                              //     receiverInfo.receiverPhone.length > 4
                              //         ? receiverInfo.receiverPhone.substring(4)
                              //         : '',
                              // validator: (input) {
                              //   input = input.replaceAll(' ', '');
                              //   input = "${globals.country.code}" + input;
                              //   return 11 <= input.length && 12 >= input.length
                              //       ? null
                              //       : "Should be valid mobile number";
                              // },
                              onChanged: (input) {
                                setState(() {
                                  input = input.replaceAll(' ', '');
                                  input = "${globals.country.code}" + input;
                                  receiverInfo.receiverPhone = input;
                                });
                              },
                            ),
                      new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                          labelText: S.of(context).note,
                        ),
                        // initialValue: receiverInfo.note,
                        onChanged: (input) {
                          setState(() {
                            receiverInfo.note = input;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              _con.freeDelivery
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 10, left: 20, right: 10),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.map_outlined,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).delivery_address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            S
                                .of(context)
                                .click_to_confirm_your_address_and_pay_or_long_press_or_swipe,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          )),
                    ),
              !_con.freeDelivery
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 0, left: 20, right: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.map_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          S.of(context).shops,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
              _con.shops.isEmpty || !_con.freeDelivery
                  ? SizedBox()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.shops.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return ShopWidget(
                          shop: _con.shops.elementAt(index),
                        );
                      },
                    ),
              _con.addresses.isEmpty || _con.freeDelivery
                  ? SizedBox()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.addresses.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return DeliveryAddressesItemWidget(
                          address: _con.addresses.elementAt(index),
                          onPressed: (Address _address) async {
                            if (_con.addresses.elementAt(index).id == null ||
                                _con.addresses.elementAt(index).id == 'null') {
                              DeliveryAddressDialog(
                                context: context,
                                address: _address,
                                onChanged: (Address _address) {
                                  _con.updateAddress(_address);
                                },
                              );
                            } else {
                              await createAlertDialog(
                                  context,
                                  Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? _con.note.deliveryNote.english_note
                                      : _con.note.deliveryNote.arabic_note);
                              receiverInfo.receiverName = _con.addresses.elementAt(index).receiver_name;
                              receiverInfo.receiverPhone = _con.addresses.elementAt(index).receiver_phone;
                              _con.toggleDelivery(
                                  _con.addresses.elementAt(index));
                            }
                          },
                          onLongPress: (Address _address) {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.updateAddress(_address);
                              },
                            );
                          },
                          onDismissed: (Address _address) {
                            _con.removeDeliveryAddress(_address);
                          },
                        );
                      },
                    ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
