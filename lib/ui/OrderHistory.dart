import 'package:flutter/material.dart';
import 'package:nfresh/bloc/orders_bloc.dart';
import 'package:nfresh/models/order_model.dart';
import 'package:nfresh/models/responses/response_order.dart';
import 'package:nfresh/ui/OrderPage.dart';

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
  var bloc = OrdersBloc();

  @override
  void initState() {
    super.initState();
    bloc.fetchOrdersData();
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
            child: StreamBuilder(
              stream: bloc.ordersList,
              builder: (context, AsyncSnapshot<ResponseOrderHistory> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.orders.length > 0
                      ? mainContent(snapshot)
                      : noDataView();
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        )
      ],
    );
  }

  Widget getListItem(position, List<Order> orders) {
    var order = orders[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new OrderPage(
                    title: 'Order Id : ${order.orderId}',
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
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Order Id: ${order.orderId}',
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
                                order.orderCreatedAt,
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
                          "₹${order.orderTotal}",
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
                      child: Text(
                        order.orderStatus,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[],
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

  Widget mainContent(AsyncSnapshot<ResponseOrderHistory> snapshot) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ListView.builder(
          itemBuilder: (context, position) {
            return getListItem(position, snapshot.data.orders);
          },
          itemCount: snapshot.data.orders.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
        )
      ],
    );
  }

  Widget noDataView() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("No order placed yet")],
      ),
    );
  }
}
