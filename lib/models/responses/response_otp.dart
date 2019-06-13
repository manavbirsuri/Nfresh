class ResponseOtp {
  String status;
  String msg;
  int activate;
  ResponseOtp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    activate = json['activate'];
  }
}
