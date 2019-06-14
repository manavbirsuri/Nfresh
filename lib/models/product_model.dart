import 'dart:convert';

import 'package:nfresh/models/packing_model.dart';

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
  String fav;
  List<Packing> packing = [];

  // Extra local fields
  int count = 0;
  String off = "20% off";
  Packing selectedPacking;

  Product(json) {
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
    selectedPacking = packing[0];
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
      'packing': jsonEncode(packing),
      'selected_packing': selectedPacking.toJson(),
      'count': this.count
    };
  }
}
