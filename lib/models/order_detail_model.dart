import 'order_product_model.dart';

class OrderDetail {
  int orderId;
  double total;
  String status;
  String createdAt;
  int payment_method;
  int count;
  List<OrderProduct> products = [];

  OrderDetail(json) {
    orderId = json['order_id'];
    total = (json['total']).toDouble();
    status = json['status'];
    createdAt = json['created_at'];
    payment_method = json['payment_method'];
    count = json['count'];
    for (int i = 0; i < json['products'].length; i++) {
      var product = OrderProduct(json['products'][i]);
      products.add(product);
    }
  }
}
