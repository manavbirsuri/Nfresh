class Banner {
  String name;
  String image;
  String link;
  Banner(json) {
    name = json['name'];
    image = json['image'];
    link = json['link'];
  }
}
