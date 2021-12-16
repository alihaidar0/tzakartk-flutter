class Payment {
  String id;
  double price;
  String description;
  String status;
  String method;

  Payment.init();

  Payment(this.method);

  Payment.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0;
      description = jsonMap['description'] ?? '';
      status = jsonMap['status'] ?? '';
      method = jsonMap['method'] ?? '';
    } catch (e) {
      id = '';
      status = '';
      method = '';
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      // 'status': status,
      'method': method,
    };
  }
}
