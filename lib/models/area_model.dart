class AreaModel {
  int id;
  String name;
  int cityId;
  AreaModel(json) {
    id = json['id'];
    name = json['name'];
    cityId = json['city_id'];
  }
}
