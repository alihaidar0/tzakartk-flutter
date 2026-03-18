import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart' as model;
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  model.User user = new model.User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void login(bool mustBack) async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.login(user).then((value) {
        print("######### value in login #########");
        print("${value}");
        print("##################");
        if (value != null && value.apiToken != null) {
          if (mustBack != null && mustBack) {
            Navigator.of(scaffoldKey.currentContext).pop(true);
          } else {
            Navigator.of(scaffoldKey.currentContext).pushNamedAndRemoveUntil(
                '/Pages', (Route<dynamic> route) => false,
                arguments: 1);
          }
        } else {
          ScaffoldMessenger.of(scaffoldKey?.currentContext)
              .showSnackBar(SnackBar(
            content: Text(
              S
                  .of(state.context)
                  .make_sure_that_you_confirmed_your_Email_or_that_your_email_and_password_is_not_wrong,
            ),
          ));
        }
      }).catchError((e) {
        print("######### catchError in login #########");
        print("${e}");
        print("##################");
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_account_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void register() async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    Overlay.of(state.context).insert(loader);
    repository.register(user).then((value) {
      if (value != null && value == true) {
        print("######### value in register #########");
        print("${value}");
        print("##################");
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Login', arguments: false);
      } else {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).wrong_email_or_password),
        ));
      }
    }).catchError((e) {
      print("######### catchError in register #########");
      print("${e}");
      print("##################");
      loader.remove();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).this_email_account_exists),
      ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void resetPassword() {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          ScaffoldMessenger.of(scaffoldKey?.currentContext)
              .showSnackBar(SnackBar(
            content: Text(S
                .of(state.context)
                .your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(state.context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login', arguments: false);
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          ScaffoldMessenger.of(scaffoldKey?.currentContext)
              .showSnackBar(SnackBar(
            content: Text(S.of(state.context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
