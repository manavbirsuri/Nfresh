import 'order_product_model.dart';

class OrderDetail {
  int orderId;
  int total;
  String status;
  String createdAt;
  int count;
  List<OrderProduct> products = [];

  OrderDetail(json) {
    orderId = json['order_id'];
    total = json['total'];
    status = json['status'];
    createdAt = json['created_at'];
    count = json['count'];
    for (int i = 0; i < json['products'].length; i++) {
      var product = OrderProduct(json['products'][i]);
      products.add(product);
    }
  }
}
