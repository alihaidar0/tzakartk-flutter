import '../helpers/custom_trace.dart';

class Shop {
  String id;
  String parentId;
  String cityId;
  String en_name;
  String ar_name;
  String en_description;
  String ar_description;

  Shop();

  Shop.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      parentId = jsonMap['parent_id'].toString();
      cityId = jsonMap['city_id'].toString();
      en_name = jsonMap['en_name'];
      ar_name = jsonMap['ar_name'];
      en_description = jsonMap['en_description'];
      ar_description = jsonMap['ar_description'];
    } catch (e) {
      id = '';
      parentId = '';
      cityId = '';
      en_name = '';
      ar_name = '';
      en_description = '';
      ar_description = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  @override
  String toString() => "$en_name $ar_name";
}
