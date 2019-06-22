import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfresh/bloc/create_order_bloc.dart';
import 'package:nfresh/resources/database.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../DashBoard.dart';

class PaymentSuccessPage extends StatefulWidget {
  final response;
  final cartExtra;
  const PaymentSuccessPage({Key key, this.response, this.cartExtra}) : super(key: key);
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

  @override
  void initState() {
    super.initState();

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

    bloc.createOrderResponse.listen((res) {
      var obj = jsonDecode(res);
      String status = obj['status'];
      setState(() {
        message = obj['msg'];
      });
      if (status == "true") {
        _database.clearCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSuccess) {
      placeOrder(widget.cartExtra, context);
    }
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

  void placeOrder(cartExtra, context) {
    dialog = ProgressDialog(context, ProgressDialogType.Normal);
    dialog.setMessage("Placing your order.Please wait...");
    dialog.show();
    _database.queryAllProducts().then((products) {
      products.forEach((product) {
        Map<String, dynamic> map = {
          'product_id': product.id,
          'unitqty': product.selectedPacking.unitQty,
          'qty': product.count,
        };
        lineItems.add(map);
      });
      bloc.fetchData(lineItems, cartExtra);
    });
  }
}
