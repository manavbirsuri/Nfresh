import 'package:nfresh/models/product_invent_model.dart';

class ModelInventory {
  String status;
  List<ProductInvent> products = [];
  ModelInventory.fromJson(Map<String, dynamic> decode) {
    status = decode['status'];

    for (int i = 0; i < decode['line_items'].length; i++) {
      var product = ProductInvent(decode['line_items'][i]);
      products.add(product);
    }
  }
}
