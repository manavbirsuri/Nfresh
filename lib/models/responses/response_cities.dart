import '../area_model.dart';
import '../city_model.dart';

class ResponseCities {
  String status;
  String msg;
  List<CityModel> cities = [];
  List<AreaModel> areas = [];

  ResponseCities.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];

    List<CityModel> tempCity = [];
    for (int i = 0; i < json['cities'].length; i++) {
      var city = CityModel(json['cities'][i]);
      tempCity.add(city);
    }
    cities = tempCity;

    List<AreaModel> tempArea = [];
    for (int i = 0; i < json['areas'].length; i++) {
      var area = AreaModel(json['areas'][i]);
      tempArea.add(area);
    }
    areas = tempArea;
  }
}
