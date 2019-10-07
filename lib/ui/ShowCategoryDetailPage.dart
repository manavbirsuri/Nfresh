import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:nfresh/bloc/cat_products_bloc.dart';
import 'package:nfresh/bloc/set_fav_bloc.dart';
import 'package:nfresh/bloc/tag_products_bloc.dart';
import 'package:nfresh/models/category_model.dart';
import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/models/responses/response_cat_products.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/ProductDetailPage.dart';
import 'package:nfresh/ui/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../utils.dart';
import 'SearchPageActivity.dart';
import 'login.dart';
import 'notifications.dart';

class ShowCategoryDetailPage extends StatefulWidget {
  final Category subCategory;
  ShowCategoryDetailPage({Key key, @required this.subCategory})
      : super(key: key);

  @override
  _ShowCategoryDetailPageState createState() => _ShowCategoryDetailPageState();
}

class _ShowCategoryDetailPageState extends State<ShowCategoryDetailPage> {
  var bloc = CatProductsBloc();
  var blocTag = TagProductsBloc();
  var viewList = false;
  var viewGrid = true;
  var network = false;
  var gridImage = 'assets/selected_grid.png';
  var listImage = 'assets/unselected_list.png';
  List<String> selectedValues = List();
  ProfileModel profile;
  var _prefs = SharedPrefs();
  var pos = 0;
  String SelectedLanguage = "A to Z";
  String _picked = "A to Z";
  var blocFav = SetFavBloc();
  var _database = DatabaseHelper.instance;
  int totalAmount = 0;
  //var blocCart = CartBloc();

  int cartCount = 0;

  bool showLoader = true;

  ResponseCatProducts productResponse;

  @override
  void initState() {
    super.initState();
    getCartCount();
    getCartTotal();
    Utils.checkInternet().then((connected) {
      if (connected != null && connected) {
        if (widget.subCategory.icon == "ii") {
          // get product based on tag
          blocTag.fetchData(widget.subCategory.id.toString());
        } else {
          bloc.fetchData(widget.subCategory.id.toString());
        }
      } else {
        setState(() {
          network = true;
        });
        Toast.show("Not connected to internet", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });

    bloc.catProductsList.listen((res) {
      setState(() {
        showLoader = false;
      });
      productResponse = res;
      updateProducts();
    });
    blocTag.catProductsList.listen((res) {
      setState(() {
        showLoader = false;
      });
      productResponse = res;
      updateProducts();
    });

    getProfileDetail();
  }

  getProfileDetail() {
    _prefs.getProfile().then((modelProfile) {
      setState(() {
        profile = modelProfile;
      });
    });
  }

  Future updateProducts() async {
    if (productResponse != null &&
        productResponse.products != null &&
        productResponse.products.length > 0) {
      for (int i = 0; i < productResponse.products.length; i++) {
        var product = await _database
            .queryConditionalProduct(productResponse.products[i]);
        if (product != null) {
          product.selectedDisplayPrice = getCalculatedPrice(product);
          setState(() {
            productResponse.products[i] = product;
          });
        } else {
          setState(() {
            productResponse.products[i].count = 0;
          });
        }
      }
    }
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
              // automaticallyImplyLeading: true,
              title: Text(
                widget.subCategory.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/noti.png",
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        )).then((value) {
                      getCartCount();
                      getCartTotal();
                      updateProducts();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 16, 16, 0),
                    child: Stack(
                      children: <Widget>[
                        new Image.asset(
                          "assets/cart.png",
                          height: 25,
                          width: 25,
                        ),
                        new Positioned(
                          right: 0,
                          child: cartCount > 0
                              ? Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: new Text(
                                    cartCount.toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Text(""),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0, left: 20),
                child: FloatingActionButton(
                  child: Icon(Icons.search),
                  backgroundColor: Colors.colorgreen,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPageActivity(),
                        ));
                  },
                ),
              ),
            ),
            body: showLoader
                ? Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: !network
                              ? CircularProgressIndicator()
                              : Center(
                                  child: Text(
                                    "Connection error!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                : mainContent(productResponse)
//    !network
//    ? Center(child: CircularProgressIndicator())
//        : Center(
//    child: Text(
//    "No Data",
//    style: TextStyle(color: Colors.white, fontSize: 18),
//    ),
//    );
            /* body: StreamBuilder(
            stream: bloc.catProductsList,
            builder: (context, AsyncSnapshot<ResponseCatProducts> snapshot) {
              if (snapshot.hasData) {
                return mainContent(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          ),*/
            ),
      ],
    );
  }

  showListView(List<Product> products) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          var product = products[position];
          return Padding(
            padding: EdgeInsets.only(top: 0),
            child: GestureDetector(
              onTap: () {
//              Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (context) => ProductDetailPage()));
              },
              child: getListItem(position, product),
            ),
          );
        },
        itemCount: products.length,
      ),
    );
  }

  /* Widget getListItem(position, Product product) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            //color: Colors.white,
            padding: EdgeInsets.all(14.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => ProductDetailPage(
                                                    product: product,
                                                  )));
                                    },
                                    child: Center(
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (product.fav == "1") {
                                            product.fav = "0";
                                          } else {
                                            product.fav = "1";
                                          }
                                          blocFav.fetchData(product.fav, product.id.toString());
                                        });
                                      },
                                      child: product.fav == "1"
                                          ? Image.asset(
                                              'assets/fav_filled.png',
                                              width: 20.0,
                                              height: 20.0,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/fav.png',
                                              width: 20.0,
                                              height: 20.0,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => ProductDetailPage(
                                                product: product,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.colorgreen),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 0,
                                            bottom: 0,
                                          ),
                                          child: Text(
                                            product.nameHindi,
                                            style: TextStyle(
                                                fontSize: 16, color: Colors.colorlightgrey),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '₹${product.selectedPacking.price}  ',
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
                                          width: 100,
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
                                                    product.count = 0;
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
                        ],
                      ),
                    ),
                    flex: 3,
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                              size: 30.0,
                            ),

//                            Image.asset(
//                              'assets/delete.png',
//                              height: 20,
//                              width: 20,
//                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 0, left: 0),
                            child: Container(
                              height: 30,
                              decoration: myBoxDecoration2(),
                              child: Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: IntrinsicHeight(
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          // color: Colors.grey,
                                          child: GestureDetector(
                                            onTap: () {
                                              decrementCount(product);
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 16),
                                                child: Icon(
                                                  Icons.minimize,
                                                  color: Colors.colorgreen,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            product.count.toString(),
                                            style: TextStyle(
                                                color: Colors.colorgreen,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.grey,
                                          child: GestureDetector(
                                            onTap: () {
                                              incrementCount(product);
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.colorgreen,
                                              size: 20,
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
                        ],
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black38,
          )
        ]);
  }*/
  Widget getListItem(position, Product product) {
    return Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisSize: MainAxisSize.min,
//        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: IntrinsicHeight(
                      child: Row(
//                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      goToProductDetail(product);
                                    },
                                    child: Center(
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.grey,
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (profile == null) {
                                              showAlertMessage(context);
                                            } else {
                                              if (product.fav == "1") {
                                                product.fav = "0";
                                              } else {
                                                product.fav = "1";
                                              }
                                              blocFav.fetchData(product.fav,
                                                  product.id.toString());
                                            }
                                          });
                                        },
                                        child: Container(
                                          //  color: Colors.grey,
                                          padding: EdgeInsets.only(
                                              right: 15, bottom: 15),
                                          child: product.fav == "1"
                                              ? Image.asset(
                                                  'assets/fav_filled.png',
                                                  width: 20.0,
                                                  height: 20.0,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/fav.png',
                                                  width: 20.0,
                                                  height: 20.0,
                                                  fit: BoxFit.cover,
                                                ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            flex: 3,
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: GestureDetector(
                                onTap: () {
                                  goToProductDetail(product);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.colorgreen),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              goToProductDetail(product);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  right: 0, left: 0, top: 0),
                                              child: Icon(
                                                Icons.chevron_right,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 0,
                                        bottom: 0,
                                      ),
                                      child: Text(
                                        product.nameHindi,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.colorlightgrey),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '₹ ${product.selectedPacking.price}  ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors
                                                            .colorlightgrey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  product.selectedPacking
                                                              .displayPrice >
                                                          0
                                                      ? Text(
                                                          '₹${product.selectedPacking.displayPrice}',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .colororange,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                          textAlign:
                                                              TextAlign.start,
                                                        )
                                                      : Container(),
                                                ]),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 8, left: 0, top: 0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: product.selectedPacking
                                                          .displayPrice >
                                                      0
                                                  ? Text(
                                                      getOff(product),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.colororange,
                                                      ),
                                                      textAlign: TextAlign.end,
                                                    )
                                                  : Container(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 4, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 32,
                                                  width: 125,
                                                  decoration:
                                                      myBoxDecoration3(),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 6, left: 6),
                                                      child:
                                                          DropdownButtonFormField<
                                                              Packing>(
                                                        decoration: InputDecoration
                                                            .collapsed(
                                                                hintText: product
                                                                    .selectedPacking
                                                                    .unitQtyShow),
                                                        value: null,
                                                        items: product.packing
                                                            .map((Packing
                                                                value) {
                                                          return new DropdownMenuItem<
                                                              Packing>(
                                                            value: value,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                new Text(
                                                                  value
                                                                      .unitQtyShow,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                new Text(
                                                                  "₹" +
                                                                      value
                                                                          .price
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            product.selectedPacking =
                                                                newValue;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 0, left: 0, top: 4),
                                            child: Container(
                                              // width: 120,
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 4, 0),
                                                child: IntrinsicHeight(
                                                  // child: Center(
                                                  child: IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            decrementCount(
                                                                product);
                                                          },
                                                          child: Container(
                                                            // padding: EdgeInsets.only(left: 20),
                                                            // color: Colors.white,
                                                            child: Container(
                                                              decoration:
                                                                  myBoxDecoration2(),
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/minus.png',
                                                                height: 10,
                                                                width: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Center(
                                                            child: Text(
                                                              product.count
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .colorgreen,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            incrementCount(
                                                                product);
                                                          },
                                                          child: Container(
                                                            //  color: Colors.white,
                                                            // padding: EdgeInsets.only(right: 20),
                                                            child: Container(
                                                              decoration:
                                                                  myBoxDecoration2(),
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                              child:
                                                                  Image.asset(
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
                                                  //  ),
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
                            flex: 7,
                          ),
                        ],
                      ),
                    ),
                  ),
//                  Flexible(
//                    child: Container(
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: <Widget>[
//                          Column(
//                            mainAxisAlignment: MainAxisAlignment.end,
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: <Widget>[
//                              Container(
//                                padding:
//                                    EdgeInsets.only(right: 8, left: 0, top: 16),
//                                child: Align(
//                                  alignment: Alignment.centerRight,
//                                  child:
//                                      product.selectedPacking.displayPrice > 0
//                                          ? Text(
//                                              getOff(product),
//                                              style: TextStyle(
//                                                fontSize: 12,
//                                                color: Colors.colororange,
//                                              ),
//                                              textAlign: TextAlign.end,
//                                            )
//                                          : Container(),
//                                ),
//                              ),
//
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                    flex: 1,
//                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          )
        ]);
  }

  showGridView(List<Product> products) {
//    var size = MediaQuery.of(context).size;
//    double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//    itemHeight = itemHeight;
//    double itemWidth = size.width / 2;
//    itemWidth = itemWidth;

    return Expanded(
        child: Container(
      padding: EdgeInsets.all(4),
      color: Colors.colorlightgreyback,
      child: SingleChildScrollView(
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) => new Container(
            child: girdViewItem(index, context, products),
          ),
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
        ),
      ),

//        GridView.count(
//          crossAxisCount: 2,
//          children: new List<Widget>.generate(products.length, (index) {
//            return new Expanded(
//              child: Container(
//                child: girdViewItem(index, context, products),
//              ),
//            );
//          }),
//        ),
//      ),

      /*  child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this would produce 2 rows.
        //childAspectRatio: (itemWidth / itemHeight),
        childAspectRatio: MediaQuery.of(context).size.width <= 360 ? 1 / 1.70 : 1 / 1.55,
        crossAxisCount: 2,
        shrinkWrap: true,
        // Generate 100 Widgets that display their index in the List
        children: List.generate(products.length, (index) {
          var product = products[index];
          return Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Container(
                  //height: 330,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                        child: Container(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (product.fav == "1") {
                                      product.fav = "0";
                                    } else {
                                      product.fav = "1";
                                    }
                                    blocFav.fetchData(product.fav, product.id.toString());
                                  });
                                },
                                child: product.fav == "1"
                                    ? Image.asset(
                                        'assets/fav_filled.png',
                                        width: 20.0,
                                        height: 20.0,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/fav.png',
                                        width: 20.0,
                                        height: 20.0,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Text(
                                product.off,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.colororange,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          goToProductDetail(product);
                        },
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              product.image,
                              fit: BoxFit.contain,
                              height: 80,
                            ),
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.colorgreen,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Text(
                                product.nameHindi,
                                style: TextStyle(fontSize: 16, color: Colors.colorlightgrey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '₹${product.selectedPacking.price}  ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.colorlightgrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '₹${product.displayPrice}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.colororange,
                                          decoration: TextDecoration.lineThrough),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 35,
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
                      */ /* Padding(
                        padding: EdgeInsets.only(right: 16, left: 16, top: 16),
                        child: Container(
                          width: 120,
                          decoration: myBoxDecoration2(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IntrinsicHeight(
                              child: Center(
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            decrementCount(product);
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                              child: Image.asset(
                                                'assets/minus.png',
                                                height: 15,
                                                width: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            product.count.toString(),
                                            style: TextStyle(
                                                color: Colors.colorgreen,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
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
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                            child: Image.asset(
                                              'assets/plus.png',
                                              height: 15,
                                              width: 15,
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
                      ),*/ /*
                      Padding(
                        padding: EdgeInsets.only(right: 8, left: 8, top: 16),
                        child: Container(
                          width: 150,
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
                                            decrementCount(products[index]);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          // color: Colors.white,
                                          child: Container(
                                            decoration: myBoxDecoration2(),
                                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                            child: Image.asset(
                                              'assets/minus.png',
                                              height: 12,
                                              width: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
                                            incrementCount(products[index]);
                                          });
                                        },
                                        child: Container(
                                          //  color: Colors.white,
                                          padding: EdgeInsets.only(right: 20),
                                          child: Container(
                                            decoration: myBoxDecoration2(),
                                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                            child: Image.asset(
                                              'assets/plus.png',
                                              height: 12,
                                              width: 12,
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
//                  ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),*/
    ));
  }

  Future incrementCount(Product product) async {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
      await _database.update(product);
      getCartCount();
      getCartTotal();
      // Future.delayed(const Duration(milliseconds: 500), () async {});
    } else {
      Toast.show(
          "Current available quantity is " + product.inventory.toString(),
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    }
  }

  Future decrementCount(Product product) async {
    if (product.count > 1) {
      product.count = product.count - 1;
      await _database.update(product);
    } else if (product.count == 1) {
      product.count = product.count - 1;
      _database.remove(product);
    }
    getCartCount();
    getCartTotal();
    // Future.delayed(const Duration(milliseconds: 500), () async {});
  }

  getCartCount() {
    _database.getCartCount().then((count) {
      setState(() {
        cartCount = count;
      });
    });
  }

  getCartTotal() {
    _database.queryAllProducts().then((products) {
      var amount = 0;
      for (int i = 0; i < products.length; i++) {
        var product = products[i];
        amount += (product.selectedPacking.price * product.count);
      }
      setState(() {
        totalAmount = amount;
      });
    });
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        right: BorderSide(width: 0.5, color: Colors.colorlightgrey),
        bottom: BorderSide(width: 1.0, color: Colors.colorlightgrey),
        left: BorderSide(width: 0.5, color: Colors.colorlightgrey),
      ),
    );
  }

  BoxDecoration myBoxDecoration2() {
    return BoxDecoration(
      border: Border.all(color: Colors.colorgreen, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  getPos(int position) {
    //if(position==0){
    return selectedValues[pos];
    // }
  }

  // calculate the offer percentage
  String getOff(Product product) {
    var salePrice = product.selectedPacking.price;
    var costPrice = product.selectedPacking.displayPrice;
    var profit = costPrice - salePrice;
    var offer = (profit / costPrice) * 100;
    return "${offer.round()}% off";
  }

  double getCalculatedPrice(Product product) {
    return (product.selectedPacking.displayPrice).toDouble();
  }

  Widget mainContent(ResponseCatProducts snapshot) {
    // print("Products: ${snapshot.data.products.length}");
    return snapshot.products.length > 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            viewGrid = true;
                            viewList = false;
                            gridImage = "assets/selected_grid.png";
                            listImage = "assets/unselected_list.png";
                          });
                        },
                        child: Container(
                          child: Image.asset(
                            gridImage,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.colorgrey,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            viewGrid = false;
                            viewList = true;
                            gridImage = "assets/unselected_grid.png";
                            listImage = "assets/selected_list.png";
                          });
                        },
                        child: Container(
                          child: Image.asset(listImage, height: 20, width: 20),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.colorgrey,
                      ),
                      GestureDetector(
                          onTap: () {
                            return showDialog(
                                context: context,
                                builder: (_) {
                                  return refresh();
                                }).then((_) => setState(() {
                                  _read().then((result) {
                                    print(result);
                                    setState(() {
                                      SelectedLanguage = result;
                                      _picked = SelectedLanguage;
                                      if (SelectedLanguage == "A to Z") {
                                        snapshot.products.sort(
                                            (a, b) => a.name.compareTo(b.name));
                                        print(snapshot.products);
                                      } else {
                                        snapshot.products.sort(
                                            (a, b) => a.name.compareTo(b.name));
                                        snapshot.products =
                                            snapshot.products.reversed.toList();
                                        print(snapshot.products);
                                      }
                                    });
                                  });
                                }));
                          },
                          child: Container(
                              child: Image.asset(
                            'assets/sort.png',
                            height: 20,
                            width: 20,
                            color: Colors.grey,
                          ))),
                    ],
                  ),
                ),
              ),
              viewList
                  ? Expanded(
                      child: showListView(snapshot.products),
                    )
                  : Container(),
              viewGrid ? showGridView(snapshot.products) : Container(),
              totalAmount > 0
                  ? Column(children: <Widget>[
                      Container(
                        color: Colors.colorlightgreybackt,
                        height: 55,
                        // padding: EdgeInsets.all(0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: GestureDetector(
                                child: Container(
                                  //color: Colors.amber,
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              '₹$totalAmount',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 21,
                                                color: Colors.colorgrey,
                                              ),
                                            ),
                                            Text(
                                              'Total amount',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.colorPink,
                                              ),
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                ),
                                onTap: () {
//                      Scaffold.of(context).showSnackBar(SnackBar(
//                        content: Text('View details Coming soon'),
//                        duration: Duration(seconds: 1),
//                      ));
                                },
                              ),
                              flex: 1,
                            ),
                            Flexible(
                              child: GestureDetector(
                                child: Container(
                                  // margin: EdgeInsets.only(top: 0, bottom: 0),
                                  color: Colors.colorgreen,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Checkout',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartPage(),
                                    ),
                                  ).then((value) {
                                    getCartTotal();
                                    getCartCount();
                                  });
                                },
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ])
                  : Container(),
            ],
          )
        : noDataView();
  }

  void goToProductDetail(Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
            product: product,
          ),
        )).then((onVal) {
      getCartCount();
      getCartTotal();
      updateProducts();
    });
  }

  void showAlertMessage(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(
              "You would need to login in order to proceed. Please click here to Login."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Login"),
              onPressed: () {
                Navigator.of(context).pop();
                goToLogin();
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
  }

  void goToLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            from: 1,
          ),
        )).then((value) {
      getProfileDetail();
    });
  }

  Widget noDataView() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text("No product available")],
          )
        ],
      ),
    );
  }

  girdViewItem(int index, BuildContext context, List<Product> products) {
    var product = products[index];
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Container(
            height: 310,
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                  child: Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (profile == null) {
                                showAlertMessage(context);
                              } else {
                                if (product.fav == "1") {
                                  product.fav = "0";
                                } else {
                                  product.fav = "1";
                                }
                                blocFav.fetchData(
                                    product.fav, product.id.toString());
                              }
                            });
                          },
                          child: product.fav == "1"
                              ? Image.asset(
                                  'assets/fav_filled.png',
                                  width: 20.0,
                                  height: 20.0,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/fav.png',
                                  width: 20.0,
                                  height: 20.0,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        product.selectedPacking.displayPrice > 0
                            ? Text(
                                getOff(product),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.colororange,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    goToProductDetail(product);
                  },
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        height: 80,
                      ),
                      Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.colorgreen,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          product.nameHindi,
                          style: TextStyle(
                              fontSize: 16, color: Colors.colorlightgrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '₹${product.selectedPacking.price}  ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.colorlightgrey,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              product.selectedPacking.displayPrice > 0
                                  ? Text(
                                      '₹${product.selectedPacking.displayPrice}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.colororange,
                                          decoration:
                                              TextDecoration.lineThrough),
                                      textAlign: TextAlign.center,
                                    )
                                  : Container(),
                            ]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 132,
                        decoration: myBoxDecoration3(),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 6, left: 6),
                            child: DropdownButtonFormField<Packing>(
                              decoration: InputDecoration.collapsed(
                                  hintText:
                                      product.selectedPacking.unitQtyShow),
                              value: null,
                              //value: product.selectedPacking,
                              items: product.packing.map((Packing value) {
                                return new DropdownMenuItem<Packing>(
                                  value: value,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Text(
                                        value.unitQtyShow,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      new Text(
                                        "₹" + value.price.toString(),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  product.selectedPacking = newValue;
                                  product.count = 0;
                                  product.selectedDisplayPrice =
                                      getCalculatedPrice(product);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8, left: 8, top: 16),
                  child: Container(
                    width: 150,
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
                                    decrementCount(products[index]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 18),
                                    // color: Colors.white,
                                    child: Container(
                                      decoration: myBoxDecoration2(),
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Image.asset(
                                        'assets/minus.png',
                                        height: 12,
                                        width: 12,
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
                                    incrementCount(products[index]);
                                  },
                                  child: Container(
                                    //  color: Colors.white,
                                    padding: EdgeInsets.only(right: 18),
                                    child: Container(
                                      decoration: myBoxDecoration2(),
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Image.asset(
                                        'assets/plus.png',
                                        height: 12,
                                        width: 12,
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
//                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget refresh() {
    return showCustomDialog(SelectedLanguage);
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'sort';
    final value = prefs.getString(key) ?? "A to Z";
    print('read: $value');
    return value;
  }
}

class showCustomDialog extends StatefulWidget {
  var SelectedLanguage = "A to Z";

  showCustomDialog(String selectedLanguage) {
    this.SelectedLanguage = selectedLanguage;
  }

  @override
  _MyDialogState createState() => new _MyDialogState(SelectedLanguage);
}

class _MyDialogState extends State<showCustomDialog> {
  Color _c = Colors.redAccent;
  var SelectedLanguage = "A to Z";
  String _picked1 = "A to Z";

  _MyDialogState(String selectedLanguage) {
    this.SelectedLanguage = selectedLanguage;
  }

  @override
  void initState() {
    super.initState();

    // ignore: unnecessary_statements
    _read().then((result) {
      print(result);
      setState(() {
        SelectedLanguage = result;
        _picked1 = SelectedLanguage;
      });
    });
    build(context);
  }

  @override
  Widget build(BuildContext context) {
    var GroupedButtonsOrientation;
    return AlertDialog(
      title: new Text("Sort By"),
      content: new Container(
        width: 260.0,
        height: 160.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            new Expanded(
              child: new Column(
                children: <Widget>[
                  Center(
                      child: RadioButtonGroup(
                    onSelected: (String selected) => setState(() {
                      _picked1 = selected.trim();
                    }),
                    margin: EdgeInsets.only(left: 14),
                    //orientation: GroupedButtonsOrientation.VERTICAL,
                    labels: <String>["A to Z", "Z to A"],
                    picked: _picked1,
                  ))
                ],
              ),
            ),

            new Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      setState(() {
                        SelectedLanguage = _picked1;
                        _save(SelectedLanguage);
                      });

//                      Navigator.pushReplacement(
//                          context, MaterialPageRoute(builder: (BuildContext context) => MyHome()));
                      Navigator.pop(context);
//                      Navigator.push(
//                        context,
//                        new MaterialPageRoute(builder: (context) => new MyHome()),
//                      );
//                      SystemNavigator.pop();

                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                    child: Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: new Container(
                          decoration: new BoxDecoration(
                              color: Colors.mygreen,
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(40.0),
                                  bottomLeft: const Radius.circular(40.0),
                                  bottomRight: const Radius.circular(40.0),
                                  topRight: const Radius.circular(40.0))),
                          child: new Center(
                            child: new Text("Done",
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'helvetica_bold')),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            //),
          ],
        ),
      ),
//                          actions: <Widget>[
//                            new FlatButton(
//                              onPressed: () => Navigator.of(context).pop(false),
//                              child: new Text('No'),
//                            ),
//                            new FlatButton(
//                              onPressed: () => Navigator.of(context).pop(true),
//                              child: new Text('Yes'),
//                            ),
//                          ],
    );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'sort';
    final value = prefs.getString(key) ?? "A to Z";
    print('read: $value');
    return value;
  }

  _save(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'sort';
    prefs.setString(key, value);
    print('saved $value');
  }
}
