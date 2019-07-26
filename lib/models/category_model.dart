import 'banner_model.dart';

class Category {
  int id;
  String name;
  String image;
  String icon;
  Category(json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
    image = json['image'];
  }

  Category.init(BannerModel jsonEncode) {
    if (jsonEncode.link.isNotEmpty) {
      id = int.parse(jsonEncode.link);
      image = jsonEncode.image;
      icon = jsonEncode.image;
      name = jsonEncode.name;
    }
  }
}
