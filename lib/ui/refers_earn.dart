import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/profile_bloc.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import '../utils.dart';

class ReferEarnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: referEarnProfile(),
    );
  }
}

class referEarnProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return stateProfilePage();
  }
}

class stateProfilePage extends State<referEarnProfile> {
  static const platform = const MethodChannel('flutter.native/helper');
  var valueChecked = 0;
  var bloc = ProfileBloc();

  var prefs = SharedPrefs();

  ProfileModel profileModel;
  var totalAmount = 100;
  int credits = 0;
  String code = '';

  ProgressDialog dialog;
  @override
  void initState() {
    super.initState();
    Utils.checkInternet().then((connected) {
      if (connected != null && connected) {
        bloc.fetchData();
      } else {
        setState(() {
          // showLoader = false;
        });
        Toast.show("Not connected to internet", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });

    getProfileDetail();
  }

  getProfileDetail() {
    prefs.getProfile().then((profile) {
      setState(() {
        profileModel = profile;
        code = profileModel.referralCode;
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
              "Refer & Earn",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: mainContent(),
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

  Widget mainContent() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              1 < 0
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Image.asset(
                            "assets/refer.png",
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              1 < 0
                  ? Center(
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
                  : Container(),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(''),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15, right: 20, left: 20),
          child: Material(
            elevation: 16.0,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(18), topLeft: Radius.circular(18)),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18), topLeft: Radius.circular(18)),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SingleChildScrollView(
                              child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Center(
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  crossAxisAlignment:
//                                      CrossAxisAlignment.baseline,
//                                  textBaseline: TextBaseline.alphabetic,
//                                  children: <Widget>[
                                child: Image.asset(
                                  "assets/refer.png",
                                  height: 120,
                                  width: 120,
                                ),
//                                  ],
//                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                child: Text(
                                  'You can refer your friends and earn bonus credits when they join using your referral code.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.colorgreen,
                                  ),
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
                                padding: EdgeInsets.all(30),
                                child: Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Center(
                                                child: GestureDetector(
                                                  onLongPress: () {
                                                    // code to copy refer code
                                                    Clipboard.setData(
                                                        new ClipboardData(
                                                            text: code));
                                                    Scaffold.of(context)
                                                        .showSnackBar(
                                                            new SnackBar(
                                                      content: new Text(
                                                          "Copied to Clipboard"),
                                                    ));
                                                  },
                                                  child: DottedBorder(
                                                    color: Colors.black,
                                                    gap: 3,
                                                    strokeWidth: 1,
                                                    child: Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      children: <Widget>[
                                                        Center(
                                                          child: Text(
                                                            code,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .colorgreen,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 35),
                                                          ),
                                                        ),
                                                        Container(
                                                          //color: Colors.green,
                                                          width: 30,
                                                          child: Center(
                                                            child: Icon(Icons
                                                                .content_copy),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        /* GestureDetector(
                                          onTap: () {
                                            Share.plainText(
                                                    text:
                                                        "You can refer your friends and earn bonus credits when they join using your referral code $code. Visit our website at http://nfreshonline.com/",
                                                    title: "Share")
                                                .share();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 52),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/fb.png",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                                Image.asset(
                                                  "assets/wa.png",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                                Image.asset(
                                                  "assets/message.png",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                                Image.asset(
                                                  "assets/mail.png",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )*/
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                          child: GestureDetector(
                            onTap: () {
                              Share.plainText(
                                      text:
                                          "You can refer your friends and earn bonus credits when they join using your referral code <$code>. Visit our website at http://nfreshonline.com/",
                                      title: "Share")
                                  .share();
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              margin: EdgeInsets.only(bottom: 40),
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(100.0)),
                                  color: Colors.colorgreen),
                              child: Center(
                                child: new Text("Share Now",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      )
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
}
