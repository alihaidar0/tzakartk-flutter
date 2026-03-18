import '../helpers/custom_trace.dart';

class OrderStatus {
  String id;
  String status;
  String ar_status;
  double flag;

  OrderStatus();

  OrderStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'] != null ? jsonMap['status'] : '';
      ar_status = jsonMap['ar_status'] != null ? jsonMap['ar_status'] : '';
      flag = jsonMap['flag'] != null ? jsonMap['flag'].toDouble() : 0.0;
    } catch (e) {
      id = '';
      status = '';
      ar_status = '';
      flag = 0.0;
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  @override
  String toString() =>
      'id= $id, status= $status, ar_status= $ar_status, flag= $flag';
}
