import '../product_model.dart';

class ResponseReorder {
  String status;
  String msg;
  List<Product> products = [];

  ResponseReorder.fromJson(Map<String, dynamic> decode) {
    status = decode['status'];
    msg = decode['msg'];
    for (int i = 0; i < decode['products'].length; i++) {
      var product = Product(decode['products'][i], "reorder");
      products.add(product);
    }
  }
}
