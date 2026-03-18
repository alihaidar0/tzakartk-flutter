import '../models/media.dart';

class Option {
  String id;
  String name;
  String ar_name;
  String description;
  double price;
  String product_id;
  String optionGroupId;
  bool has_media;
  Media image;

  bool checked;

  Option();

  Option.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      ar_name = jsonMap['ar_name'].toString();
      description = jsonMap['description'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0;
      product_id = jsonMap['product_id'].toString();
      optionGroupId = jsonMap['option_group_id'] != null
          ? jsonMap['option_group_id'].toString()
          : '0';
      has_media = false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      checked = false;
    } catch (e) {
      id = '';
      name = '';
      ar_name = '';
      description = '';
      price = 0.0;
      product_id = '';
      optionGroupId = '0';
      has_media = false;
      image = new Media();
      checked = false;
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;

  @override
  String toString() => "name= $name, checked= $checked";
}
