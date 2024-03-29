import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/otp_bloc.dart';
import 'package:nfresh/bloc/resend_otp_bloc.dart';
import 'package:nfresh/main.dart';
import 'package:pin_view/pin_view.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class PinViewPage extends StatefulWidget {
  var id;
  String phoneNo;
  PinViewPage(int userId, String phoneNo) {
    this.id = userId;
    this.phoneNo = phoneNo;
  }

  @override
  State<StatefulWidget> createState() {
    return PinState();
  }
}

class PinState extends State<PinViewPage> {
  var bloc = OtpBloc();
  TextEditingController emailController = new TextEditingController();
  bool showLoader = false;

  String enteredPin = "";
  bool resendLoader = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: BackButton(color: Colors.green),
//        leading: new IconButton(
//          icon: new Icon(
//            Icons.arrow_back,
//            color: Colors.black,
//          ),
//          onPressed: () => Navigator.pop(context),
//        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
//              Padding(
//                padding: EdgeInsets.fromLTRB(86, 16, 86, 0),
//                child: Center(
//                  child: PinView(
//                      count: 4, // count of the fields, excluding dashes
//                      autoFocusFirstField: false,
//                      obscureText: true,
//                      submit: (String pin) {
//                        setState(() {
//                          enteredPin = pin;
//                        });
//                      } // gets triggered when all the fields are filled
//
//                      // gets triggered when all the fields are filled
//                      ),
//                  // end onSubmit
//                ),
//              ),
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
                      var bloc = ResendOtpBloc();
                      bloc.resendOtp(widget.phoneNo);
                      bloc.notificationData.listen((value) {
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
                      verifyOtpWebservice(enteredPin, widget.id, context);
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
        ),
      ),
    );
  }

  void verifyOtpWebservice(String pin, id, context) {
    setState(() {
      showLoader = true;
    });
    bloc.fetchSearchData(id, pin);
    bloc.searchedData.listen((response) {
      setState(() {
        showLoader = false;
      });
      if (response.status == "true") {
        if (response.activate == 0) {
          showAlertMessage(context, response.msg);
        } else {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => DashBoard()),
          );
        }
      } else {
        Toast.show(response.msg, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }

  void showAlertMessage(context, message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => DashBoard()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
