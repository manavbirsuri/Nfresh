import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/login_bloc.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/SignUp.dart';
import 'package:toast/toast.dart';

import '../main.dart';
import '../utils.dart';
import 'forgot_password.dart';

/*class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginState(),
    );
  }
}*/

class LoginPage extends StatefulWidget {
  final int from;
  const LoginPage({Key key, this.from}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePage();
  }
}

class MyHomePage extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var showText = true;
  var valueShow = "Show";
  var bloc = LoginBloc();
  bool showLoader = false;
  var _prefs = SharedPrefs();
  var _database = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
    bloc.profileData.listen((data) {
      print("PRO DATA:: $data");

      setState(() {
        showLoader = false;
      });
      if (data.status == "true") {
        _database.clearCart();
        //getCartCount();
        String profileData = jsonEncode(data.profile);
        _prefs.saveProfile(profileData);
        if (widget.from == 1) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => DashBoard()),
          );
        }
      } else {
        Toast.show(data.msg, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
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
                child: Column(
                  children: <Widget>[
                    Container(
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
                                /* Padding(
                                padding: EdgeInsets.only(top: 26),
                                child: Image.asset(
                                  'assets/logo.png',
                                ),
                              ),*/
                                Container(
                                  margin: EdgeInsets.only(top: 26),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/logo.png'),
                                    ),
                                  ),
                                  height: 80,
                                ),
                                Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 32, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Mobile Number",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.colorgreen),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 0),
                                          child: Center(
                                            child: TextFormField(
                                              controller: emailController,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                                BlacklistingTextInputFormatter(
                                                    new RegExp('[\\.|\\,]')),
                                              ],
                                              decoration:
                                                  new InputDecoration.collapsed(
                                                      hintText:
                                                          'Enter Mobile No.'),
                                              textAlign: TextAlign.start,
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: false),
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                        ),
                                        Divider(height: 1, color: Colors.black),
                                        Padding(
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
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
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
                                                                  'Enter Password'),
                                                      controller:
                                                          passwordController,
                                                      obscureText: showText,
                                                      textAlign:
                                                          TextAlign.start,
                                                      textInputAction:
                                                          TextInputAction.done,
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
                                                      padding: EdgeInsets.only(
                                                          bottom: 0, left: 0),
                                                      child: valueShow == "Hide"
                                                          ? Icon(
                                                              Icons.visibility,
                                                              size: 20,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .visibility_off,
                                                              size: 20),
                                                    ),
                                                  ),
                                                ),
                                                flex: 1,
                                              ),
                                            ])),
                                        Divider(height: 1, color: Colors.black),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgotPasswordPage()),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Align(
                                              child: Text("Forgot Password?"),
                                              alignment: Alignment.topRight,
                                            ),
                                          ),
                                        ),
                                        showLoader
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        32, 32, 32, 0),
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
                                                    String phone =
                                                        emailController.text
                                                            .toString();
                                                    String password =
                                                        passwordController.text
                                                            .toString();

                                                    if (phone.length > 0 &&
                                                        phone.length == 10 &&
                                                        password.length > 0) {
                                                      print(
                                                          "Phone: $phone Password: $password");
                                                      setState(() {
                                                        showLoader = true;
                                                      });
                                                      Utils.checkInternet()
                                                          .then((connected) {
                                                        if (connected != null &&
                                                            connected) {
                                                          bloc.fetchData(
                                                              phone, password);
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
                                                      if (phone.length < 10 ||
                                                          phone.length > 10) {
                                                        Toast.show(
                                                            "Enter 10 digit mobile number",
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
                                                  },
                                                  child: Container(
                                                    decoration: new BoxDecoration(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .all(new Radius
                                                                    .circular(
                                                                100.0)),
                                                        color:
                                                            Colors.colorgreen),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      height: 60,
                                                      child: Center(
                                                        child: new Text(
                                                            "Sign In",
                                                            style:
                                                                new TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 16, 0, 0),
                                          child: Align(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Don't have an account?",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              new SignUp()),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Sign Up",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.colorgreen,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashBoard()),
                              ModalRoute.withName("/Home"));
//                        Navigator.push(
//                          context,
//                          new MaterialPageRoute(
//                              builder: (context) => new SignUp()),
//                        );
                        },
                        child: Text(
                          "Click here to go Home",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
