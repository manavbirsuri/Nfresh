import 'dart:convert';

import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/resources/database.dart';

class Product {
  int id;
  String name;
  String nameHindi;
  String sku;
  String description;
  int unitId;
  String image;
  int displayPrice;
  int inventory;
  String fav = '0';
  List<Packing> packing = [];
  var _database = DatabaseHelper.instance;
  // Extra local fields
  int count = 0;
  String off = "20% off";
  Packing selectedPacking;
  double selectedDisplayPrice = 0;

  Product(json, type) {
    id = json['id'];
    name = json['name'];
    nameHindi = json['name_hindi'];
    sku = json['sku'];
    description = json['description'];
    unitId = json['unit_id'];
    image = json['image'];
    displayPrice = json['display_price_1'];
    inventory = json['inventory'];
    fav = json['fav'];
    List<Packing> temp = [];
    for (int i = 0; i < json['packings'].length; i++) {
      Packing result = Packing(json['packings'][i]);
      temp.add(result);
    }
    packing = temp;
    if (type == "reorder") {
      selectedPacking = Packing(json['selectedPacking']);
      count = json['qty'];
    } else {
      selectedPacking = packing[0];
      //count = json['qty'];
      List<Product> productsnew = List();
      _database.queryAllProducts().then((products) {
        for (int i = 0; i < products.length; i++) {
          if (id == products[i].id) {
            count = products[i].count;
          }
        }
      });
    }
    selectedDisplayPrice = displayPrice.toDouble();
  }
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'name_hindi': this.nameHindi,
      'sku': this.sku,
      'description': this.description,
      'unit_id': this.unitId,
      'image': this.image,
      'display_price_1': this.displayPrice,
      'inventory': this.inventory,
      'fav': this.fav,
      'packings': jsonEncode(packing),
      'selected_packing':
          jsonEncode(selectedPacking), //selectedPacking.toJson(),
      'count': this.count
    };
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameHindi = json['name_hindi'];
    sku = json['sku'];
    description = json['description'];
    unitId = json['unit_id'];
    image = json['image'];
    displayPrice = json['display_price_1'];
    inventory = json['inventory'];
    fav = json['fav'];
    List<Packing> temp = [];
    var newJson = jsonDecode(json['packings']);
    print("NEW JSON: $newJson");
    for (int i = 0; i < newJson.length; i++) {
      Packing result = Packing(newJson[i]);
      temp.add(result);
    }
    packing = temp;
    selectedPacking = Packing(jsonDecode(json['selected_packing']));
    count = json['count'];
  }
}
