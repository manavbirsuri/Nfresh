import '../product_model.dart';

class ResponseRelatedProducts {
  String status;
  String msg;
  List<Product> products = [];

  ResponseRelatedProducts.fromJson(Map<String, dynamic> decode) {
    status = decode['status'];
    msg = decode['msg'];
    for (int i = 0; i < decode['products'].length; i++) {
      var product = Product(decode['products'][i]);
      products.add(product);
    }
  }
}
