import '../order_model.dart';

class ResponseOrderHistory {
  String status;
  List<Order> orders = [];

  ResponseOrderHistory.fromJson(decode) {
    status = decode['status'];
    if (decode['orders'] != null) {
      for (int i = 0; i < decode['orders'].length; i++) {
        orders.add(Order(decode['orders'][i]));
      }
    }
  }
}
