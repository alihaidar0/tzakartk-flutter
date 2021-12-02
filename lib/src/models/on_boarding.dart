import '../models/media.dart';

class OnBoarding {
  String id;
  String ar_text;
  String en_text;
  bool has_media;
  Media image;

  OnBoarding();

  OnBoarding.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      ar_text = jsonMap['ar_text'];
      en_text = jsonMap['en_text'];
      has_media = jsonMap['has_media'] ?? false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e) {
      id = '';
      ar_text = '';
      en_text = '';
      has_media = false;
      image = new Media();
      print(e);
    }
  }

  @override
  String toString() => 'id= $id, ar_text= $ar_text, en_text=$en_text';
}
