import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../library/globals.dart' as globals;
import '../models/category.dart';

Future<Stream<Category>> getCategories(String cityId) async {
  Uri uri = Helper.getUri('api/parents');
  String orderBy =
      globals.lang != null && globals.lang == 'ar' ? 'ar_name' : 'en_name';
  Map<String, dynamic> _queryParams = {};
  _queryParams['city_id'] = '$cityId';
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
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Category.fromJSON({}));
  }
}

Future<Stream<Category>> getCategory(String id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}categories/$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Category.fromJSON({}));
  }
}
