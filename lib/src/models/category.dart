import '../helpers/custom_trace.dart';
import '../models/media.dart';

class Category {
  String id;
  String parent_id;
  String city_id;
  String en_name;
  String ar_name;
  String en_description;
  String ar_description;
  bool has_media;
  List<Media> images;
  Media image;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      parent_id = jsonMap['parent_id'].toString();
      city_id = jsonMap['city_id'].toString();
      en_name = jsonMap['en_name'];
      ar_name = jsonMap['ar_name'];
      en_description = jsonMap['en_description'];
      ar_description = jsonMap['ar_description'];
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
      parent_id = '';
      city_id = '';
      en_name = '';
      ar_name = '';
      en_description = '';
      ar_description = '';
      has_media = false;
      images = [];
      image = new Media();
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  @override
  String toString() => "id= $id, en_name= $en_name, ar_name= $ar_name";
}
