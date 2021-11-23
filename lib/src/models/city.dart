/// I WROTE THIS ""START""
import '../helpers/custom_trace.dart';

class City {
  String id;
  String en_name;
  String ar_name;

  City();

  City.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      en_name = jsonMap['en_name'];
      ar_name = jsonMap['ar_name'];
    } catch (e) {
      id = '';
      en_name = '';
      ar_name = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  @override
  String toString() => "$en_name $ar_name";
}
