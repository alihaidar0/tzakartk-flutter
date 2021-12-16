import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';

class Order {
  String id;
  String userId;
  String orderStatusId;
  double tax;
  double deliveryFee;
  String hint;
  String deliveryAddressId;
  String paymentId;
  String couponId;
  DateTime dateTime;
  DateTime deliveryDate;
  double couponDiscount;
  OrderStatus orderStatus;
  Payment payment;
  Address deliveryAddress;
  List<ProductOrder> productOrders;

  String coupon;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      userId = jsonMap['userId'].toString();
      orderStatusId = jsonMap['orderStatusId'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';
      deliveryAddressId = jsonMap['delivery_address_id'].toString();
      paymentId = jsonMap['payment_id'].toString();
      couponId = jsonMap['coupon_id'].toString();
      dateTime = DateTime.parse(jsonMap['updated_at']);
      deliveryDate = DateTime.parse(jsonMap['delivery_date']);
      couponDiscount = jsonMap['coupon_discount'] != null
          ? jsonMap['coupon_discount'].toDouble()
          : 0.0;
      orderStatus = jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : OrderStatus.fromJSON({});
      payment = jsonMap['payment'] != null
          ? Payment.fromJSON(jsonMap['payment'])
          : Payment.fromJSON({});
      deliveryAddress = jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : Address.fromJSON({});
      productOrders = jsonMap['product_orders'] != null
          ? List.from(jsonMap['product_orders'])
              .map((element) => ProductOrder.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      id = '';
      userId = '';
      orderStatusId = '';
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      deliveryAddressId = '';
      paymentId = '';
      couponId = '';
      dateTime = DateTime(0);
      deliveryDate = DateTime(0);
      couponDiscount = 0.0;
      orderStatus = OrderStatus.fromJSON({});
      payment = Payment.fromJSON({});
      deliveryAddress = Address.fromJSON({});
      productOrders = [];
      print(jsonMap);
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"] = userId;
    map["order_status_id"] = orderStatus?.id;
    map['hint'] = hint;
    map["payment"] = payment?.toMap();
    if (!deliveryAddress.isUnknown()) {
      map["delivery_address_id"] = deliveryAddress?.id;
    }
    map['delivery_date'] = deliveryDate == null
        ? null
        : "${deliveryDate.year.toString()}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}";
    map['coupon'] = coupon;
    return map;
  }
}
