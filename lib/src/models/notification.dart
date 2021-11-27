class Notification {
  String id;
  String type;
  String body;
  String title;
  bool read;
  DateTime createdAt;

  Notification();

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      type = jsonMap['type'];
      body = jsonMap['body'];
      title = jsonMap['title'];
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = jsonMap['created_at'] != null?DateTime.parse(jsonMap['created_at']):new DateTime(0);
    } catch (e) {
      id = '';
      type = '';
      body = '';
      title = '';
      read = false;
      createdAt = new DateTime(0);
      print(e);
    }
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }

  @override
  String toString() => 'body =$body, title=$title, type=$type';
}
