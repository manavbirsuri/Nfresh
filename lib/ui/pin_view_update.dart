import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/forgot_password_bloc.dart';
import 'package:nfresh/bloc/update_phone2_bloc.dart';
import 'package:nfresh/bloc/update_phone_bloc.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:pin_view/pin_view.dart';
import 'package:toast/toast.dart';

class PinViewUpdatePage extends StatefulWidget {
  final String otp;
  final String phone;
  final String password;

  const PinViewUpdatePage({Key key, this.otp, this.phone, this.password})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PinState();
  }
}

class PinState extends State<PinViewUpdatePage> {
  var bloc = UpdatePhone2Bloc();
  var blocPassword = ForgotPasswordBloc();
  bool showLoader = false;
  bool resendLoader = false;
  String enteredPin = "";
  var _prefs = SharedPrefs();
  TextEditingController emailController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: BackButton(color: Colors.green),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/otp.png',
                      ),
                    ),
                  )
                ]),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      "OTP Verification",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Center(
                    child: TextField(
                      controller: emailController,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "OTP",
                          fillColor: Colors.white70),
                    ),
                    // end onSubmit
                  ),
                ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(86, 16, 86, 0),
//                    child: Center(
//                      child: PinView(
//                          count: 4, // count of the fields, excluding dashes
//                          autoFocusFirstField: false,
//                          obscureText: false,
//                          submit: (String pin) {
//                            setState(() {
//                              enteredPin = pin;
//                            });
//                          } // gets triggered when all the fields are filled
//                          ),
//                      // end onSubmit
//                    ),
//                  ),
                Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                    child: Text(
                      "Didn't receive the OTP?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        resendLoader = true;
                      });
                      var bloc = UpdatePhoneBloc();
                      bloc.fetchData(widget.phone);
                      bloc.phoneData.listen((value) {
                        setState(() {
                          resendLoader = false;
                        });
                      });
                    },
                    child: Center(
                      child: !resendLoader
                          ? Text(
                              "RESEND",
                              style: TextStyle(
                                  color: Colors.colorgreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(64, 8, 64, 16),
                child: GestureDetector(
                  onTap: () {
                    enteredPin = emailController.text.toString();
                    if (enteredPin.length == 4) {
                      verifyOtpWebservice(enteredPin, widget.otp, widget.phone,
                          widget.password);
                    } else {
                      Toast.show("Enter valid OTP", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  },
                  child: showLoader
                      ? Container(
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(100.0)),
                              color: Colors.colorgreen),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Container(
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(100.0)),
                              color: Colors.colorgreen),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Center(
                              child: new Text("Verify",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )),
//                                colorBrightness: Brightness.dark,
//                                onPressed: () {
//                                  if (emailController.text == "" &&
//                                      passwordController.text == "") {
////                              Navigator.push(
////                                context,
////                                new MaterialPageRoute(
////                                    builder: (context) => new DashBoard()),
////                              );
//                                  } else {
//                                    //_showDialog(context);
//                                  }
//                                },
//                                color: Colors.green,
                            ),
                          ),
                        ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  void verifyOtpWebservice(
      String pin, String otp, String phone, String password) {
    if (pin != otp) {
      Toast.show("You entered wrong OTP", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    setState(() {
      showLoader = true;
    });

//    if (password.length > 0) {
//      blocPassword.fetchData(phone, password);
//      blocPassword.passwordData.listen((res) {
//        setState(() {
//          showLoader = false;
//        });
//        var obj = jsonDecode(res);
//        if (obj['status'] == "true") {

//        }
//        Toast.show(obj['msg'], context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      });
//    } else {
    bloc.fetchData(phone);
    bloc.phoneData.listen((res) {
      setState(() {
        showLoader = false;
      });
      if (res.status == "true") {
        String data = jsonEncode(res.profile);
        _prefs.saveProfile(data);
        Navigator.pop(context, "yes");
      } else {
        Navigator.pop(context, "yes");
      }
      Toast.show(res.msg, context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      // }
    });
  }
}
