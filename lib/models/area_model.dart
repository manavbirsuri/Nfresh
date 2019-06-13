class AreaModel {
  String name;
  int cityId;
  AreaModel(json) {
    name = json['name'];
    cityId = json['city_id'];
  }
}
