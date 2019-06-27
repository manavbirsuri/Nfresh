import 'package:nfresh/models/section_model.dart';

import '../banner_model.dart';
import '../category_model.dart';

class ResponseHome {
  String status;
  String authCode;
  String msg;
  List<BannerModel> banners = [];
  List<BannerModel> offerBanners = [];
  List<Category> categories = [];
  List<Section> sections = [];

  ResponseHome.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    authCode = json['auth_code'];
    msg = json['msg'];

    List<BannerModel> temp = [];
    if (json['banners'] != null) {
      for (int i = 0; i < json['banners'].length; i++) {
        var banner = BannerModel(json['banners'][i]);
        temp.add(banner);
      }
      banners = temp;
    }
    List<BannerModel> temp2 = [];
    if (json['offerbanners'] != null) {
      for (int i = 0; i < json['offerbanners'].length; i++) {
        var banner = BannerModel(json['offerbanners'][i]);
        temp2.add(banner);
      }
      offerBanners = temp2;
    }
    List<Category> cat = [];
    if (json['categories'] != null) {
      for (int i = 0; i < json['categories'].length; i++) {
        var category = Category(json['categories'][i]);
        cat.add(category);
      }
      categories = cat;
    }
    List<Section> tempSection = [];
    if (json['sections'] != null) {
      for (int i = 0; i < json['sections'].length; i++) {
        var section = Section.fromJson(json['sections'][i]);
        tempSection.add(section);
      }
      sections = tempSection;
    }
  }
}
