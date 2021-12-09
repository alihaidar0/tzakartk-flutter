import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../repository/my_client.dart';
import '../repository/user_repository.dart' as userRepo;
import 'settings_repository.dart';

Future<Stream<Notification>> getNotifications() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}notifications';
  final client = new MyClient();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Notification.fromJSON(data);
  });
}

Future<Notification> markAsReadNotifications(Notification notification) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Notification();
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}notifications/${notification.id}';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: '${_user.apiToken}',
    },
    body: json.encode(notification.markReadMap()),
  );
  return Notification.fromJSON(json.decode(response.body)['data']);
}

Future<void> sendNotification(String body, String title, User user) async {
  final data = {
    "notification": {"body": "$body", "title": "$title"},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "messages",
      "status": "done"
    },
    "to": "${user.deviceToken}"
  };
  final String url = 'https://fcm.googleapis.com/fcm/send';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "key=${setting.value.fcmKey}",
    },
    body: json.encode(data),
  );
  if (response.statusCode != 200) {
    print('notification sending failed');
  }
}
