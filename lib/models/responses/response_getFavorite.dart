import 'package:nfresh/models/product_model.dart';

class ResponseGetFav {
  String status;
  String msg;
  List<Product> products = [];

  ResponseGetFav.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];

    if (status == "true") {
      List<Product> tempProduct = [];
      for (int i = 0; i < json['products'].length; i++) {
        var product = Product(json['products'][i], "order");
        tempProduct.add(product);
      }
      products = tempProduct;
    }
  }
}
