class OptionGroup {
  String id;
  String en_name;
  String ar_name;

  OptionGroup();

  OptionGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      en_name = jsonMap['en_name'];
      ar_name = jsonMap['ar_name'];
    } catch (e) {
      id = '';
      en_name = '';
      ar_name = '';
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["en_name"] = en_name;
    map["ar_name"] = ar_name;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
