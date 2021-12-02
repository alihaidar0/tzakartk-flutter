import '../helpers/custom_trace.dart';

class Address {
  String id;
  String description;
  String address;
  String receiver_name;
  String receiver_phone;
  double latitude;
  double longitude;
  bool isDefault;
  String userId;

  Address({
    this.description,
    this.address,
    this.receiver_name,
    this.receiver_phone,
  });

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
      latitude = jsonMap['latitude'] != null ? jsonMap['latitude'] : null;
      longitude = jsonMap['longitude'] != null ? jsonMap['longitude'] : null;
      isDefault = jsonMap['is_default'] ?? false;
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
    // map["receiver_name"] = receiver_name;
    // map["receiver_phone"] = receiver_phone;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    return map;
  }

  @override
  String toString() =>
      '$id, $description, $address, $receiver_name, $receiver_phone, $isDefault';
}
