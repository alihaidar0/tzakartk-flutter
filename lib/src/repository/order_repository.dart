import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/my_client.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Order>> getOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders?with=user;productOrders;productOrders.product;productOrders.options;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';
  try {
    final client = new MyClient();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Order.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Order.fromJSON({}));
  }
}

Future<Stream<Order>> getOrder(orderId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders/$orderId?with=user;productOrders;productOrders.product;productOrders.options;orderStatus;deliveryAddress;payment';
  final client = new MyClient();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders?with=user;productOrders;productOrders.product;productOrders.options;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new MyClient();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}order_statuses';

  final client = new MyClient();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<bool> addOrder(Order order, Payment payment) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
  order.payment = payment;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}orders';
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  print("######### addOrder #########");
  print("${json.encode(params)}");
  print("##################");
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
      return true;
    } else {
      return false;
    }
  } else {
    print("######### Exception in addOrder #########");
    print("##################");
    print("##################");
    throw new Exception(response.body);
  }
}
