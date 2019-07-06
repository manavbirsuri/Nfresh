class Coupon {
  String name;
  String image;
  String couponCode;
  String endDate;
  int type;
  int discount;
  int minValue = 0;

  Coupon(json) {
    name = json['name'];
    image = json['image'];
    couponCode = json['coupon_code'];
    endDate = json['end_date'];
    type = json['type'];
    discount = json['discount'];
    minValue = json['minimum_cart_value'];
  }
}
