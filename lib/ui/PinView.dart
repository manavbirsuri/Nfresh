import 'package:flutter/material.dart';
import 'package:nfresh/DashBoard.dart';
import 'package:nfresh/bloc/otp_bloc.dart';
import 'package:pin_view/pin_view.dart';

class PinViewPage extends StatefulWidget {
  final id;
  const PinViewPage({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PinState();
  }
}

class PinState extends State<PinViewPage> {
  var bloc = OtpBloc();

  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    bloc.searchedData.listen((response) {
      if (response.status == "true") {
        if (response.activate == 0) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(response.msg),
            ),
          );
        } else {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => DashBoard()),
          );
        }
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(response.msg),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
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
                    style:
                        TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
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
                        verifyOtpWebservice(pin, widget.id);
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
                        color: Colors.colorgreen, fontSize: 18, fontWeight: FontWeight.bold),
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
                      borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
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

  void verifyOtpWebservice(String pin, id) {
    setState(() {
      showLoader = true;
    });
    bloc.fetchSearchData(id, pin);
  }
}
