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
  final method;

  const PaymentSuccessPage(
      {Key key, this.response, this.cartExtra, String from, this.method})
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
  bool showLoaderee = false;
  var title = "Payment";
  @override
  void initState() {
    super.initState();
    if (widget.method == "Cash on delivery") {
      setState(() {
        title = "Processing";
      });
    }
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
        Navigator.pop(context);
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
        showLoaderee = true;
        title = "Payment";
        message = obj['msg'];
      });
      if (status == "true") {
        _database.clearCart();
      } else {
        Navigator.pop(context);
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
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body:
                // message == "Payment is successfull"
                showLoaderee
                    ? Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage('assets/placeorder.png'),
                                      ),
                                    ),
                                    height: 150,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(
                                      message,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              flex: 4,
                            ),
                            showLoader
                                ? Center(child: CircularProgressIndicator())
                                : Flexible(
                                    child: Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashBoard()),
                                                ModalRoute.withName("/Home"));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          new Radius.circular(
                                                              100.0)),
                                                  color: Colors.colorgreen),
                                              child: SizedBox(
                                                width: 150,
                                                height: 40,
                                                child: Center(
                                                  child:
                                                      new Text("Back to Home",
                                                          style: new TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          )),
                                                ),
                                              ),
                                            ),
                                          ),

//                                  Text(
//                                    "Done",
//                                    style: TextStyle(
//                                        color: Colors.green,
//                                        fontWeight: FontWeight.bold),
//                                  ),
                                        ),
                                      ),
                                    ),
                                    flex: 1,
                                  )
                          ],
                        ))
                    : Container(
                        color: Colors.white,
                        child: Center(child: CircularProgressIndicator()))
            //: Text("")
            ),
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
