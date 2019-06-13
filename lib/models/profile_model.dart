class ProfileModel {
  String name;
  String email;
  String phoneNo;
  String address;
  int city;
  int area;
  int walletCredits;
  int type;
  String password; // this field used only while signing up.

  ProfileModel(json) {
    name = json['name'];
    email = json['email'];
    phoneNo = json['phone_no'];
    address = json['address'];
    city = json['city'];
    area = json['area'];
    walletCredits = json['wallet_credits'];
    type = json['type'];
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
    };
  }
}
