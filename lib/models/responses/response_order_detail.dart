import '../order_detail_model.dart';

class ResponseOrderDetail {
  String status;
  OrderDetail order;

  ResponseOrderDetail.fromJson(Map<String, dynamic> map) {
    status = map['status'];
    order = OrderDetail(map["order"][0]);
  }
}
