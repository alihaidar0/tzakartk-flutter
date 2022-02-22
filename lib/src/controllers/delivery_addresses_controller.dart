import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/address.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends ControllerMVC with ChangeNotifier {
  List<Address> addresses = <Address>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Cart cart;
  bool loadingRemoveDeliveryAddress = false;

  DeliveryAddressesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAddresses();
    listenForCart();
  }

  void listenForAddresses({String message}) async {
    addresses.clear();
    final Stream<Address> stream = await userRepo.getAddresses();
    stream.listen((Address _address) {
      setState(() {
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
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(
        message: S.of(state.context).addresses_refreshed_successfully);
  }

  void addAddress(Address address) {
    userRepo.addAddress(address).then((value) {
      listenForAddresses();
    }).whenComplete(() {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).new_address_added_successfully),
      ));
    });
  }

  void chooseDeliveryAddress(Address address) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void updateAddress(Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {});
      addresses.clear();
      listenForAddresses(
          message: S.of(state.context).the_address_updated_successfully);
    });
  }

  void removeDeliveryAddress(Address address) async {
    if (!loadingRemoveDeliveryAddress) {
      loadingRemoveDeliveryAddress = true;
      userRepo.removeDeliveryAddress(address).then(
        (value) {
          setState(() {
            this.addresses.remove(address);
          });
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(
            SnackBar(
              content: Text(
                S.of(state.context).delivery_address_removed_successfully,
              ),
            ),
          );
          loadingRemoveDeliveryAddress = false;
        },
      );
    }
  }
}
