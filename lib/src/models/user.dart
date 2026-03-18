import '../helpers/custom_trace.dart';
import '../models/media.dart';

enum UserState { available, away, busy }

class User {
  String id;
  String name;
  String email;
  String apiToken;
  String deviceToken;
  String loyalty_points;
  String phone_number;
  bool has_media;
  Media image;

  /// local used
  String password;
  String address;
  String bio;
  String verificationId;
  bool auth;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      loyalty_points = jsonMap['loyalty_points'].toString();
      phone_number = jsonMap['phone_number'];
      has_media = jsonMap['has_media'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      address = jsonMap['address'];
      bio = jsonMap['bio'];
    } catch (e) {
      id = '';
      name = '';
      email = '';
      apiToken = '';
      deviceToken = '';
      phone_number = '';
      has_media = false;
      image = new Media();

      /// local used
      address = '';
      bio = "";
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["email"] = email;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone_number"] = phone_number;

    /// local used
    map["password"] = password;
    map["address"] = address;
    map["bio"] = bio;
    map["media"] = image?.toMap();
    return map;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = image?.thumb;
    map["device_token"] = deviceToken;
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }
}
