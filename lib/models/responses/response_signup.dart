class ResponseSignUp {
  String status;
  String msg;
  int userId;
  ResponseSignUp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    userId = json['user_id'];
  }
}
