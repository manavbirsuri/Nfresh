class BannerModel {
  String name;
  String image;
  String link;
  BannerModel(json) {
    name = json['name'];
    image = json['image'];
    link = json['link'];
  }
}
