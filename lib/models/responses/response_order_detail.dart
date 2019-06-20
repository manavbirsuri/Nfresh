import '../order_detail_model.dart';

class ResponseOrderDetail {
  String status;
  OrderDetail order;

  ResponseOrderDetail.fromJson(Map<String, dynamic> map) {
    status = map['status'];
    order = map["order"][0];
  }
}
