import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tzakartk/src/elements/CircularLoadingWidget.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/DatePickerWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
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
                    S.of(context).delivery_day,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    S.of(context).select_a_delivery_day,
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
              SizedBox(
                height: 15,
              ),
              Padding(
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
                          .click_to_confirm_your_address_and_pay_or_long_press,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    )),
              ),
              _con.addresses.isEmpty
                  ? CircularLoadingWidget(height: 250)
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
                          onPressed: (Address _address) {
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
