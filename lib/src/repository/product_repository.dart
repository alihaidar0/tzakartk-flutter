import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../library/globals.dart' as globals;
import '../models/address.dart';
import '../models/product.dart';

Future<Stream<Product>> getProduct(String productId) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}products/$productId';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: e.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> searchProducts(
    String search, Address address, String categoryId) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  _queryParams['category_id'] = '$categoryId:';
  _queryParams['searchFields[0]'] = 'en_name:like';
  _queryParams['searchFields[1]'] = 'ar_name:like';
  _queryParams['search'] = '$search';
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProductsByCategory(categoryId) async {
  Uri uri = Helper.getUri('api/products');
  String orderBy =
      globals.lang != null && globals.lang == 'ar' ? 'ar_name' : 'en_name';
  Map<String, dynamic> _queryParams = {};
  _queryParams['category_id'] = '$categoryId';
  _queryParams['orderBy'] = orderBy;
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}
