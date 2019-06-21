import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfresh/resources/database.dart';

import '../DashBoard.dart';

class PaymentSuccessPage extends StatefulWidget {
  final response;
  const PaymentSuccessPage({Key key, this.response}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PaymentState();
  }
}

class PaymentState extends State<PaymentSuccessPage> {
  String message;
  var _database = DatabaseHelper.instance;
  bool isSuccess = false;
  @override
  void initState() {
    super.initState();

    print("JSON: ${widget.response}");
    var obj = jsonDecode(widget.response);
    var status = obj['STATUS'];
    if (status == 'TXN_SUCCESS') {
      // payment success
      _database.clearCart();
      setState(() {
        isSuccess = true;
        message = "Payment is successful";
      });
    } else {
      // payment failure
      setState(() {
        isSuccess = false;
        message = "Payment processing error.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: Image.asset(
            'assets/sigbg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.colorgreen.withOpacity(0.5),
          appBar: AppBar(
            backgroundColor: Colors.colorgreen.withOpacity(0.0),
            title: Text(
              'Payment',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(message),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (isSuccess) {
                          Route route = MaterialPageRoute(
                            builder: (context) => DashBoard(),
                          );
                          Navigator.pushReplacement(context, route);
                        }
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
