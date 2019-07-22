class Order {
  int orderId;
  double orderTotal;
  String orderStatus;
  String orderCreatedAt;
  Order(json) {
    orderId = json['order_id'];
    orderTotal = json['total'].toDouble();
    orderStatus = json['status'];
    orderCreatedAt = json['created_at'];
  }
}
