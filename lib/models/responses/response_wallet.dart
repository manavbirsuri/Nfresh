import '../wallet_model.dart';

class ResponseWallet {
  String status;
  String msg;
  List<Wallet> walletOffers = [];

  ResponseWallet.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];

    List<Wallet> tempWallet = [];
    for (int i = 0; i < json['walletoffers'].length; i++) {
      var wallet = Wallet(json['walletoffers'][i]);
      tempWallet.add(wallet);
    }
    walletOffers = tempWallet;
  }
}
