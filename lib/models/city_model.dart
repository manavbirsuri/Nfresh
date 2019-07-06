class CityModel {
  int id;
  String name = "";
  CityModel(json) {
    id = json['id'];
    name = json['name'];
  }
}
