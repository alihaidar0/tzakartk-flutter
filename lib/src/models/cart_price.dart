class CartPrice {
  double sub_total;
  double delivery_fee;
  double total;

  CartPrice();

  CartPrice.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      sub_total =
          jsonMap['sub_total'] != null ? jsonMap['sub_total'].toDouble() : 0.0;
      delivery_fee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      total = jsonMap['total'] != null ? jsonMap['total'].toDouble() : 0.0;
    } catch (e) {
      sub_total = 0.0;
      delivery_fee = 0.0;
      total = 0.0;
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["sub_total"] = sub_total;
    map["delivery_fee"] = delivery_fee;
    map["total"] = total;
    return map;
  }
}
