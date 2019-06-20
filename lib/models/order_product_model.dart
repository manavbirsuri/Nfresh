class OrderProduct {
  String sku;
  String tierQty;
  int price;
  int qty;
  int subTotal;
  String name;
  String nameHindi;
  String packing;
  String image;

  OrderProduct(json) {
    sku = json['sku'];
    tierQty = json['tier_qty'];
    price = json['price'];
    qty = json['qty'];
    subTotal = json['subtotal'];
    name = json['name'];
    nameHindi = json['name_hindi'];
    packing = json['packing'];
    image = json['image'];
  }
}
