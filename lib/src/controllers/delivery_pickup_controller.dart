import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Address> addresses = <Address>[];
  PaymentMethodList list;
  DateTime deliveryDay;

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    super.listenForCarts();
    listenForDeliveryAddressDay();
    listenForAddresses();
  }

  void listenForAddresses() async {
    addresses.clear();
    final Stream<Address> stream = await userRepo.getAddresses();
    stream.listen((Address _address) {
      setState(() {
        if( isSame(_address, settingRepo.deliveryAddress.value)) {
          _address.selected = true;
        }
        addresses.add(_address);
      });
    }, onError: (a) {
      print("##################");
      print("######### Error userRepo.getAddresses with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    });
  }

  bool isSame(Address address_1, Address address_2) {
    if (address_1.id == address_2.id &&
        address_1.description == address_2.description &&
        address_1.address == address_2.address &&
        address_1.receiver_name == address_2.receiver_name &&
        address_1.receiver_phone == address_2.receiver_phone &&
        address_1.cityId == address_2.cityId &&
        address_1.isDefault == address_2.isDefault &&
        address_1.userId == address_2.userId)
      return true;
    else {
      return false;
    }
  }

  void addAddress(Address address) {
    userRepo.addAddress(address).then((value) {
        listenForAddresses();
    }).whenComplete(() {
      listenForAddresses();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(Address address) {
    userRepo.updateAddress(address).then((value) {
        listenForAddresses();
    }).whenComplete(() {
      listenForAddresses();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).the_address_updated_successfully),
      ));
    });
  }

  void listenForDeliveryAddressDay() {
    this.deliveryDay = settingRepo.deliveryDay.value;
  }

  void updateDeliveryDay(DateTime date) {
    setState(() {
      this.deliveryDay = date;
      settingRepo.deliveryDay.value = date;
    });
  }

  void toggleDelivery(Address address) {
    setState(() {
      addresses.forEach((element) {
        if (element != address) element.selected = false;
      });
      address.selected = !address.selected;
      settingRepo.deliveryAddress.value = address;
    });
  }

  PaymentMethod getSelectedMethod() {
    return list.deliveryMethod;
  }

  @override
  void goCheckout(BuildContext context) {
    Address _address = addresses.firstWhere((element) => element.selected == true ,orElse: () => null,);
    if (_address != null &&
        settingRepo.deliveryAddress.value != null &&
        isSame(_address, settingRepo.deliveryAddress.value)) {
      Navigator.of(state.context).pushNamed(getSelectedMethod().route);
    } else {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).select_your_delivery_address),
      ));
    }
  }
}
