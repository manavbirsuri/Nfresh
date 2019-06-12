import 'package:nfresh/models/product_model.dart';

class Section {
  String title;
  List<Product> products = [];

  Section(json) {
    title = json['title'];

    List<Product> objList = [];
    for (int i = 0; i < json['products'].length; i++) {
      var product = Product(json['products'][i]);
      objList.add(product);
    }
    products = objList;
  }
}
