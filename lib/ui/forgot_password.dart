import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/forgot_password_bloc.dart';
import 'package:nfresh/bloc/resend_otp_bloc.dart';
import 'package:nfresh/bloc/update_phone_bloc.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/pin_view_update.dart';
import 'package:toast/toast.dart';

import '../utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordState();
  }
}

class ForgotPasswordState extends State<ForgotPasswordPage> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController password2Controller = new TextEditingController();
  var showText = true;
  var isVisible = true;
  var valueShow = "Show";
  var showText2 = true;
  var valueShow2 = "Show";
  var bloc = UpdatePhoneBloc();
  var blocOtp = ResendOtpBloc();
  bool showLoader = false;
  var _prefs = SharedPrefs();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(fit: StackFit.expand, children: <Widget>[
      Positioned(
        child: Image.asset(
          'assets/sigbg.jpg',
          fit: BoxFit.cover,
        ),
      ),
      new Scaffold(
        appBar: new AppBar(
          leading: BackButton(color: Colors.white),
//            leading: new IconButton(
//                icon: new Icon(
//                  Icons.arrow_back,
//                  color: Colors.green,
//                ),
//                onPressed: () => Navigator.pop(context)),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: <Widget>[
//              SizedBox.expand(
////                child: Image.asset(
////                  'assets/sigbg.jpg',
////                  fit: BoxFit.fill,
////                ),
//              ),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(16),
                    child: Center(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Stack(children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 26),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/logo.png'),
                                    ),
                                  ),
                                  height: 80,
                                ),
                              ]),
                              Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: <Widget>[
                                      isVisible
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 32, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Mobile Number",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Colors.colorgreen),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      isVisible
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Center(
                                                child: TextField(
                                                  controller: phoneController,
                                                  decoration: new InputDecoration
                                                          .collapsed(
                                                      hintText:
                                                          'Enter Mobile No.'),
                                                  textAlign: TextAlign.start,
                                                  inputFormatters: [
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        10),
                                                    BlacklistingTextInputFormatter(
                                                        new RegExp(
                                                            '[\\.|\\,]')),
                                                  ],
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: false),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      isVisible
                                          ? Divider(
                                              height: 1, color: Colors.black)
                                          : Container(),
                                      !isVisible
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 32, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Password",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Colors.colorgreen),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      !isVisible
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Row(children: <Widget>[
                                                Flexible(
                                                  child: Container(
                                                    child: Center(
                                                      child: TextField(
                                                        decoration:
                                                            new InputDecoration
                                                                    .collapsed(
                                                                hintText:
                                                                    'Enter New Password'),
                                                        controller:
                                                            passwordController,
                                                        obscureText: showText,
                                                        textAlign:
                                                            TextAlign.start,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                      ),
                                                    ),
                                                  ),
                                                  flex: 9,
                                                ),
                                                Flexible(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (passwordController
                                                                .text
                                                                .toString()
                                                                .length >
                                                            0) {
                                                          if (showText) {
                                                            showText = false;
                                                            valueShow = "Hide";
                                                          } else {
                                                            showText = true;
                                                            valueShow = "Show";
                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 0,
                                                                left: 0),
                                                        child:
                                                            valueShow == "Hide"
                                                                ? Icon(
                                                                    Icons
                                                                        .visibility,
                                                                    size: 20,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .visibility_off,
                                                                    size: 20,
                                                                  ),
                                                      ),
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                              ]))
                                          : Container(),
                                      !isVisible
                                          ? Divider(
                                              height: 1, color: Colors.black)
                                          : Container(),
                                      !isVisible
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 32, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Confirm Password",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Colors.colorgreen),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      !isVisible
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Row(children: <Widget>[
                                                Flexible(
                                                  child: Container(
                                                    child: Center(
                                                      child: TextField(
                                                        decoration:
                                                            new InputDecoration
                                                                    .collapsed(
                                                                hintText:
                                                                    'Confirm New Password'),
                                                        controller:
                                                            password2Controller,
                                                        obscureText: showText2,
                                                        textAlign:
                                                            TextAlign.start,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                      ),
                                                    ),
                                                  ),
                                                  flex: 9,
                                                ),
                                                Flexible(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (password2Controller
                                                                .text
                                                                .toString()
                                                                .length >
                                                            0) {
                                                          if (showText2) {
                                                            showText2 = false;
                                                            valueShow2 = "Hide";
                                                          } else {
                                                            showText2 = true;
                                                            valueShow2 = "Show";
                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 0,
                                                                left: 0),
                                                        child:
                                                            valueShow2 == "Hide"
                                                                ? Icon(
                                                                    Icons
                                                                        .visibility,
                                                                    size: 20,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .visibility_off,
                                                                    size: 20,
                                                                  ),
                                                      ),
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                              ]))
                                          : Container(),
                                      !isVisible
                                          ? Divider(
                                              height: 1, color: Colors.black)
                                          : Container(),
                                      showLoader
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      32, 32, 32, 0),
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                            new Radius.circular(
                                                                100.0)),
                                                    color: Colors.colorgreen),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: 60,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      32, 32, 32, 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                  String phone = phoneController
                                                      .text
                                                      .toString();
                                                  String password =
                                                      passwordController.text
                                                          .toString();
                                                  String cPassword =
                                                      password2Controller.text
                                                          .toString();
                                                  if (isVisible) {
                                                    setState(() {
                                                      showLoader = true;
                                                    });
                                                    Utils.checkInternet()
                                                        .then((connected) {
                                                      if (connected != null &&
                                                          connected) {
                                                        bloc.fetchData(phone);
                                                      } else {
                                                        setState(() {
                                                          showLoader = false;
                                                        });
                                                        Toast.show(
                                                            "Not connected to internet",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      }
                                                    });

                                                    passwordObserver(context);
                                                  } else {
                                                    if (password.length > 0 &&
                                                        cPassword == password) {
                                                      print(
                                                          "Phone: $phone Password: $password");
                                                      setState(() {
                                                        showLoader = true;
                                                      });
                                                      Utils.checkInternet()
                                                          .then((connected) {
                                                        if (connected != null &&
                                                            connected) {
                                                          var blocPassword =
                                                              ForgotPasswordBloc();
                                                          blocPassword
                                                              .fetchData(phone,
                                                                  password);
                                                          blocPassword
                                                              .passwordData
                                                              .listen((res) {
                                                            setState(() {
                                                              showLoader =
                                                                  false;
                                                            });
                                                            var obj =
                                                                jsonDecode(res);
                                                            if (obj['status'] ==
                                                                "true") {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }
                                                            Toast.show(
                                                                obj['msg'],
                                                                context,
                                                                duration: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity: Toast
                                                                    .BOTTOM);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showLoader = false;
                                                          });
                                                          Toast.show(
                                                              "Not connected to internet",
                                                              context,
                                                              duration: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  Toast.BOTTOM);
                                                        }
                                                      });
                                                    } else {
                                                      if (password.isEmpty) {
                                                        Toast.show(
                                                            "Enter Password.",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      } else if (cPassword
                                                          .isEmpty) {
                                                        Toast.show(
                                                            "Enter Confirm Password.",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      } else if (password !=
                                                          cPassword) {
                                                        Toast.show(
                                                            "Your New password and Confirm password field does not match.",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      } else {
                                                        Toast.show(
                                                            "Enter valid credentials",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: new BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius.all(
                                                              new Radius
                                                                      .circular(
                                                                  100.0)),
                                                      color: Colors.colorgreen),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: 60,
                                                    child: Center(
                                                      child: new Text("Submit",
                                                          style: new TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  )),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void passwordObserver(BuildContext context) {
    int value = 0;
    bloc.phoneData.listen((res) {
      setState(() {
        showLoader = false;
      });
      var obj = jsonDecode(res);
      if (obj['status'] == "true") {
        // Navigator.of(context).pop();
        if (value == 0) {
          value = 1;

          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => PinViewUpdatePage(
                otp: obj['otp'].toString(),
                phone: phoneController.text.toString(),
                password: passwordController.text.toString(),
              ),
            ),
          ).then((value) {
            var f = value;
            if (value == "yes") {
              setState(() {
                isVisible = false;
              });
            }
          });
        }
      } else {
        Toast.show(obj['msg'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
