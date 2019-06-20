import 'package:flutter/material.dart';
import 'package:nfresh/bloc/order_detail_bloc.dart';
import 'package:nfresh/models/responses/response_order_detail.dart';

class OrderPage extends StatefulWidget {
  final String title;
  OrderPage({Key key, @required this.title}) : super(key: key);
  @override
  State createState() {
    return StateOrderPage();
  }
}

class StateOrderPage extends State<OrderPage> {
  var bloc = OrderDetailBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchOrderDetail(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: Image.asset(
            'assets/sigbg.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.colorgreen.withOpacity(0.5),
          appBar: AppBar(
            backgroundColor: Colors.colorgreen.withOpacity(0.0),
            title: Text(
              "Order Id : ${widget.title}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.colorlightgreyback,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                StreamBuilder(
                  stream: bloc.orderDetail,
                  builder: (context, AsyncSnapshot<ResponseOrderDetail> snapshot) {
                    if (snapshot.hasData) {
                      return mainContent(snapshot);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getMainCardItem(context, ResponseOrderDetail data) {
    var orderDetail = data.order;
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                'Order No: ${orderDetail.orderId}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              contentPadding: EdgeInsets.all(0),
              trailing: Text(
                orderDetail.status,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Placed on"),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text('Sat, July 14, 2018'),
                  ),
                ],
              ),
              trailing: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Rs 500 / 10 Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, position) {
                return getNestedListItem(position);
              },
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              //  primary: false,
            )),
          ],
        ),
      ),
    );
  }

  Widget getNestedListItem(int position) {
    return Container(
      // color: Colors.green,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          /*   ListTile(
            leading: Image.network(
              'http://pngriver.com/wp-content/uploads/2018/04/Download-Tomato-PNG-Pic.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            title: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tomato',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('टमाटर'),
                  ),
                ],
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text('Qty: 2kg'),
                ),
                Text(
                  'Rs. 50',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.network(
                      'http://pngriver.com/wp-content/uploads/2018/04/Download-Tomato-PNG-Pic.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Tomato',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('टमाटर'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 8.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Rs. 50',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Qty: 2kg'),
                    ),
                  ],
                ),
              ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mainContent(AsyncSnapshot<ResponseOrderDetail> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
            child: Column(
          children: <Widget>[
            Expanded(child: getMainCardItem(context, snapshot.data)),
          ],
        )),
        Container(
          color: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Text(
                  "REORDER",
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
