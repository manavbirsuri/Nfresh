class ProductInvent {
  int unitQty;
  int product_id;
  int qty;

  ProductInvent(json) {
    product_id = json['product_id'];
    unitQty = json['unitqty'];
    qty = json['qty'];
  }
}
