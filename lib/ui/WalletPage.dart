import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/checksum_bloc.dart';
import 'package:nfresh/bloc/wallet_bloc.dart';
import 'package:nfresh/bloc/wallet_update_bloc.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/models/responses/response_wallet.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'login.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: stateProfile(),
    );
  }
}

class stateProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return stateProfilePage();
  }
}

class stateProfilePage extends State<stateProfile> {
  static const platform = const MethodChannel('flutter.native/helper');
  var valueChecked = 0;
  var bloc = WalletBloc();
  var blocCheck = ChecksumBloc();
  var prefs = SharedPrefs();
  var blocWallet = UpdateWalletBloc();
  String checksum = "";
  String orderId = "";
  Map<String, dynamic> mapPayTm = {
    'MID': "apXePW28170154069075",
    'ORDER_ID': "NF${new DateTime.now().millisecondsSinceEpoch}",
    'CUST_ID': "cust123",
    'MOBILE_NO': "7777777777",
    'EMAIL': "username@emailprovider.com",
    'CHANNEL_ID': "WAP",
    'TXN_AMOUNT': "100",
    'WEBSITE': "WEBSTAGING",
    'INDUSTRY_TYPE_ID': "Retail",
    'CALLBACK_URL': ""
  };

  ProfileModel profileModel;
  var totalAmount = 100;
  int credits = 0;

  ProgressDialog dialog;
  @override
  void initState() {
    super.initState();
    bloc.fetchData();
    getProfileDetail();
  }

  getProfileDetail() {
    prefs.getProfile().then((profile) {
      setState(() {
        profileModel = profile;
        credits = profileModel.walletCredits;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: Image.asset(
            'assets/sigbg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        new Scaffold(
          appBar: new AppBar(
//            leading: new IconButton(
//                icon: new Icon(
//                  Icons.arrow_back,
//                  color: Colors.white,
//                ),
//                onPressed: () => Navigator.pop(context)),
            title: new Text(
              "My Wallet",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            stream: bloc.walletOffers,
            builder: (context, AsyncSnapshot<ResponseWallet> snapshot) {
              if (snapshot.hasData) {
                return mainContent(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
        border: Border.all(color: Colors.colorgreen),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.green);
  }

  BoxDecoration myBoxDecoration2() {
    return BoxDecoration(
        border: Border.all(color: Colors.colorgreen),
        borderRadius: BorderRadius.all(Radius.circular(8)));
  }

  Widget mainContent(AsyncSnapshot<ResponseWallet> snapshot) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      credits.toString(),
                      style:
                          TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' CREDITS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 0,
                  ),
                  child: Text(
                    'available balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 170),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(''),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 95, right: 20, left: 20),
          child: Material(
            elevation: 16.0,
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(18), topLeft: Radius.circular(18)),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.only(topRight: Radius.circular(18), topLeft: Radius.circular(18)),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: snapshot.data.walletOffers.length > 0
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        child: Text(
                                          'Select Amount to Add Credits',
                                          style: TextStyle(fontSize: 16, color: Colors.colorgreen),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        child:
//                                  Row(
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
                                            ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.walletOffers.length,
                                          itemBuilder: (context, position) {
                                            return Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    valueChecked = position;
                                                    totalAmount = snapshot
                                                        .data.walletOffers[position].moneyAdded;
                                                  });
                                                },
                                                child: Container(
                                                  child: valueChecked == position
                                                      ? Container(
                                                          height: 30,
                                                          width: 65,
                                                          decoration: myBoxDecoration3(),
                                                          margin: EdgeInsets.only(top: 16),
                                                          child: Text(
                                                            snapshot.data.walletOffers[position]
                                                                .moneyAdded
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 16, color: Colors.white),
                                                          ),
                                                          alignment: Alignment.center,
                                                        )
                                                      : Container(
                                                          height: 30,
                                                          width: 65,
                                                          decoration: myBoxDecoration2(),
                                                          margin: EdgeInsets.only(top: 16),
                                                          child: Text(
                                                            snapshot.data.walletOffers[position]
                                                                .moneyAdded
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.colorgreen),
                                                          ),
                                                          alignment: Alignment.center,
                                                        ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(36),
                                        child: Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(top: 0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Center(
                                                        child: Text(
                                                          'You will get',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 0),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.baseline,
                                                      textBaseline: TextBaseline.alphabetic,
                                                      children: <Widget>[
                                                        Text(
                                                          snapshot.data.walletOffers[valueChecked]
                                                              .walletCredit
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors.colorgreen,
                                                              fontSize: 36,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                          ' CREDITS',
                                                          style: TextStyle(
                                                              color: Colors.colorgreen,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    color: Colors.white,
                                    height: double.infinity,
                                    child: Center(
                                      child: Text(
                                        "No credits Available",
                                        style: TextStyle(fontSize: 18, fontFamily: 'Bold'),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      snapshot.data.walletOffers.length > 0
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
                                child: GestureDetector(
                                  onTap: () {
                                    if (profileModel != null) {
                                      getCheckSum(context);
                                    } else {
                                      showAlertMessage(context);
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    decoration: new BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.all(new Radius.circular(100.0)),
                                        color: Colors.colorgreen),
                                    child: Center(
                                      child: new Text("Pay Now",
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showAlertMessage(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content:
              new Text("You would need to login in order to proceed. Please click here to Login."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Login"),
              onPressed: () {
                Navigator.of(context).pop();
                goToLogin();
              },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void goToLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
                from: 1,
              ),
        )).then((value) {
      getProfileDetail();
    });
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getCheckSum(context) {
//    Future.delayed(const Duration(milliseconds: 3000), () {
    dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    dialog.setMessage("Please wait...");
    dialog.show();
    setState(() {
      orderId = "NFW${new DateTime.now().millisecondsSinceEpoch}";
      mapPayTm['ORDER_ID'] = orderId;
      mapPayTm['CUST_ID'] = profileModel.name;
      mapPayTm['MOBILE_NO'] = profileModel.phoneNo;
      mapPayTm['EMAIL'] = profileModel.email;
      mapPayTm['TXN_AMOUNT'] = totalAmount.toString();
      mapPayTm['CALLBACK_URL'] =
          "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    });
    blocCheck.fetchData(mapPayTm);
//    });
    blocCheck.checksum.listen((res) {
      print("CHECKSUM: $res");
      dialog.hide();
      platform.invokeMethod('$res::${jsonEncode(mapPayTm)}').then((result) {
        handlePayTmResponse(result, context);
      });
    });
  }

  void handlePayTmResponse(String response, BuildContext context) {
    if (response.contains("KITKAT")) {
      print(response);
    } else {
      var obj = jsonDecode(response);
      var status = obj['STATUS'];
      if (status == 'TXN_SUCCESS') {
        // payment success
        dialog = new ProgressDialog(context, ProgressDialogType.Normal);
        dialog.setMessage("Updating wallet...");
        dialog.show();
        blocWallet.fetchData(totalAmount, response);
        blocWallet.profileData.listen((profile) {
          dialog.hide();
          if (profile.status == "true") {
            _showDialog("Amount added to wallet Successfully");
            String data = jsonEncode(profile.profile);
            prefs.saveProfile(data);
            getProfileDetail();
          } else {
            blocWallet.fetchData(totalAmount, response);
          }
        });
      } else {
        // payment failure
        _showDialog("Payment payment processing error.");
      }
    }
  }
}
