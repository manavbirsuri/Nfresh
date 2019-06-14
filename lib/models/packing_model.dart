class Packing {
  String unitQty;
  int price;
  String unitQtyShow;

  Packing(json) {
    unitQty = json['unitqty'];
    price = json['price'];
    unitQtyShow = json['unitqtyshow'];
  }

  Map<String, dynamic> toJson() {
    return {
      'unitqty': this.unitQty,
      'price': this.price,
      'unitqtyshow': this.unitQtyShow,
    };
  }
}
