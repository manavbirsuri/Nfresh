import 'package:flutter/material.dart';
import 'package:nfresh/bloc/login_bloc.dart';
import 'package:nfresh/ui/SignUp.dart';

import '../DashBoard.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginState(),
    );
  }
}

class LoginState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePage();
  }
}

class MyHomePage extends State<LoginState> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var showText = true;
  var valueShow = "Show";
  var bloc = LoginBloc();
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    bloc.profileData.listen((data) {
      print("PRO DATA:: $data");
      setState(() {
        showLoader = false;
      });
      if (data.status == "true") {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (context) => DashBoard()),
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(data.msg),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Phone Number",
                                        style: TextStyle(fontSize: 18, color: Colors.colorgreen),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Center(
                                    child: TextField(
                                      controller: emailController,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: 'Enter Phone No.'),
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),
                                Divider(height: 1, color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Password",
                                        style: TextStyle(fontSize: 18, color: Colors.colorgreen),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Row(children: <Widget>[
                                      Flexible(
                                        child: Container(
                                          child: Center(
                                            child: TextField(
                                              decoration: new InputDecoration.collapsed(
                                                  hintText: 'Enter Password'),
                                              controller: passwordController,
                                              obscureText: showText,
                                              textAlign: TextAlign.start,
                                              textInputAction: TextInputAction.done,
                                            ),
                                          ),
                                        ),
                                        flex: 4,
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (passwordController.text.toString().length > 0) {
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
                                              padding: EdgeInsets.only(bottom: 8, left: 0),
                                              child: Text(
                                                valueShow,
                                                style: TextStyle(
                                                    fontSize: 18, color: Colors.colorgreen),
                                              ),
                                            ),
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                    ])),
                                Divider(height: 1, color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Align(
                                    child: Text("Forget Password?"),
                                    alignment: Alignment.topRight,
                                  ),
                                ),
                                showLoader
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                                        child: Container(
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(new Radius.circular(100.0)),
                                              color: Colors.colorgreen),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 60,
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            String phone = emailController.text.toString();
                                            String password = passwordController.text.toString();

                                            if (phone.length > 0 &&
                                                phone.length == 10 &&
                                                password.length > 3) {
                                              print("Phone: $phone Password: $password");
                                              setState(() {
                                                showLoader = true;
                                              });
                                              bloc.fetchData(phone, password);
                                            } else {
                                              if (phone.length < 10 || phone.length > 10) {
                                                Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Enter 10 digit mobile number"),
                                                  ),
                                                );
                                              } else {
                                                Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Enter valid credentials"),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Container(
                                            decoration: new BoxDecoration(
                                                borderRadius: new BorderRadius.all(
                                                    new Radius.circular(100.0)),
                                                color: Colors.colorgreen),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 60,
                                              child: Center(
                                                child: new Text("Sign In",
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Align(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Don't have an account?",
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) => new SignUp()),
                                            );
                                          },
                                          child: Text(
                                            "Sign Up",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.colorgreen,
                                                fontWeight: FontWeight.bold),
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
          ),
        ),
      ],
    );
  }
}
