import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../repository/order_repository.dart';

class TrackingController extends ControllerMVC {
  Order order;
  List<OrderStatus> orderTrack = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder(String orderId) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
      });
    }, onError: (a) {
      print("##################");
      print("######### Error getOrder with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      listenForOrderTrack(orderId);
    });
  }

  void listenForOrderTrack(String orderId) async {
    final Stream<OrderStatus> stream = await getOrderTrack(orderId);
    stream.listen((OrderStatus _orderStatus) {
      setState(() {
        orderTrack.add(_orderStatus);
      });
    }, onError: (a) {
      print("##################");
      print("######### Error getOrderTrack #########");
      print("##################");
      print(a);
    }, onDone: () {});
  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _trackSteps = [];
    this.orderTrack.forEach((OrderStatus _orderStatus) {
      _trackSteps.add(Step(
        state: _orderStatus != 2 ? StepState.complete : StepState.error,
        title: Text(
          Localizations.localeOf(context).languageCode == 'en'
              ? _orderStatus.status
              : _orderStatus.ar_status,
          style: Theme.of(state.context).textTheme.subtitle1,
        ),
        content: SizedBox(
          height: 0,
          width: double.infinity,
        ),
        isActive: _orderStatus.flag == 0 ? true : false,
      ));
    });
    return _trackSteps;
  }
}
