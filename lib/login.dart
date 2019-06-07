import 'package:flutter/material.dart';

import 'DashBoard.dart';
import 'SignUp.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginState(),
    );
  }
}

class loginState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePage();
  }
}

class MyHomePage extends State<loginState> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var showText = true;
  var valueShow = "Show";

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        SizedBox.expand(
          child: Image.asset(
            'assets/sigbg.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Container(
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
                                    "Username",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.colorgreen),
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
                                      hintText: 'Enter Username'),
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
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
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.colorgreen),
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
                                          decoration:
                                              new InputDecoration.collapsed(
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
                                              bottom: 8, left: 0),
                                          child: Text(
                                            valueShow,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.colorgreen),
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new DashBoard()),
                                  );
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
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
        )
      ],
    );
  }
}
