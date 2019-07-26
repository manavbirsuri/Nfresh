import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfresh/bloc/forgot_password_bloc.dart';
import 'package:nfresh/bloc/resend_otp_bloc.dart';
import 'package:nfresh/bloc/update_phone_bloc.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/pin_view_update.dart';
import 'package:toast/toast.dart';

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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset(
              'assets/sigbg.jpg',
              fit: BoxFit.fill,
            ),
          ),
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
                            Padding(
                              padding: EdgeInsets.only(top: 26),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/logo.png',
                                ),
                              ),
                            )
                          ]),
                          Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: <Widget>[
                                  isVisible
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 32, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Phone Number",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.colorgreen),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  isVisible
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Center(
                                            child: TextField(
                                              controller: phoneController,
                                              decoration:
                                                  new InputDecoration.collapsed(
                                                      hintText:
                                                          'Enter Phone No.'),
                                              textAlign: TextAlign.start,
                                              keyboardType: TextInputType.phone,
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  isVisible
                                      ? Divider(height: 1, color: Colors.black)
                                      : Container(),
                                  !isVisible
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 32, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Password",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.colorgreen),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  !isVisible
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Row(children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                child: Center(
                                                  child: TextField(
                                                    decoration: new InputDecoration
                                                            .collapsed(
                                                        hintText:
                                                            'Enter New Password'),
                                                    controller:
                                                        passwordController,
                                                    obscureText: showText,
                                                    textAlign: TextAlign.start,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  ),
                                                ),
                                              ),
                                              flex: 5,
                                            ),
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (passwordController.text
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
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 0),
                                                    child: Text(
                                                      valueShow,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .colorgreen),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ]))
                                      : Container(),
                                  !isVisible
                                      ? Divider(height: 1, color: Colors.black)
                                      : Container(),
                                  !isVisible
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 32, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Confirm Password",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.colorgreen),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  !isVisible
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Row(children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                child: Center(
                                                  child: TextField(
                                                    decoration: new InputDecoration
                                                            .collapsed(
                                                        hintText:
                                                            'Confirm New Password'),
                                                    controller:
                                                        password2Controller,
                                                    obscureText: showText2,
                                                    textAlign: TextAlign.start,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  ),
                                                ),
                                              ),
                                              flex: 5,
                                            ),
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (password2Controller.text
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
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 0),
                                                    child: Text(
                                                      valueShow2,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .colorgreen),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ]))
                                      : Container(),
                                  !isVisible
                                      ? Divider(height: 1, color: Colors.black)
                                      : Container(),
                                  showLoader
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              32, 32, 32, 0),
                                          child: Container(
                                            decoration: new BoxDecoration(
                                                borderRadius: new BorderRadius
                                                        .all(
                                                    new Radius.circular(100.0)),
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
                                          padding: const EdgeInsets.fromLTRB(
                                              32, 32, 32, 0),
                                          child: GestureDetector(
                                            onTap: () {
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
                                                bloc.fetchData(phone);
                                                passwordObserver(context);
                                              } else {
                                                if (password.length > 0 &&
                                                    cPassword == password) {
                                                  print(
                                                      "Phone: $phone Password: $password");
                                                  setState(() {
                                                    showLoader = true;
                                                  });
                                                  var blocPassword =
                                                      ForgotPasswordBloc();
                                                  blocPassword.fetchData(
                                                      phone, password);
                                                  blocPassword.passwordData
                                                      .listen((res) {
                                                    setState(() {
                                                      showLoader = false;
                                                    });
                                                    var obj = jsonDecode(res);
                                                    if (obj['status'] ==
                                                        "true") {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                    Toast.show(
                                                        obj['msg'], context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  });
                                                } else {
                                                  if (password.isEmpty) {
                                                    Toast.show(
                                                        "Enter Password.",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  } else if (cPassword
                                                      .isEmpty) {
                                                    Toast.show(
                                                        "Enter Confirm Password.",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  } else if (password !=
                                                      cPassword) {
                                                    Toast.show(
                                                        "Your New password and Confirm password field does not match.",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  } else {
                                                    Toast.show(
                                                        "Enter valid credentials",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  }
                                                }
                                              }
                                            },
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
    );
  }

  void passwordObserver(BuildContext context) {
    bloc.phoneData.listen((res) {
      setState(() {
        showLoader = false;
      });
      var obj = jsonDecode(res);
      if (obj['status'] == "true") {
        // Navigator.of(context).pop();
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
          setState(() {
            isVisible = false;
          });
        });
      } else {
        Toast.show(obj['msg'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
