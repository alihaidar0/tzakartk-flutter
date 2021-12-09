import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/faq_category.dart';
import '../repository/my_client.dart';

Future<Stream<FaqCategory>> getFaqCategories() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}faq_categories';

  final client = new MyClient();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return FaqCategory.fromJSON(data);
  });
}
