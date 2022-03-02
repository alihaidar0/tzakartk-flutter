import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../repository/coupon_repository.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import '../library/receiver_info.dart' as receiverInfo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  CreditCard creditCard = new CreditCard();
  bool loading = true;
  OverlayEntry loader;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
    getCoupon();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  void addOrder() async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    Overlay.of(state.context).insert(loader);
    Order _order = new Order();
    Payment _payment = Payment('Credit Card (Stripe Gateway)');
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryAddress = settingRepo.deliveryAddress.value;
    _order.hint = receiverInfo.note;
    _order.receiverName = receiverInfo.receiverName;
    _order.receiverPhone = receiverInfo.receiverPhone;
    _order.deliveryDate = settingRepo.deliveryDay.value;
    _order.coupon = settingRepo.coupon.code;
    orderRepo.addOrder(_order, _payment).then((value) async {
      return value;
    }).then((value) {
      print("######### value in addOrder #########");
      print("${value}");
      print("##################");
      if (value != null && value == true) {
        settingRepo.coupon = new Coupon.fromJSON({});
        saveCoupon(settingRepo.coupon);
        Navigator.of(scaffoldKey.currentContext).pushNamedAndRemoveUntil(
          '/OrderSuccess',
          (Route<dynamic> route) => false,
        );
      } else {
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(
            S.of(state.context).your_credit_card_not_valid,
          ),
        ));
      }
    }).catchError((e) {
      print("######### catchError in addOrder #########");
      print("${e}");
      print("##################");
      loader.remove();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(
          S.of(state.context).your_credit_card_not_valid,
        ),
      ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).payment_card_updated_successfully),
      ));
    });
  }
}
