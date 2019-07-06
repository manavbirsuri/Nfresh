import '../profile_model.dart';

class ResponseLogin {
  String status;
  String msg;
  ProfileModel profile;

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['profile'] != null) {
      profile = ProfileModel(json['profile']);
    }
  }
}
