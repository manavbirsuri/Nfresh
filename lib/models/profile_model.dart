class ProfileModel {
  String name = "";
  String email = "";
  String phoneNo = "";
  String address = "Not Selected";
  String referralCode = "";
  int city = 0;
  int area = 0;
  double walletCredits = 0;
  int type = 0;
  String password; // this field used only while signing up.

  ProfileModel(json) {
    if (json != null) {
      name = json['name'];
      email = json['email'];
      phoneNo = json['phone_no'];
      address = json['address'];
      city = json['city'];
      area = json['area'];
      walletCredits = json['wallet_credits'].toDouble();
      referralCode = json['referral_code'];
      type = json['type'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'email': this.email,
      'phone_no': this.phoneNo,
      'address': this.address,
      'city': this.city,
      'area': this.area,
      'wallet_credits': this.walletCredits,
      'type': this.type,
      'referral_code': this.referralCode,
    };
  }
}
