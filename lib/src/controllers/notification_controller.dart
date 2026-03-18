import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/notification.dart' as model;
import '../repository/notification_repository.dart';

class NotificationController extends ControllerMVC {
  List<model.Notification> notifications = <model.Notification>[];
  int unReadNotificationsCount = 0;
  GlobalKey<ScaffoldState> scaffoldKey;

  NotificationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForNotifications();
  }

  void listenForNotifications({String message}) async {
    notifications.clear();
    final Stream<model.Notification> stream = await getNotifications();
    stream.listen((model.Notification _notification) {
      setState(() {
        notifications.add(_notification);
      });
    }, onError: (a) {
      print("##################");
      print("######### Error getNotifications with SnackBar #########");
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

  Future<void> refreshNotifications() async {
    notifications.clear();
    listenForNotifications(
        message: S.of(state.context).notifications_refreshed_successfully);
  }

  void doMarkAsReadNotifications(model.Notification _notification) async {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        --unReadNotificationsCount;
        _notification.read = !_notification.read;
      });
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).thisNotificationHasMarkedAsRead),
      ));
    });
  }

  void doMarkAsUnReadNotifications(model.Notification _notification) {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        ++unReadNotificationsCount;
        _notification.read = !_notification.read;
      });
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).thisNotificationHasMarkedAsUnread),
      ));
    });
  }
}
