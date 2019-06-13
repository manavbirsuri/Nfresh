import 'package:flutter/material.dart';
import 'package:nfresh/DashBoard.dart';
import 'package:pin_view/pin_view.dart';

class PinViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinViewState(),
    );
  }
}

class PinViewState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Pinstate();
  }
}

class Pinstate extends State<PinViewState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Stack(
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(86, 16, 86, 0),
                child: Center(
                  child: PinView(
                      count: 4, // count of the fields, excluding dashes
                      autoFocusFirstField: false,
                      obscureText: true,
                      submit: (String pin) {
                        if (pin == "1234") {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new DashBoard()),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text("Alert!"),
                                    content: Text(
                                        "You have entered wrong Pin: $pin"));
                              });
                        }
                      } // gets triggered when all the fields are filled

                      // gets triggered when all the fields are filled
                      ),
                  // end onSubmit
                ),
              ),
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
                child: Center(
                  child: Text(
                    "RESEND",
                    style: TextStyle(
                        color: Colors.colorgreen,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DashBoard()),
                      ModalRoute.withName("/DashBoard"));
//                  Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                        builder: (context) => new DashBoard()),
//                  );
                },
                child: Container(
                  decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(100.0)),
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
    );
  }
}
