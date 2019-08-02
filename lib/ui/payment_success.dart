import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfresh/bloc/create_order_bloc.dart';
import 'package:nfresh/bloc/profile_bloc.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';

import '../main.dart';

class PaymentSuccessPage extends StatefulWidget {
  final response;
  final cartExtra;
  const PaymentSuccessPage(
      {Key key, this.response, this.cartExtra, String from})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PaymentState();
  }
}

class PaymentState extends State<PaymentSuccessPage> {
  String message;
  var _database = DatabaseHelper.instance;
  bool isSuccess = false;
  List<Map<String, dynamic>> lineItems = [];
  var bloc = CreateOrderBloc();
  var dialog;
  var blocProfile = ProfileBloc();
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    if (widget.response != "") {
      print("JSON: ${widget.response}");
      var obj = jsonDecode(widget.response);
      var status = obj['STATUS'];
      if (status == 'TXN_SUCCESS') {
        // payment success
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
    } else {
      setState(() {
        isSuccess = true;
        message = "Payment is successful";
      });
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (isSuccess) {
        placeOrder(widget.cartExtra);
      }
    });
    bloc.createOrderResponse.listen((res) {
      var obj = jsonDecode(res);
      String status = obj['status'];
      setState(() {
        showLoader = false;
        message = obj['msg'];
      });
      if (status == "true") {
        _database.clearCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    blocProfile.fetchData();
    profileObserver();
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
                    showLoader
                        ? Center(child: CircularProgressIndicator())
                        : FlatButton(
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
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
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

  void placeOrder(cartExtra) {
    // dialog = ProgressDialog(context, ProgressDialogType.Normal);
    //   dialog.setMessage("Placing your order...");
    // dialog.show();
    setState(() {
      message = "Placing your order. Please wait...";
      showLoader = true;
    });

    _database.queryAllProducts().then((products) {
      products.forEach((product) {
        Map<String, dynamic> map = {
          'product_id': product.id,
          'unitqty': product.selectedPacking.unitQty,
          'qty': product.count,
        };
        lineItems.add(map);
      });
      bloc.fetchData(lineItems, cartExtra, widget.response);
    });
  }

  void profileObserver() {
    blocProfile.profileData.listen((res) {
      print("Profile Status = " + res.status);
      if (res.status == "true") {
        var _prefs = SharedPrefs();

        String profileData = jsonEncode(res.profile);
        _prefs.saveProfile(profileData);
      }
    });
  }
}
