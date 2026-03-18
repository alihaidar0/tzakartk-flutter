import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:tzakartk/src/repository/my_client.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/note.dart';

Future<Stream<Note>> getNote() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}addresses/notes';
  try {
    final client = new MyClient();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) {
      return Note.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: e.toString()).toString());
    return new Stream.value(new Note.fromJSON({}));
  }
}
