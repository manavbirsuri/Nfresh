import 'package:flutter/material.dart';
import 'package:nfresh/bloc/order_detail_bloc.dart';
import 'package:nfresh/bloc/reorder_bloc.dart';
import 'package:nfresh/models/order_product_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/responses/response_order_detail.dart';
import 'package:nfresh/resources/database.dart';
import 'package:toast/toast.dart';

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
  var blocReorder = ReorderBloc();
  var _database = DatabaseHelper.instance;

  bool showLoader = false;
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
              child: StreamBuilder(
                stream: bloc.orderDetail,
                builder:
                    (context, AsyncSnapshot<ResponseOrderDetail> snapshot) {
                  if (snapshot.hasData) {
                    return mainContent(snapshot);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
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
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
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
                    child: Text(orderDetail.createdAt),
                  ),
                ],
              ),
              trailing: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Rs ${orderDetail.total} / ${orderDetail.products.length} Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, position) {
                return getNestedListItem(position, orderDetail.products);
              },
              itemCount: orderDetail.products.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              //  primary: false,
            )),
          ],
        ),
      ),
    );
  }

  Widget getNestedListItem(int position, List<OrderProduct> products) {
    var product = products[position];
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(product.nameHindi),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Text(
                            'Qty: ${product.qty}',
                            style: TextStyle(fontSize: 12),
                          ),
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
                      '₹ ${product.price}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(product.tierQty),
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
        Expanded(child: getMainCardItem(context, snapshot.data)),
        Container(
          color: Colors.colorgreen,
          height: 65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              showLoader
                  ? Center(child: CircularProgressIndicator())
                  : FlatButton(
                      onPressed: () {
                        setState(() {
                          showLoader = true;
                        });
                        blocReorder
                            .fetchSearchData(snapshot.data.order.orderId);
                        observeReorder(context);
                      },
                      child: Text(
                        "REORDER",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
            ],
          ),
        )
      ],
    );
  }

  void insertIntoCart(List<Product> products, context) {
    for (int i = 0; i < products.length; i++) {
      _database.update(products[i]);
    }

    Toast.show(
        'Your products has been added to the cart successfully.', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  void observeReorder(context) {
    blocReorder.reorderedData.listen((response) {
      setState(() {
        showLoader = false;
      });
      if (response.status == "true") {
        if (response.msg.length > 3) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Alert!"),
                content: new Text(response.msg),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      insertIntoCart(response.products, context);
                    },
                  ),
                  new FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          insertIntoCart(response.products, context);
        }
      } else {
        Toast.show(response.msg, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
