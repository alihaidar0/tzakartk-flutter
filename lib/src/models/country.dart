import '../helpers/custom_trace.dart';
import '../models/media.dart';

class Country {
  String id;
  String en_name;
  String ar_name;
  String code;
  bool has_media;
  List<Media> images;
  Media image;

  Country();

  Country.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      en_name = jsonMap['en_name'];
      ar_name = jsonMap['ar_name'];
      code = jsonMap['code'];
      has_media = jsonMap['has_media'];
      images = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? List.from(jsonMap['media'])
              .map((element) => Media.fromJSON(element))
              .toSet()
              .toList()
          : [];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e) {
      id = '';
      en_name = '';
      ar_name = '';
      code = '';
      has_media = false;
      images = [];
      image = new Media();
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

// @override
// String toString() => "$en_name ($ar_name)";
}
