import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:nfresh/bloc/apply_coupon_bloc.dart';
import 'package:nfresh/bloc/coupon_bloc.dart';
import 'package:nfresh/models/coupon_model.dart';
import 'package:nfresh/models/responses/response_coupons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoCodePage extends StatefulWidget {
  final total;
  const PromoCodePage({Key key, this.total}) : super(key: key);

  @override
  PromoCodeState createState() => PromoCodeState();
}

class PromoCodeState extends State<PromoCodePage> {
  var bloc = CouponBloc();
  var blocApply = ApplyCouponBloc();
  var dialog;

  var couponController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      bloc.fetchData();
    });
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
              title: Text('Apply Coupon'),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: couponController,
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText: 'Enter promo code'),
                                      ),
                                      flex: 4,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          dialog = new ProgressDialog(context,
                                              ProgressDialogType.Normal);
                                          dialog.setMessage("Please wait...");
                                          dialog.setCancelable(false);
                                          dialog.show();
                                          blocApply.fetchData(widget.total,
                                              couponController.text.toString());
                                          observeResponse(context,
                                              couponController.text.toString());
                                        },
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                              color: Colors.colorgreen,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                                    child: Text(
                                      "AVAILABLE COUPONS",
                                      style: TextStyle(
                                          color: Colors.colorgreen,
                                          fontSize: 16),
                                      textAlign: TextAlign.start,
                                    )),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ))
                              ],
                            )),
                        Expanded(
                          child: StreamBuilder(
                            stream: bloc.couponsList,
                            builder: (context,
                                AsyncSnapshot<ResponseCoupons> snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data.coupons.length > 0
                                    ? mainContent(snapshot)
                                    : noDataView();
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget getListItem(int position, List<Coupon> coupons) {
    var coupon = coupons[position];
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: DottedBorder(
                  color: Colors.black,
                  gap: 3,
                  strokeWidth: 1,
                  child: Text(
                    coupon.couponCode,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (widget.total < coupon.minValue) {
                    showMessage(context, coupon);
                  } else {
                    dialog =
                        new ProgressDialog(context, ProgressDialogType.Normal);
                    dialog.setMessage("Please wait...");
                    // dialog.setCancelable(false);
                    dialog.show();
                    blocApply.fetchData(widget.total, coupon.couponCode);
                    observeResponse(context, coupon.couponCode);
                  }
                },
                child: Text(
                  'Apply',
                  style: TextStyle(
                      color: Colors.colorgreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 16),
            child: Text(
              coupon.name,
              style: TextStyle(color: Colors.black),
            ),
          ),
//          Padding(
//            padding: EdgeInsets.only(top: 8, ),
//            child: Text(
//              'view details',
//              style: TextStyle(color: Colors.colorgreen),
//            ),
//          ),
          Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Divider(
                color: Colors.grey,
                height: 1,
              )),
        ],
      ),
    );
  }

  saveToPrefs(int discount, String couponCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dd = couponController.text.toString();
    await prefs.setString('couponCode', couponCode);
    await prefs.setString('promoApplies', "yes");
    await prefs.setInt("discount", discount);
  }

  Widget noDataView() {
    return Container(
      //color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("No coupons available"),
          )
        ],
      ),
    );
  }

  Widget mainContent(AsyncSnapshot<ResponseCoupons> snapshot) {
    return ListView.builder(
      itemBuilder: (context, position) {
        return getListItem(position, snapshot.data.coupons);
      },
      itemCount: snapshot.data.coupons.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }

  void showMessage(context, Coupon coupon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(
              "Your minimum cart value should be ₹${coupon.minValue} to use this offer."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void observeResponse(BuildContext context, String couponCode) {
    blocApply.getResponse.listen((response) {
      var json = jsonDecode(response);
      String status = json['status'];

      dialog.hide();

      if (status == "true") {
        Navigator.pop(context);
        int discount = json['discount'];
        saveToPrefs(discount, couponCode);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Material(
                type: MaterialType.transparency,
                child: Container(
                  child: DynamicDialog(),
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                ),
              );
            });
      } else {
        Navigator.pop(context);
      }
    });
  }
}

class DynamicDialog extends StatefulWidget {
//  DynamicDialog({this.title});

//  final String title;

  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  String _title;
  var liked = false;
  String image1 = "assets/fav_filled.png";
  String image2 = "assets/ic_fav.png";
  String currentimage = "assets/ic_fav.png";

  _verticalDivider() => BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      );

  @override
  void initState() {
//    _title = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Image.asset(
            "assets/donepromo.png",
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "Promo code successfully applied.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.colorgrey,
                fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              width: 80,
              decoration: new BoxDecoration(
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(100.0)),
                  color: Colors.colorgreen),
              child: Center(
                child: new Text("Ok",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
              ),
            ),
          ),
        ),
      ]))
    ]));
  }
}
