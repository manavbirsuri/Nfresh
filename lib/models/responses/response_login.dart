class ResponseLogin {
  String status;
  String msg;
  ResponseLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }
}
