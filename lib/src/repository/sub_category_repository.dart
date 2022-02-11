import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../library/globals.dart' as globals;
import '../models/sub_category.dart';

Future<Stream<SubCategory>> getSubCategories(String parentId) async {
  Uri uri = Helper.getUri('api/children');
  String orderBy =
      globals.lang != null && globals.lang == 'ar' ? 'ar_name' : 'en_name';
  Map<String, dynamic> _queryParams = {};
  _queryParams['parent_id'] = '$parentId';
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
        .map((data) => SubCategory.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new SubCategory.fromJSON({}));
  }
}

Future<Stream<SubCategory>> getSubCategoriesByCity(String cityId) async {
  Uri uri = Helper.getUri('api/children');
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
        .map((data) => SubCategory.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new SubCategory.fromJSON({}));
  }
}
