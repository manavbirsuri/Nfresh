import 'package:flutter/material.dart';
import 'package:nfresh/bloc/cart_bloc.dart';
import 'package:nfresh/bloc/related_product_bloc.dart';
import 'package:nfresh/bloc/set_fav_bloc.dart';
import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/models/responses/response_related_products.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';

import 'cart.dart';
import 'login.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({Key key, @required this.product}) : super(key: key);
  @override
  ProState createState() => ProState();
}

class ProState extends State<ProductDetailPage> {
  Text totalText;
  String code;
  var pos = 0;

  int totalAmount = 0;
  var bloc = CartBloc();
  var blocRelated = RelatedProductBloc();
  var _prefs = SharedPrefs();
  var blocFav = SetFavBloc();
  var _database = DatabaseHelper.instance;
  ProfileModel profile;
  int cartCount = 0;

  bool showLoader = true;
  ResponseRelatedProducts productResponse;

  @override
  void initState() {
    super.initState();
    setState(() {});
    getCartTotal();
    getCartCount();
    blocRelated.fetchRelatedProducts(widget.product.id.toString());
    blocRelated.productsList.listen((res) {
      setState(() {
        showLoader = false;
      });
      productResponse = res;
      updateProducts();
      updateMainProduct();
    });
    _prefs.getProfile().then((modelProfile) {
      setState(() {
        profile = modelProfile;
      });
    });
  }

  Future updateMainProduct() async {
    var product = await _database.queryConditionalProduct(widget.product);
    if (product != null) {
      product.selectedDisplayPrice = getCalculatedPrice(product);
      setState(() {
        widget.product.count = product.count;
        widget.product.selectedPacking = product.selectedPacking;
      });
    } else {
      setState(() {
        widget.product.count = 0;
      });
    }
  }

  Future updateProducts() async {
    if (productResponse != null &&
        productResponse.products != null &&
        productResponse.products.length > 0) {
      for (int i = 0; i < productResponse.products.length; i++) {
        var product = await _database.queryConditionalProduct(productResponse.products[i]);
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
            title: Text('Product Detail'),
            centerTitle: true,
          ),
          body: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  AspectRatio(
                                    aspectRatio: 2 / 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 16, right: 16),
                                      child: Image.network(
                                        widget.product.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 0, left: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (profile == null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginPage(),
                                              ),
                                            );
                                          } else {
                                            if (widget.product.fav == "1") {
                                              widget.product.fav = "0";
                                            } else {
                                              widget.product.fav = "1";
                                            }
                                            blocFav.fetchData(
                                                widget.product.fav, widget.product.id.toString());
                                          }
                                        });
                                      },
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Image.asset(
                                          widget.product.fav == "1"
                                              ? 'assets/fav_filled.png'
                                              : 'assets/fav.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 16, right: 16),
                                    child: Text(
                                      widget.product.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.colorgreen,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                    child: Text(
                                      widget.product.nameHindi,
                                      style: TextStyle(fontSize: 16, color: Colors.colorgrey),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '₹${widget.product.selectedPacking.price}  ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.colorlightgrey,
                                                      fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                                widget.product.selectedPacking.displayPrice > 0
                                                    ? Text(
                                                        '₹${widget.product.selectedPacking.displayPrice}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.colororange,
                                                            decoration: TextDecoration.lineThrough),
                                                        textAlign: TextAlign.start,
                                                      )
                                                    : Container(),
                                              ]),
                                          widget.product.selectedPacking.displayPrice > 0
                                              ? Text(
                                                  getOff(widget.product),
                                                  style: TextStyle(
                                                      fontSize: 14, color: Colors.colororange),
                                                  textAlign: TextAlign.center,
                                                )
                                              : Container(),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            // height: 35,
                                            width: 120,
                                            decoration: myBoxDecoration3(),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: DropdownButtonFormField<Packing>(
                                                  decoration: InputDecoration.collapsed(
                                                      hintText: widget
                                                          .product.selectedPacking.unitQtyShow),
                                                  value: null,
                                                  items:
                                                      widget.product.packing.map((Packing value) {
                                                    return new DropdownMenuItem<Packing>(
                                                      value: value,
                                                      child: new Text(
                                                        value.unitQtyShow,
                                                        style: TextStyle(
                                                            color: Colors.grey, fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      widget.product.selectedPacking = newValue;
                                                      widget.product.count = 0;
                                                      widget.product.selectedDisplayPrice =
                                                          getCalculatedPrice(widget.product);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          /* Container(
                                              height: 35,
                                              width: 120,
                                              decoration: myBoxDecoration2(),
                                              child: Center(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(bottom: 16),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            decrementCount(widget.product);
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.minimize,
                                                          color: Colors.colorgreen,
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.product.count.toString(),
                                                      style: TextStyle(
                                                          color: Colors.colorgreen,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            incrementCount(widget.product);
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.colorgreen,
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),*/
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
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.stretch,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: () {
                                                              decrementCount(widget.product);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 15),
                                                              // color: Colors.white,
                                                              child: Container(
                                                                decoration: myBoxDecoration2(),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    12, 0, 12, 0),
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
                                                                left: 8,
                                                                right: 8,
                                                                top: 4,
                                                                bottom: 4),
                                                            child: Center(
                                                              child: Text(
                                                                widget.product.count.toString(),
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
                                                              incrementCount(widget.product);
                                                            },
                                                            child: Container(
                                                              //  color: Colors.white,
                                                              padding: EdgeInsets.only(right: 0),
                                                              child: Container(
                                                                decoration: myBoxDecoration2(),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    12, 0, 12, 0),
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
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "DESCRIPTION",
                                            style: TextStyle(color: Colors.colorgreen),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Text(
                                              widget.product.description,
                                              style: TextStyle(color: Colors.colorgrey),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 16),
                                            child: Text(
                                              "RELATED PRODUCTS",
                                              style: TextStyle(color: Colors.colorgreen),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    height: 335,
                                    // child: showProductsCategories(),
                                    color: Colors.colorlightgreyback,
                                    child: showLoader
                                        ? Center(child: CircularProgressIndicator())
                                        : showProductsCategories(productResponse),
                                    /*  child: StreamBuilder(
                                      stream: blocRelated.productsList,
                                      builder: (context,
                                          AsyncSnapshot<ResponseRelatedProducts> snapshot) {
                                        if (snapshot.hasData) {
                                          return showProductsCategories(snapshot);
                                        } else if (snapshot.hasError) {
                                          return Text(snapshot.error.toString());
                                        }
                                        return Center(child: CircularProgressIndicator());
                                      },
                                    ),*/
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Cart Bottom bar
                  Column(children: <Widget>[
                    Container(
                      color: Colors.colorlightgreyback,
                      height: 50,
                      padding: EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: GestureDetector(
                              child: Container(
                                //color: Colors.amber,
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          '₹$totalAmount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.colorgrey),
                                        ),
                                        Text(
                                          'Total amount',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.colorPink,
                                          ),
                                        )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                margin: EdgeInsets.only(top: 4, bottom: 4),
                                color: Colors.colorgreen,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Checkout',
                                            style: TextStyle(fontSize: 18, color: Colors.white),
                                          ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  updateProducts();
                                  updateMainProduct();
                                });
                              },
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              )),
        )
      ],
    );
  }

  BoxDecoration myBoxDecoration2() {
    return BoxDecoration(
      border: Border.all(color: Colors.colorgreen, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
    );
  }

  BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
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

  showProductsCategories(ResponseRelatedProducts snapshot) {
    var products = snapshot.products;
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            var product = products[position];
            return Material(
              color: Colors.transparent,
              child: product == null
                  ? Text('')
                  : Padding(
                      padding: EdgeInsets.all(4),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 4, left: 0, top: 0),
                                child: Container(
                                  width: 168,
                                  //color: Colors.green,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (profile == null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => LoginPage(),
                                                  ),
                                                );
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
                                          child: Container(
                                            // color: Colors.mygrey,
                                            padding: EdgeInsets.all(8),
                                            child: product != null && product.fav == "1"
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
                                      product.selectedPacking.displayPrice > 0
                                          ? Text(
                                              getOff(product),
                                              style: TextStyle(
                                                fontSize: 14,
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(
                                              product: product,
                                            ),
                                      )).then((value) {
                                    getCartTotal();
                                    getCartCount();
                                    updateProducts();
                                    updateMainProduct();
                                  });
                                },
                                child: Column(
                                  children: <Widget>[
                                    Image.network(
                                      product != null ? product.image : "",
                                      fit: BoxFit.cover,
                                      height: 80,
                                    ),
                                    Text(
                                      products[position].name,
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
                                        products[position].nameHindi,
                                        style:
                                            TextStyle(fontSize: 16, color: Colors.colorlightgrey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "₹" + product.selectedPacking.price.toString() + "  ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.colorlightgrey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            product.selectedPacking.displayPrice > 0
                                                ? Text(
                                                    "₹" +
                                                        product.selectedPacking.displayPrice
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.colororange,
                                                        decoration: TextDecoration.lineThrough),
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
                                      width: 120,
                                      decoration: myBoxDecoration3(),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 8, left: 8),
                                          child: DropdownButtonFormField<Packing>(
                                            decoration: InputDecoration.collapsed(
                                                hintText: product.selectedPacking.unitQtyShow),
                                            // value: product.selectedPacking,
                                            value: null,
                                            items: product.packing //getQtyList(products[position])
                                                .map((Packing value) {
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
                                                products[position].selectedPacking = newValue;
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
                                                  decrementCount(products[position]);
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
                                                  incrementCount(products[position]);
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
                              /* Padding(
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
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    decrementCount(products[position]);
                                                  });
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
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
                                                        fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    incrementCount(products[position]);
                                                  });
                                                },
                                                child: Container(
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
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
                              ),*/
                            ],
//                  ),
                          ),
                        ),
                      ),
                    ),
            );
          },
          itemCount: products.length,
        ));
  }

  Future incrementCount(Product product) async {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
      await _database.update(product);

      _database.getCartCount().then((count) {
        setState(() {
          cartCount = count;
        });
      });
      getCartCount();
      getCartTotal();
      // Future.delayed(const Duration(milliseconds: 500), () async {});
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Available inventory : ${product.inventory}"),
      ));
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
}
