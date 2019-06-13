import '../profile_model.dart';

class ResponseProfile {
  String status;
  String msg;
  ProfileModel profile;

  ResponseProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    profile = ProfileModel(json['profile']);
  }
}
