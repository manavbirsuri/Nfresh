import 'package:flutter/material.dart';

import 'OrderPage.dart';

class OrderHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrderState());
  }
}

class OrderState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderHistoryState();
  }
}

class OrderHistoryState extends State<OrderState> {
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
              "Order History",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          body: Container(
            color: Colors.colorlightgreyback,
            child: ListView.builder(
              itemBuilder: (context, position) {
                return getListItem(position);
              },
              itemCount: 8,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            ),
          ),
        )
      ],
    );
  }

  Widget getListItem(position) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new OrderPage(
                    title: 'Order Id : 123GD$position',
                  ),
            ));
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    /*Image.asset(
                    'assets/pea.png',
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),*/
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Order Id: 123GD$position',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.colorgreen),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                              ),
                              child: Text(
                                '10 Jun, 2019',
                                style: TextStyle(fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
//                          Text(
//                            'Size : 3$position',
//                            style: TextStyle(fontSize: 13),
//                          ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                flex: 1,
              ),
              Container(
                // padding: EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Total  "),
                        Text(
                          "₹35$position",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
//                  Text(
//                    'Total ₹ 23$position',
//                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                  ),
                    Padding(
                      child: position == 4
                          ? Text(
                              'Delivered',
                              style: TextStyle(
                                  color: Colors.colorPink,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Processing',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
//                      GestureDetector(
//                        child: Container(
//                          decoration: BoxDecoration(color: Colors.colorPink),
//                          padding: EdgeInsets.only(
//                            top: 4,
//                            bottom: 4,
//                            left: 8,
//                            right: 8,
//                          ),
                        /*Text(
                        '23 May,2019',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),*/
//                        ),
//                        onTap: () {},
//                      )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//}
//    return ListView.builder(
//      itemBuilder: (context, position) {
//        return Column(
//          children: <Widget>[
//            ListTile(
//              title: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    'Product Name $position',
//                    style: TextStyle(color: Colors.black, fontSize: 18),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(top: 8, bottom: 8),
//                    child: Text(
//                      'Product Description. This description will be of 2 lines maximum on this cell of order history',
//                      style: TextStyle(fontSize: 13),
//                      maxLines: 2,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                  ),
//                ],
//              ),
//              //contentPadding: EdgeInsets.all(0),
//              trailing: Container(
//                // color: Colors.amber,
//                child: Row(
//                  mainAxisSize: MainAxisSize.min,
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      children: <Widget>[
//                        Row(
//                          mainAxisSize: MainAxisSize.min,
//                          children: <Widget>[
//                            Text("Total  "),
//                            Text(
//                              "₹35$position",
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold, fontSize: 16),
//                            ),
//                            Icon(
//                              Icons.navigate_next,
//                              color: Colors.colorPink,
//                              size: 20,
//                            )
//                          ],
//                        ),
//                        // Flexible(
//                        Container(
//                          // padding: EdgeInsets.only(top: 8, bottom: 8),
//                          child: position == 4
//                              ? Text(
//                                  'Delivered',
//                                  style: TextStyle(
//                                      color: Colors.colorPink,
//                                      fontWeight: FontWeight.bold),
//                                )
//                              : Text(
//                                  'Processing',
//                                  style: TextStyle(fontWeight: FontWeight.bold),
//                                ),
//                        ),
//                        //   flex: 1,
//                        // ),
//
//                        Container(
//                          child:Text('23 May, 2019')
//
////                          position == 4
////                              ? Text('23 May, 2019')
////                              : GestureDetector(
////                                  child: Text(
////                                    'Track your order',
////                                    style: TextStyle(
////                                      color: Colors.colorPink,
////                                      decoration: TextDecoration.underline,
////                                    ),
////                                  ),
////                                  onTap: () {
////                                    Scaffold.of(context).showSnackBar(SnackBar(
////                                      content: Text('Track order Coming soon'),
////                                      duration: Duration(seconds: 1),
////                                    ));
////                                  },
////                                ),
//                        ),
//                      ],
//                    )
//                  ],
//                ),
//              ),
//            ),
//            Padding(
//              padding: EdgeInsets.only(top: 8, bottom: 8),
//              child: Divider(
//                height: 1,
//                color: Colors.grey,
//              ),
//            )
//          ],
//        );
//      },
//      shrinkWrap: true,
//      itemCount: 10,
//    );
//  }
//}
