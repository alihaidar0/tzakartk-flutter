import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/shop.dart';
import 'my_client.dart';

Future<Stream<Shop>> getShops() async {
  Uri uri = Helper.getUri('api/carts/shops');
  Map<String, dynamic> _queryParams = {};

  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new MyClient();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Shop.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Shop.fromJSON({}));
  }
}
