import '../category_model.dart';

class ResponseSubCat {
  String status;
  String msg;
  List<Category> categories = [];

  ResponseSubCat.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    List<Category> tempCat = [];
    for (int i = 0; i < json['categories'].length; i++) {
      var subCat = Category(json['categories'][i]);
      tempCat.add(subCat);
    }
    categories = tempCat;
  }
}
