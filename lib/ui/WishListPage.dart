import 'package:flutter/material.dart';
import 'package:nfresh/bloc/get_fav_bloc.dart';
import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/responses/response_getFavorite.dart';
import 'package:nfresh/resources/database.dart';

import '../count_listener.dart';

class WishListPage extends StatefulWidget {
  final CountListener listener;
  const WishListPage({Key key, this.listener}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return WishPage();
  }
}

class WishPage extends State<WishListPage> {
  List<String> selectedValues = List();
  var pos = 0;
  var bloc = GetFavBloc();

  var _database = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    bloc.fetchFavData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        StreamBuilder(
          stream: bloc.favList,
          builder: (context, AsyncSnapshot<ResponseGetFav> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.products.length > 0 ? mainContent(snapshot) : noDataView();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Column(
              children: <Widget>[Center(child: CircularProgressIndicator())],
            );
          },
        ),
      ],
    ));
  }

  BoxDecoration myBoxDecoration2() {
    return BoxDecoration(
      border: Border.all(color: Colors.colorgreen, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
      border: Border.all(color: Colors.colorlightgrey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  Widget mainContent(AsyncSnapshot<ResponseGetFav> snapshot) {
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, position) {
            var product = snapshot.data.products[position];
            return IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Align(
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.colorgreen,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Text(
                                      product.nameHindi,
                                      style: TextStyle(fontSize: 16, color: Colors.colorlightgrey),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '₹ ${product.packing[0].price}  ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.colorlightgrey,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            '₹${product.displayPrice}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.colororange,
                                                decoration: TextDecoration.lineThrough),
                                            textAlign: TextAlign.start,
                                          ),
                                        ]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 32,
                                          width: 120,
                                          decoration: myBoxDecoration3(),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 8, left: 8),
                                              child: DropdownButtonFormField<Packing>(
                                                decoration: InputDecoration.collapsed(hintText: ''),
                                                value: product.selectedPacking,
                                                items: product.packing.map((Packing value) {
                                                  return new DropdownMenuItem<Packing>(
                                                    value: value,
                                                    child: new Text(
                                                      value.unitQtyShow,
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    product.selectedPacking = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Image.asset(
                                        'assets/delete.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                  /* Padding(
                                    padding: EdgeInsets.only(right: 0, left: 8),
                                    child: Container(
                                        height: 32,
                                        width: 120,
                                        decoration: myBoxDecoration2(),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Flexible(
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Image.asset(
                                                      'assets/minus.png',
                                                      color: Colors.colorgreen,
                                                    ),
                                                  ),
                                                ),
                                                flex: 1,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  product.count.toString(),
                                                  style: TextStyle(
                                                      color: Colors.colorgreen,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                flex: 1,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Image.asset(
                                                    'assets/plus.png',
                                                    color: Colors.colorgreen,
                                                  ),
                                                ),
                                                flex: 1,
                                              )
                                            ],
                                          ),
                                        )),
                                  ),*/
                                  Padding(
                                    padding: EdgeInsets.only(right: 8, left: 8, top: 16),
                                    child: Container(
                                      width: 120,
                                      //color: Colors.grey,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: IntrinsicHeight(
                                          child: Center(
                                            child: IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        decrementCount(product);
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 2),
                                                      // color: Colors.white,
                                                      child: Container(
                                                        decoration: myBoxDecoration2(),
                                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        child: Image.asset(
                                                          'assets/minus.png',
                                                          height: 10,
                                                          width: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 8, right: 8, top: 4, bottom: 4),
                                                    child: Center(
                                                      child: Text(
                                                        product.count.toString(),
                                                        style: TextStyle(
                                                            color: Colors.colorgreen,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        incrementCount(product);
                                                      });
                                                    },
                                                    child: Container(
                                                      //  color: Colors.white,
                                                      padding: EdgeInsets.only(right: 0),
                                                      child: Container(
                                                        decoration: myBoxDecoration2(),
                                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        child: Image.asset(
                                                          'assets/plus.png',
                                                          height: 10,
                                                          width: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: snapshot.data.products.length,
        ));
  }

  Widget noDataView() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            "No product in your whishlist",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void incrementCount(Product product) {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
      _database.update(product);
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.listener.onCartUpdate();
      });
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Available inventory : ${product.inventory}"),
      ));
    }
  }

  void decrementCount(Product product) {
    if (product.count > 1) {
      product.count = product.count - 1;
      _database.update(product);
    } else if (product.count == 1) {
      product.count = product.count - 1;
      _database.remove(product);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.listener.onCartUpdate();
    });
  }
}
