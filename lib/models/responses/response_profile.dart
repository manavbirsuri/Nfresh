import '../profile_model.dart';
import '../time_slot.dart';

class ResponseProfile {
  String status;
  String msg;
  ProfileModel profile;
  List<TimeSlot> timeslot = [];
  ResponseProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    profile = ProfileModel(json['profile']);
    for (int i = 0; i < json['timeslote'].length; i++) {
      var product = TimeSlot(json['timeslote'][i]);
      timeslot.add(product);
    }
  }
}
