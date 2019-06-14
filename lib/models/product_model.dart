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
  int count = 0;
  String quantity;
  String fav;
  List<Packing> packing = [];

  String off = "(20% off)";

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
}
