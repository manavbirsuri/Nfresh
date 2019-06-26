import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/cart_bloc.dart';
import 'package:nfresh/bloc/check_inventory_bloc.dart';
import 'package:nfresh/bloc/checksum_bloc.dart';
import 'package:nfresh/bloc/cities_bloc.dart';
import 'package:nfresh/bloc/update_address_bloc.dart';
import 'package:nfresh/models/area_model.dart';
import 'package:nfresh/models/city_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/PromoCodePage.dart';
import 'package:nfresh/ui/payment_success.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'WalletPage.dart';
import 'login.dart';

class CartPage extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<CartPage> {
  var _database = DatabaseHelper.instance;
  static const platform = const MethodChannel('flutter.native/helper');
  String response = "";
  Text totalText;
  String code;
  var pos = 0;
  String check = "";
  int walletBalance = 0;
  String appliedValue = "Apply promo code";
  var bloc = CartBloc();
  int totalAmount = 0;
  int checkoutTotal = 0;
  num discount = 0;
  int walletDiscount = 0;
  ProfileModel profile;
  var blocInventory = CheckInventoryBloc();
  List<Map<String, dynamic>> lineItems = [];

  List<CityModel> cities = [];
  List<AreaModel> areas = [];
  List<AreaModel> cityAreas = [];
  CityModel selectedCity;
  AreaModel selectedArea;

  var blocCity = CityBloc();

  Map<String, dynamic> mapPayTm = {
    'MID': "apXePW28170154069075",
    'ORDER_ID': "NF${new DateTime.now().millisecondsSinceEpoch}",
    'CUST_ID': "cust123",
    'MOBILE_NO': "7777777777",
    'EMAIL': "username@emailprovider.com",
    'CHANNEL_ID': "WAP",
    'TXN_AMOUNT': "100",
    'WEBSITE': "WEBSTAGING",
    'INDUSTRY_TYPE_ID': "Retail",
    'CALLBACK_URL': ""
  };
  var blocCheck = ChecksumBloc();
  var blocAddress = UpdateAddressBloc();
  var prefs = SharedPrefs();
  String checksum = "";
  String orderId = "";
  List<Product> mProducts = [];
  bool isLoadingCart = true;
  var address = "Akshya nagar 1st block, 1st Cross, Rammurty nagar, Banglore-560016";

  var addressController = TextEditingController();

  ProgressDialog dialog;
  @override
  void initState() {
    super.initState();
    checkIfPromoSaved();
//      checkIfPromoSaved().then((value) {
//        setState(() {
//          check = value;
//        });
//      });
    getProfileDetail();
    bloc.fetchData();
    bloc.catProductsList.listen((list) {
      setState(() {
        isLoadingCart = false;
        mProducts = list;
      });
    });
    //blocInventory.fetchData(map);
    blocCity.fetchData();
    blocCity.cities.listen((res) {
      setState(() {
        this.cities = res.cities;
        for (int i = 0; i < cities.length; i++) {
          var city = cities[i];
          if (profile.city == city.id) {
            selectedCity = city;
          }
        }

        this.areas = res.areas;
        for (int i = 0; i < areas.length; i++) {
          var area = areas[i];
          if (profile.area == area.id) {
            selectedArea = area;
          }
        }

        getCityAreas(selectedCity);
      });
    });
  }

  void getCityAreas(CityModel selectedCity) {
    cityAreas = [];
    for (int i = 0; i < areas.length; i++) {
      var modelArea = areas[i];
      if (modelArea.cityId == selectedCity.id) {
        cityAreas.add(modelArea);
      }
    }
    if (cityAreas.length > 0) {
      selectedArea = cityAreas[0];
    } else {
      selectedArea = null;
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
              title: Text(
                'Cart',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        child: isLoadingCart
                            ? Center(child: CircularProgressIndicator())
                            : productContent(mProducts),
                        /*child: StreamBuilder(
                          stream: bloc.catProductsList,
                          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data.length > 0
                                  ? productContent(snapshot)
                                  : noDataView();
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),*/
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Cart Bottom bar
                  Column(children: <Widget>[
                    Container(
                      height: 65,
                      color: Colors.colorlightgreyback,
                      padding: EdgeInsets.all(4),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: GestureDetector(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    // Flexible(
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          '₹$checkoutTotal',
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                        ),
                                        Text(
                                          'Total amount',
                                          style: TextStyle(
                                            //  fontSize: 14,
                                            color: Colors.colorPink,
                                          ),
                                        )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    ),
                                    //flex: 1,
                                    // ),
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
                                color: Colors.colorgreen,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Place Order',
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
                              onTap: () async {
                                if (profile != null) {
                                  getCheckSum(context);
                                } else {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(builder: (context) => new LoginPage()),
                                  );
                                }
//                                try {
//
//                                  final String result = await platform
//                                      .invokeMethod('$checksum::${jsonEncode(mapPayTm)}');
//                                  response = result;
//                                } on PlatformException catch (e) {
//                                  response = "Failed to Invoke: '${e.message}'.";
//                                }
//
//                                print("RES: $response");
//                                handlePayTmResponse(response, context);
                              },
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ))
      ],
    );
  }

  Widget getListItem(position, List<Product> products) {
    var product = products[position];
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(8),
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
                                    width: 115,
                                    decoration: myBoxDecoration3(),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 8, left: 8),
                                        child: Text(
                                          product.selectedPacking.unitQtyShow,
                                          style: TextStyle(color: Colors.grey),
                                        ),
//                                        child: DropdownButtonFormField<Packing>(
//                                          decoration: InputDecoration.collapsed(
//                                              hintText: product.selectedPacking.unitQtyShow),
//                                          value: null,
//                                          //product.selectedPacking,
//                                          //value: null,
//                                          items: product.packing //getQtyList(products[position])
//                                              .map((Packing value) {
//                                            return new DropdownMenuItem<Packing>(
//                                              value: value,
//                                              child: new Text(
//                                                value.unitQtyShow,
//                                                style: TextStyle(color: Colors.grey),
//                                              ),
//                                            );
//                                          }).toList(),
//                                          onChanged: (newValue) {
//                                            setState(() {
//                                              product.selectedPacking = newValue;
//                                              product.count = 1;
//                                              // product.selectedPrice =
//                                            });
//                                          },
//                                        ),
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _database.remove(product);
                                  products.removeAt(position);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 8, left: 16, bottom: 16),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(
                                    'assets/delete.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ),
                            /*Padding(
                              padding: EdgeInsets.only(right: 12, left: 12, top: 16),
                              child: Container(
                                width: 115,
                                height: 30,
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
                                                  decrementCount(product, products);
                                                  calculateTotal(products);
                                                });
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(10, 8, 15, 8),
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
                                                  incrementCount(product);
                                                  calculateTotal(products);
                                                });
                                              },
                                              child: Container(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(15, 8, 10, 8),
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
                            Padding(
                              padding: EdgeInsets.only(right: 8, left: 8, top: 16),
                              child: Container(
                                width: 118,
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
                                                  decrementCount(product, products);
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
                                                  incrementCount(products[position]);
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
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 0),
            child: Divider(
              height: 1,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  //Middle Portion of cart below products list
  Widget getCartDetailView(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              'COUPONS',
              style: TextStyle(fontSize: 16, color: Colors.colorgreen),
            ),
            subtitle: GestureDetector(
              onTap: () {
                setState(() {
                  if (check.isEmpty) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new PromoCodePage(
                                total: totalAmount,
                              )),
                    ).then((value) {
                      checkIfPromoSaved();
//                        checkIfPromoSaved().then((value) {
//                          check = value;
//                          // discount = 20;
//                        });
                    });
                  } else {
                    removePromoFromPrefs();
                  }
                });
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      appliedValue,
                      style: TextStyle(fontSize: 18),
                    ),

                    check.isEmpty
                        ? Icon(
                            Icons.navigate_next,
                            color: Colors.black38,
                            size: 30.0,
                          )
                        : Image.asset(
                            "assets/delete.png",
                            height: 20,
                            width: 20,
                          ),
//                    !check.isEmpty
//                        ? Image.asset(
//                            "assets/delete.png",
//                            height: 20,
//                            width: 20,
//                          )
//                        : Container(),

//                Image.asset(
//                  "assets/delete.png",
//                  height: 20,
//                  width: 20,
//                )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (walletBalance > 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            type: MaterialType.transparency,
                            child: Container(
                              child: DynamicDialog(profile),
                              padding: EdgeInsets.only(top: 40, bottom: 40),
                            ),
                          );
                        }).then((value) {
                      setState(() {
                        //  walletDiscount = value;
                        getBalance().then((onValue) {
                          print("LLLLLLLLLLLL: " + onValue);
//                        walletDiscount = onValue as int;
                        });
                      });

                      setState(() {
                        walletDiscount = int.parse(value);
                      });
                    });
                  } else {
//                    Toast.show("Insufficiant Balance in Wallet.", context,
//                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletPage(),
                        )).then((value) {
                      getProfileDetail();
                    });
                  }
                });
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Wallet Balance',
                      style: TextStyle(fontSize: 18, color: Colors.colorlightgrey),
                    ),
                    Text(
                      walletBalance > 0 ? walletBalance.toString() : "Add",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.colorgreen,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
//          GestureDetector(
//            onTap: () {
//              setState(() {
//                code = showDialog(
//                  context: context,
//                  builder: (_) => LogoutOverlay(),
//                ) as String;
//              });
//            },
//            child: ListTile(
//              title: Text('Apply Promo Code'),
//              trailing: Icon(Icons.navigate_next),
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.only(
//              bottom: 16,
//            ),
//            child: Divider(
//              color: Colors.grey,
//              height: 1,
//            ),
//          ),
          Padding(
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: ListTile(
              //contentPadding: EdgeInsets.only(top: 0),
              title: Text(
                'PRICE DETAILS',
                style: TextStyle(fontSize: 16, color: Colors.colorgreen),
              ),
              subtitle: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Item Total',
                          style: TextStyle(fontSize: 18, color: Colors.colorlightgrey),
                        ),
                        Text(
                          '₹$totalAmount',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  !check.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Coupon Discount',
                                style: TextStyle(fontSize: 18, color: Colors.colorlightgrey),
                              ),
                              Text(
                                '-₹$discount',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  walletDiscount != 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Wallet Discount',
                                style: TextStyle(fontSize: 18, color: Colors.colorlightgrey),
                              ),
                              Text(
                                '-₹$walletDiscount',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹$checkoutTotal',
                          style: TextStyle(
                              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  /*Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Material(
                                  type: MaterialType.transparency,
                                  child: Container(
                                    child: DynamicDialog(),
                                    padding:
                                        EdgeInsets.only(top: 40, bottom: 40),
                                  ),
                                );
                              }).then((value) {
                            setState(() {
                              getBalance().then((onValue) {
                                walletBalance = onValue;
                              });
                            });
                          });
                        });
                      },
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Wallet Balance',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.colorlightgrey),
                            ),
                            Text(
                              walletBalance,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.colorgreen,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
//                      Text(
//                        'successfully applied',
//                        style: TextStyle(fontSize: 14, color: Colors.colorgreen),
//                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: 0,
              bottom: 0,
            ),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          ListTile(
            title: Text(
              'SHIPPING ADDRESS',
              style: TextStyle(fontSize: 16, color: Colors.colorgreen),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.edit),
              ],
            ),
            onTap: () {
              _showAddressDialog(context);
            },
          ),
//          Padding(
//            padding: EdgeInsets.only(
//              top: 8,
//              bottom: 0,
//            ),
//            child: Divider(
//              color: Colors.grey,
//              height: 1,
//            ),
//          ),
          ListTile(
            title: Text(
              address,
              style: TextStyle(color: Colors.colorlightgrey),
              // style: TextStyle(color: Colors.black),
            ),
          ),
//          Padding(
//            padding: EdgeInsets.only(top: 16),
//            child: Text(
//              'BILLING ADDRESS',
//              style: TextStyle(fontSize: 18),
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.only(
//              top: 8,
//              bottom: 0,
//            ),
//            child: Divider(
//              color: Colors.grey,
//              height: 1,
//            ),
//          ),
//          ListTile(
//            title: Text(
//              'Akshya nagar 1st block, 1st Cross, Rammurty nagar, Banglore-560016',
//              // style: TextStyle(color: Colors.black),
//            ),
//          ),
          Padding(
            padding: EdgeInsets.only(
              top: 16,
              bottom: 0,
            ),
          ),
        ],
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
      border: Border.all(color: Colors.colorlightgrey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  Future checkIfPromoSaved() async {
    // setState(() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        check = prefs.getString('promoApplies') ?? "";
        discount = prefs.getInt('discount') ?? 0;
        print("Saved Discount: $discount");
        if (discount > 0) {
          appliedValue = "Promo code applied";
        } else {
          appliedValue = "Apply promo code";
        }
      });
    });

//    if (check.isEmpty) {
//      discount = 0;
//      appliedValue = "Apply promo code";
//    } else {
//      discount = 20;
//      appliedValue = "Promo code applied";
//    }
    // });
    return check;
  }

  Future removePromoFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('promoApplies', "");
    await prefs.setInt('discount', 0);
    setState(() {
      check = "";
      discount = 0;
      appliedValue = "Apply promo code";
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
    });
  }

  getBalance() async {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
      String vv = await prefs.getString('walletBal') ?? "";
      print("GGGGGGGGGGGGGWWWW $vv ");
      if (profile.walletCredits > int.parse(vv)) {
        walletDiscount = int.parse(vv);
      } else {
        vv = "0";
        Toast.show("Amount is more than Balance in Wallet.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      return vv;
    });
  }

  Widget productContent(List<Product> products) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        calculateTotal(products);
      });
    });
    return products.length > 0
        ? Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: ListView.builder(
                  itemBuilder: (context, position) {
                    return getListItem(position, products);
                  },
                  itemCount: products.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  primary: false,
                ),
              ),
              getCartDetailView(context),
            ],
          )
        : noDataView();
  }

  void incrementCount(Product product) {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
      _database.update(product);
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Available inventory : ${product.inventory}"),
      ));
    }
  }

  void decrementCount(Product product, List<Product> products) {
    if (product.count > 1) {
      product.count = product.count - 1;
      _database.update(product);
    } else if (product.count == 1) {
      product.count = product.count - 1;
      _database.remove(product);
      products.remove(product);
    }
    // remove from database
  }

  calculateTotal(List<Product> products) async {
    totalAmount = 0;
    for (Product product in products) {
      totalAmount += (product.selectedPacking.price * product.count);
    }

    checkoutTotal = totalAmount - discount - walletDiscount;
  }

  void updateUI() {
    setState(() {
      //bloc.fetchData();
    });
    didChangeDependencies();
  }

  Widget noDataView() {
    return Container(
      child: Column(
        children: <Widget>[Text("No item in your cart")],
      ),
    );
  }

  void handlePayTmResponse(String response, BuildContext context) {
    if (response.contains("KITKAT")) {
      print(response);
    } else {
      // Navigator.of(context).pop();
      Map<String, dynamic> data = {
        'total': checkoutTotal,
        'address': address,
        'city': profile.city,
        'area': profile.area,
        'type': profile.type,
        'discount': discount,
      };
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
                  response: response,
                  cartExtra: data,
                ),
          ));
    }
  }

  getCheckSum(context) {
//    Future.delayed(const Duration(milliseconds: 3000), () {
    dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    dialog.setMessage("Please wait...");
    dialog.show();
    setState(() {
      orderId = "NF${new DateTime.now().millisecondsSinceEpoch}";
      mapPayTm['ORDER_ID'] = orderId;
      mapPayTm['CUST_ID'] = "Balvinder";
      mapPayTm['MOBILE_NO'] = "1234567890";
      mapPayTm['EMAIL'] = "abc@abc.abc";
      mapPayTm['TXN_AMOUNT'] = checkoutTotal.toString();
      mapPayTm['CALLBACK_URL'] =
          "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    });
    blocCheck.fetchData(mapPayTm);
//    });
    blocCheck.checksum.listen((res) {
      print("CHECKSUM: $res");
      dialog.hide();
      platform.invokeMethod('$res::${jsonEncode(mapPayTm)}').then((result) {
        handlePayTmResponse(result, context);
      });
    });
  }

  void _showAddressDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Center(
            child: SingleChildScrollView(
          child: AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "Update Address",
                      style: TextStyle(
                          color: Colors.colorgreen, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.colorgreen)),
                            hasFloatingPlaceholder: true,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          controller: addressController,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "City",
                                style: TextStyle(
                                  color: Colors.colorlightgrey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Center(
                            child: DropdownButtonFormField<CityModel>(
                              decoration: InputDecoration.collapsed(hintText: selectedCity.name),
                              value: null,
                              items: cities.map((CityModel value) {
                                return new DropdownMenuItem<CityModel>(
                                  value: value,
                                  child: new Text(value.name),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCity = newValue;
                                  getCityAreas(newValue);
                                  Navigator.of(context).pop();
                                  _showAddressDialog(context);
                                });
                              },
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.colorlightgrey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Area",
                                style: TextStyle(
                                  color: Colors.colorlightgrey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Center(
                            child: DropdownButtonFormField<AreaModel>(
                              decoration: InputDecoration.collapsed(hintText: selectedArea.name),
                              value: null,
                              items: cityAreas.map((AreaModel value) {
                                return new DropdownMenuItem<AreaModel>(
                                  value: value,
                                  child: new Text(value.name),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedArea = newValue;
                                  Navigator.of(context).pop();
                                  _showAddressDialog(context);
                                });
                              },
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.colorlightgrey,
                        ),
                      ],
                    ),
                  ),
                  // Flexible(
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      splashColor: Colors.black12,
                      color: Colors.colorgreen,
                      onPressed: () {
                        var localAddress = addressController.text.toString();
                        if (localAddress.length > 0) {
                          var dialog = new ProgressDialog(context, ProgressDialogType.Normal);
                          dialog.setMessage("Please wait...");
                          dialog.show();

                          blocAddress.fetchData(localAddress, selectedCity.id, selectedArea.id);
                          blocAddress.profileData.listen((response) {
                            dialog.hide();
                            if (response.status == "true") {
                              Navigator.of(context).pop();
                              String data = jsonEncode(response.profile);
                              prefs.saveProfile(data);
                              getProfileDetail();
                            }
                            Toast.show(response.msg, context,
                                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                          });
                        } else {
                          Toast.show("Address cannot be empty", context,
                              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  void getProfileDetail() {
    prefs.getProfile().then((onValue) {
      setState(() {
        profile = onValue;
        walletBalance = profile.walletCredits;
        address = profile.address;
        addressController.text = profile.address;
      });
    });
  }
}

class LogoutOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<LogoutOverlay> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {});
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 180.0,
              decoration: ShapeDecoration(
                  color: Color.fromRGBO(41, 167, 77, 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Please Enter Promo code",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8, left: 20.0, right: 20.0),
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: new Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            child: new TextField(
                              controller: myController,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter Promo Code',
                                border: InputBorder.none,
                              ),
                            ),
                          ))),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ButtonTheme(
                            height: 35.0,
                            minWidth: 110.0,
                            child: RaisedButton(
                              color: Colors.white,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              splashColor: Colors.white.withAlpha(40),
                              child: Text(
                                'Ok',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
//                                      Route route = MaterialPageRoute(
//                                          builder: (context) => LoginScreen());
//                                      Navigator.pushReplacement(context, route);
                                });
                              },
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: ButtonTheme(
                              height: 35.0,
                              minWidth: 110.0,
                              child: RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                splashColor: Colors.white.withAlpha(40),
                                child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                    /* Route route = MaterialPageRoute(
                                          builder: (context) => LoginScreen());
                                      Navigator.pushReplacement(context, route);
                                   */
                                  });
                                },
                              ))),
                    ],
                  ))
                ],
              )),
        ),
      ),
    );
  }
}

class DynamicDialog extends StatefulWidget {
  ProfileModel waletb;
  DynamicDialog(ProfileModel waletb) {
    this.waletb = waletb;
  }

//  DynamicDialog({this.title});

//  final String title;

  @override
  _DynamicDialogState createState() => _DynamicDialogState(waletb);
}

class _DynamicDialogState extends State<DynamicDialog> {
  String _title;
  var liked = false;
  String image1 = "assets/fav_filled.png";
  String image2 = "assets/ic_fav.png";
  String currentimage = "assets/ic_fav.png";
  var textFieldController = TextEditingController();
  ProfileModel waletb;

  _DynamicDialogState(ProfileModel waletb) {
    this.waletb = waletb;
  }
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            height: 70,
            width: 320,
            color: Colors.colorgreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        waletb.walletCredits.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),
                      Text(
                        "credits",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    "available balance",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Container(
            width: 300,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: textFieldController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Enter Amount'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: GestureDetector(
            onTap: () {
              saveToPrefs(textFieldController.text.toString());
              Navigator.pop(context);
              // textFieldController.toString();
            },
            child: Container(
              height: 40,
              width: 150,
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                  color: Colors.colorgreen),
              child: Center(
                child: new Text("Apply",
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

  void saveToPrefs(String string) async {
    if (string.isEmpty) {
    } else {
      setState(() async {
        print("GGGGGGGGGGGGG yyyyyy$string");
        SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
        await prefs.setString('walletBal', string);
      });
    }
  }
}
