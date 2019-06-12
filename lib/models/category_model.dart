class Category {
  int id;
  String name;
  String image;
  String icon;
  Category(json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    icon = json['icon'];
  }
}
