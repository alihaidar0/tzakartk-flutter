import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/cart_price.dart';
import '../models/user.dart';
import '../repository/my_client.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Cart>> getCart() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String url = '${GlobalConfiguration().getValue('api_base_url')}carts';
  final client = new MyClient();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Cart.fromJSON(data);
  });
}

Future<Stream<int>> getCartCount() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(0);
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/count';
  try {
    final client = new MyClient();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map(
          (data) => Helper.getIntData(data),
        );
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(0);
  }
}

Future<Stream<CartPrice>> getCartPrice(String code) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/totals?code=$code';
  final client = new MyClient();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return CartPrice.fromJSON(data);
  });
}

Future<Cart> addCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  Map<String, dynamic> decodedJSON = {};
  cart.user_id = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}carts';
  final client = new MyClient();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }
  return Cart.fromJSON(decodedJSON);
}

Future<bool> updateCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  cart.user_id = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/${cart.id}';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: '${_user.apiToken}'
    },
    body: json.encode(cart.toMap()),
  );
  if(json.decode(response.body)['success'] == true)
    return true;
  else{
    return false;
  }
}

Future<bool> removeCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/${cart.id}';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: '${_user.apiToken}'
    },
  );
  return Helper.getBoolData(json.decode(response.body));
}
