import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;
  Address deliveryAddress;
  List<Address> addresses = <Address>[];
  PaymentMethodList list;
  DateTime deliveryDay;

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    super.listenForCarts();
    listenForDeliveryAddressDay();
    listenForAddresses();
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
  }

  void listenForAddresses() async {
    addresses.clear();
    final Stream<Address> stream = await userRepo.getAddresses();
    stream.listen((Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      setState(() {
        listenForDeliveryAddress();
      });
      print("##################");
      print("######### Error userRepo.getAddresses with SnackBar #########");
      print("##################");
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (addresses != null && addresses.isNotEmpty) {
        var contain = addresses.where((element) => element.isDefault == true);
        if (contain.isNotEmpty && contain != null) {
          setState(() {
            this.deliveryAddress = addresses.firstWhere(
              (element) => element.isDefault == true,
            );
            settingRepo.deliveryAddress.value = addresses.firstWhere(
                  (element) => element.isDefault == true,
            );
          });
        } else {
          listenForDeliveryAddress();
        }
      } else {
        listenForDeliveryAddress();
      }
    });
  }

  void addAddress(Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        listenForAddresses();
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
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

  PaymentMethod getPickUpMethod() {
    return list.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list.pickupList.elementAt(1);
  }

  void toggleDelivery() {
    list.pickupList.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getDeliveryMethod().selected = !getDeliveryMethod().selected;
    });
  }

  PaymentMethod getSelectedMethod() {
    return list.pickupList.firstWhereOrNull((element) => element.selected);
  }

  @override
  void goCheckout(BuildContext context) {
    if (getSelectedMethod() == null) {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).select_your_delivery_address),
      ));
    } else {
      Navigator.of(state.context).pushNamed(getSelectedMethod().route);
    }
  }
}
