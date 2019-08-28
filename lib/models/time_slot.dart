class TimeSlot {
  int id;
  String name;
  String time_to;
  String time_from;
  String created_at;

  TimeSlot(json) {
    id = json['id'];
    name = json['name'];
    time_to = json['time_to'];
    time_from = json['time_from'];
    //created_at = json['created_at'];
  }
}
