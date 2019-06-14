import 'package:flutter/material.dart';
import 'package:nfresh/bloc/coupon_bloc.dart';
import 'package:nfresh/models/responses/response_coupons.dart';
import 'package:share/share.dart';

class OffersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfferOrder(),
    );
  }
}

class OfferOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OfferOrderPage();
  }
}

class OfferOrderPage extends State<OfferOrder> {
  var bloc = CouponBloc();
  @override
  void initState() {
    super.initState();
    bloc.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.colorlightgreyback,
      child: StreamBuilder(
        stream: bloc.couponsList,
        builder: (context, AsyncSnapshot<ResponseCoupons> snapshot) {
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
    );
  }

  Widget noDataView() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            "No offer available right now",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget mainContent(AsyncSnapshot<ResponseCoupons> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, position) {
        var coupon = snapshot.data.coupons[position];
        return Padding(
            padding: EdgeInsets.only(top: 16),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2 / 1,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          child: Image.network(
                            coupon.image,
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Coupon Name: ",
                                        style: TextStyle(
                                          color: Colors.colorlightgrey,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        coupon.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 4),
                      child: Row(children: <Widget>[
                        Text(
                          "Coupon Code : ",
                          style: TextStyle(color: Colors.colorlightgrey),
                        ),
                        Text(
                          coupon.couponCode,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 8, right: 16),
                      child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Text(
                                "Valid upto : ",
                                style: TextStyle(color: Colors.colorlightgrey),
                              ),
                              Text(
                                coupon.endDate,
                                style: TextStyle(color: Colors.colorlightgrey),
                              ),
                            ]),
                            GestureDetector(
                              onTap: () {
                                print("DDDD");
                                Share.plainText(
                                        text: "Hi! share my app",
                                        title: "Share")
                                    .share();
//                            Share.share(
//                                'check out my website https://example.com');
                              },
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  child: Image.asset(
                                    "assets/share.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                )));
      },
      itemCount: snapshot.data.coupons.length,
    );
  }
}
