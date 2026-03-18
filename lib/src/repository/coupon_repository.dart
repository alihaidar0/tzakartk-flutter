import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/coupon.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Coupon> verifyCoupon(String code) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Coupon.fromJSON({});
  }
  Map<String, dynamic> params = {'code': code};
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/apply_coupon';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: '${_user.apiToken}',
    },
    body: json.encode(params),
  );
  if (response.statusCode == 200) {
    if (json.decode(response.body)['success'] == true) {
      return Coupon.fromJSON(json.decode(response.body)['data']);
    } else {
      return Coupon.fromJSON({'code': code, "enabled": false});
    }
  } else {
    throw new Exception(response.body);
  }
}

Future<Coupon> saveCoupon(Coupon coupon) async {
  if (coupon != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('coupon', json.encode(coupon.toMap()));
  }
  return coupon;
}

Future<Coupon> getCoupon() async {
  Coupon _coupon = Coupon.fromJSON({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('coupon')) {
    _coupon = Coupon.fromJSON(json.decode(await prefs.get('coupon')));
  }
  return _coupon;
}
