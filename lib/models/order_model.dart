class Order {
  int orderId;
  int orderTotal;
  String orderStatus;
  String orderCreatedAt;
  Order(json) {
    orderId = json['order_id'];
    orderTotal = json['total'];
    orderStatus = json['status'];
    orderCreatedAt = json['created_at'];
  }
}
