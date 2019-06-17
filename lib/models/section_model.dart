import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/resources/database.dart';

class Section {
  var _database = DatabaseHelper.instance;
  String title;
  List<Product> products = [];

  Section(json) {
    title = json['title'];

    List<Product> objList = [];
    for (int i = 0; i < json['products'].length; i++) {
      var product = Product(json['products'][i]);
//      _database.queryConditionalProduct(product).then((value) {
//        product = value;
//        objList.add(product);
//      });
      objList.add(product);
    }
    products = objList;
  }

  Section.fromJson(json) {
    title = json['title'];

    // List<Product> objList = [];
    for (int i = 0; i < json['products'].length; i++) {
      var product = Product(json['products'][i]);
      _database.queryConditionalProduct(product).then((value) {
        if (product.id == value.id) {
          product.count = value.count;
          product.selectedPacking = value.selectedPacking;
        }
        products.add(product);
      });
      //objList.add(product);
    }
    //   products = objList;
  }
}
