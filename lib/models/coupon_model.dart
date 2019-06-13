class Coupon {
  String name;
  String image;
  String couponCode;
  String endDate;
  int type;
  int discount;

  Coupon(json) {
    name = json['name'];
    image = json[''];
    couponCode = json['coupon_code'];
    endDate = json['end_date'];
    type = json['type'];
    discount = json['discount'];
  }
}
