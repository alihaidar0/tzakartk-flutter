import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<bool> changeLocationRepo(String cityId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return true;
  }
  var map = new Map<String, dynamic>();
  map["city_id"] = cityId;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/change-location';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: '${_user.apiToken}',
    },
    body: json.encode(map),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw new Exception(response.body);
  }
}
