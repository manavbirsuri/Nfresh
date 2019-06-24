import '../product_model.dart';

class ResponseSearch {
  String status;
  String msg;
  List<Product> products = [];

  ResponseSearch.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];

    List<Product> tempProduct = [];
    for (int i = 0; i < json['products'].length; i++) {
      var wallet = Product(json['products'][i], "order");
      tempProduct.add(wallet);
    }
    products = tempProduct;
  }
}
