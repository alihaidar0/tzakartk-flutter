import '../helpers/custom_trace.dart';

class Address {
  String id;
  String description;
  String address;
  String receiver_name;
  String receiver_phone;
  String cityId;
  bool isDefault;
  String userId;

  bool selected;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description = jsonMap['description'] != null
          ? jsonMap['description'].toString()
          : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : null;
      receiver_name =
          jsonMap['receiver_name'] != null ? jsonMap['receiver_name'] : null;
      receiver_phone =
          jsonMap['receiver_phone'] != null ? jsonMap['receiver_phone'] : null;
      cityId = jsonMap['city_id'].toString();
      isDefault = jsonMap['is_default'] ?? false;
      userId = jsonMap['user_id'].toString();
      selected = false;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  bool isUnknown() {
    return false;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["receiver_name"] = receiver_name;
    map["receiver_phone"] = receiver_phone;
    map["city_id"] = cityId;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    return map;
  }

  @override
  String toString() =>
      'id= $id, description= $description, address= $address, receiver_name= $receiver_name, receiver_phone= $receiver_phone, cityId= $cityId, isDefault= $isDefault, userId= $userId, selected= $selected';
}
