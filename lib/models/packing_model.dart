class Packing {
  String unitQty;
  int price;
  String unitQtyShow;

  Packing(json) {
    unitQty = json['unitqty'];
    price = json['price'];
    unitQtyShow = json['unitqtyshow'];
  }
}
