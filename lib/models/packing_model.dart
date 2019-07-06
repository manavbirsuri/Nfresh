class Packing {
  double unitQty;
  int price;
  int displayPrice;
  String unitQtyShow;

  Packing(json) {
    unitQty = json['unitqty'].toDouble();
    price = json['price'];
    displayPrice = json['display_price'];
    unitQtyShow = json['unitqtyshow'];
  }

  Map<String, dynamic> toJson() {
    return {
      'unitqty': this.unitQty,
      'price': this.price,
      'display_price': this.displayPrice,
      'unitqtyshow': this.unitQtyShow,
    };
  }
}
