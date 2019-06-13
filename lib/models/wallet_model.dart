class Wallet {
  int moneyAdded;
  int walletCredit;

  Wallet(json) {
    moneyAdded = json['money_added'];
    walletCredit = json['wallet_credit'];
  }
}
