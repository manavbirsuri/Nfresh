import '../coupon_model.dart';

class ResponseCoupons {
  String status;
  String msg;
  List<Coupon> coupons = [];

  ResponseCoupons.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];

    List<Coupon> tempProduct = [];
    for (int i = 0; i < json['coupons'].length; i++) {
      var product = Coupon(json['coupons'][i]);
      tempProduct.add(product);
    }
    coupons = tempProduct;
  }
}
