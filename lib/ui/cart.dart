import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:nfresh/bloc/cart_bloc.dart';
import 'package:nfresh/bloc/check_inventory_bloc.dart';
import 'package:nfresh/bloc/checksum_bloc.dart';
import 'package:nfresh/bloc/cities_bloc.dart';
import 'package:nfresh/bloc/create_order_bloc.dart';
import 'package:nfresh/bloc/profile_bloc.dart';
import 'package:nfresh/bloc/update_address_bloc.dart';
import 'package:nfresh/models/area_model.dart';
import 'package:nfresh/models/city_model.dart';
import 'package:nfresh/models/product_invent_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/models/time_slot.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/PromoCodePage.dart';
import 'package:nfresh/ui/payment_success.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import '../utils.dart';
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
  String couponCode;
  var pos = 0;
  int diffDays = 0;
  bool validSlot = false;
  String check = "";
  double walletBalance = 0;
  String appliedValue = "Apply promo code";
  var bloc = CartBloc();
  var blocInvent = CheckInventoryBloc();
  int totalAmount = 0;
  int checkoutTotal = 0;
  num discount = 0;
  int walletDiscount = 0;
  int selectedPosition = -1;
  ProfileModel profile;
  var blocInventory = CheckInventoryBloc();
  List<Map<String, dynamic>> lineItems = [];
  List<Map<String, dynamic>> lineItems2 = [];
  List<CityModel> cities = [];
  List<AreaModel> areas = [];
  List<AreaModel> cityAreas = [];
  static Map<String, dynamic> map = {'id': -1, 'name': "Select City"};
  static Map<String, dynamic> map1 = {
    'id': -1,
    'name': "Select City",
    'city_id': -1
  };
  CityModel selectedCity = CityModel(map);
  AreaModel selectedArea;

  var blocCity = CityBloc();

  Map<String, dynamic> mapPayTm = {
    //'MID': "zqpQeZ24755039419769",
    'MID': "Nfresh85976368609478",
    'ORDER_ID': "NF${new DateTime.now().millisecondsSinceEpoch}",
    'CUST_ID': "cust123",
    'MOBILE_NO': "7777777777",
    'EMAIL': "username@emailprovider.com",
    'CHANNEL_ID': "WAP",
    'TXN_AMOUNT': "100",
    'WEBSITE': "Nfresh",
    'INDUSTRY_TYPE_ID': "Retail105",
    'CALLBACK_URL': ""
  };
  var blocCheck = ChecksumBloc();
  var blocAddress = UpdateAddressBloc();
  var prefs = SharedPrefs();
  String checksum = "";
  String orderId = "";
  List<Product> mProducts = [];
  bool isLoadingCart = true;
  var address = "No Address";
  var blocProfile = ProfileBloc();
  var addressController = TextEditingController();

  ProgressDialog dialog;

  var selectedMethod = "Cash on delivery";
  var date = "Select Date";
  var slot = 'Select Slot';
  final format = DateFormat("yyyy-MM-dd");
  List<TimeSlot> timeslot = [];
  @override
  void initState() {
    super.initState();
    blocProfile.fetchData();
    profileObserver();
    setState(() {
      selectedCity = CityModel(map);
      bloc.fetchData();
      blocCity.fetchData();
    });
    checkIfPromoSaved();
    checkAvailableProducts();

//      checkIfPromoSaved().then((value) {
//        setState(() {
//          check = value;
//        });
//      });
    getProfileDetail();

    bloc.catProductsList.listen((list) {
      setState(() {
        isLoadingCart = false;
        mProducts = list;
      });
    });
    //blocInventory.fetchData(map);
    Utils.checkInternet().then((connected) {
      if (connected != null && connected) {
        bloc.fetchData();
        blocCity.fetchData();
      } else {
        Toast.show("Not connected to internet", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });

    blocCity.cities.listen((res) {
      setState(() {
        this.cities = res.cities;
        for (int i = 0; i < cities.length; i++) {
          var city = cities[i];
          if (profile.city == city.id) {
            setState(() {
              selectedCity = city;
            });
          }
        }

        this.areas = res.areas;
        for (int i = 0; i < areas.length; i++) {
          var area = areas[i];
          if (profile.area == area.id) {
            setState(() {
              selectedArea = area;
            });
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
        setState(() {
          cityAreas.add(modelArea);
        });
      }
    }
//    if (cityAreas.length > 0) {
//      setState(() {
//        selectedArea = cityAreas[0];
//      });
//    } else {
//      selectedArea = null;
//    }
  }

  void getCityAreas2(CityModel selectedCity) {
    cityAreas = [];
    for (int i = 0; i < areas.length; i++) {
      var modelArea = areas[i];
      if (modelArea.cityId == selectedCity.id) {
        cityAreas.add(modelArea);
      }
    }

    if (cityAreas.length > 0) {
      setState(() {
        selectedArea = cityAreas[0];
      });
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
          body: mProducts.length > 0
              ? Container(
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
                      mProducts.length > 0
                          ? Column(children: <Widget>[
                              Container(
                                height: 55,
                                color: Colors.colorlightgreyback,
                                //  padding: EdgeInsets.all(4),
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
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 21),
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
                                              //flex: 1,
                                              // ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Place Order',
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
                                        onTap: () async {
                                          final _prefs = SharedPrefs();

                                          _prefs.getCouponCode().then((value) {
                                            setState(() {
                                              couponCode = value;
                                            });
                                          });
                                          if (selectedMethod ==
                                              "Select Payment method") {
                                            Toast.show(
                                                "Please select payment method.",
                                                context,
                                                duration: Toast.LENGTH_SHORT,
                                                gravity: Toast.BOTTOM);

                                            return;
                                          }
                                          if (date == "" ||
                                              date == "Select Date") {
                                            Toast.show("Select date", context,
                                                duration: 3,
                                                gravity: Toast.BOTTOM);
                                            dialog.hide();
                                            return;
                                          }
                                          if (slot == "" ||
                                              slot == "Select Slot") {
                                            Toast.show("Select Slot", context,
                                                duration: 3,
                                                gravity: Toast.BOTTOM);
                                            dialog.hide();
                                            return;
                                          }
                                          if (selectedMethod ==
                                              "Cash on delivery") {
                                            Utils.checkInternet()
                                                .then((connected) {
                                              if (connected != null &&
                                                  connected) {
                                                if (profile != null) {
                                                  dialog = new ProgressDialog(
                                                      context,
                                                      ProgressDialogType
                                                          .Normal);
                                                  dialog.setMessage(
                                                      "Please wait...");
                                                  dialog.show();
                                                  Map<String, dynamic> data = {
                                                    'total': checkoutTotal,
                                                    'address': address,
                                                    'city': profile.city,
                                                    'area': profile.area,
                                                    'type': profile.type,
                                                    'discount': discount,
                                                    'wallet_use_amount':
                                                        walletDiscount,
                                                    'coupon_code': couponCode,
                                                  };
//                                          placeOrder(
//                                              response: response,
//                                              cartExtra: data,
//                                              contexte: context);

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PaymentSuccessPage(
                                                                response:
                                                                    response,
                                                                cartExtra: data,
                                                                from: "0",
                                                                method:
                                                                    selectedMethod,
                                                                date: date,
                                                                slot: slot),
                                                      )).then((value) {
                                                    dialog.hide();
                                                    bloc.fetchData();
                                                    if (value == "yes") {
                                                      setState(() {
                                                        Navigator.pop(context);
                                                      });
                                                    }
                                                  });
                                                } else {
                                                  // showAlertMessage(context);
                                                  goToLogin();
                                                }
                                              } else {
                                                Toast.show(
                                                    "Not connected to internet",
                                                    context,
                                                    duration:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: Toast.BOTTOM);
                                              }
                                            });

//                                        Map<String, dynamic> data = {
//                                          'total': checkoutTotal,
//                                          'address': address,
//                                          'city': profile.city,
//                                          'area': profile.area,
//                                          'type': profile.type,
//                                          'discount': discount,
//                                          'wallet_use_amount':
//                                          walletDiscount,
//                                          'coupon_code': couponCode,
//                                        };

                                          } else {
                                            Utils.checkInternet()
                                                .then((connected) {
                                              if (connected != null &&
                                                  connected) {
                                                if (profile != null) {
                                                  if (checkoutTotal > 0) {
                                                    getCheckSum(context);
                                                  } else if (walletDiscount >
                                                          0 &&
                                                      checkoutTotal == 0) {
                                                    if (profile != null) {
                                                      if (date == "" ||
                                                          date ==
                                                              "Select Date") {
                                                        Toast.show(
                                                            "Select date",
                                                            context,
                                                            duration: 3,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                        dialog.hide();
                                                        return;
                                                      }
                                                      if (slot == "" ||
                                                          slot ==
                                                              "Select Slot") {
                                                        Toast.show(
                                                            "Select Slot",
                                                            context,
                                                            duration: 3,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                        dialog.hide();
                                                        return;
                                                      }
                                                      dialog =
                                                          new ProgressDialog(
                                                              context,
                                                              ProgressDialogType
                                                                  .Normal);
                                                      dialog.setMessage(
                                                          "Please wait...");
                                                      dialog.show();
                                                      Map<String, dynamic>
                                                          data = {
                                                        'total': checkoutTotal,
                                                        'address': address,
                                                        'city': profile.city,
                                                        'area': profile.area,
                                                        'type': profile.type,
                                                        'discount': discount,
                                                        'wallet_use_amount':
                                                            walletDiscount,
                                                        'coupon_code':
                                                            couponCode,
                                                      };
//                                              placeOrder(
//                                                  response: response,
//                                                  cartExtra: data,
//                                                  contexte: context);

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PaymentSuccessPage(
                                                                    response:
                                                                        response,
                                                                    cartExtra:
                                                                        data,
                                                                    from: "0",
                                                                    method:
                                                                        selectedMethod,
                                                                    date: date,
                                                                    slot: slot),
                                                          )).then((value) {
                                                        dialog.hide();
                                                        bloc.fetchData();
                                                      });
                                                    } else {
                                                      // showAlertMessage(context);
                                                      goToLogin();
                                                    }
                                                  } else {
                                                    Map<String, dynamic> data =
                                                        {
                                                      'total': checkoutTotal,
                                                      'address': address,
                                                      'city': profile.city,
                                                      'area': profile.area,
                                                      'type': profile.type,
                                                      'discount': discount,
                                                      'wallet_use_amount':
                                                          walletDiscount,
                                                      'coupon_code': couponCode,
                                                    };
                                                    if (date == "" ||
                                                        date == "Select Date") {
                                                      Toast.show("Select date",
                                                          context,
                                                          duration: 3,
                                                          gravity:
                                                              Toast.BOTTOM);
                                                      dialog.hide();
                                                      return;
                                                    }
                                                    if (slot == "" ||
                                                        slot == "Select Slot") {
                                                      Toast.show("Select Slot",
                                                          context,
                                                          duration: 3,
                                                          gravity:
                                                              Toast.BOTTOM);
                                                      dialog.hide();
                                                      return;
                                                    }
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PaymentSuccessPage(
                                                                  response:
                                                                      response,
                                                                  cartExtra:
                                                                      data,
                                                                  from: "0",
                                                                  method:
                                                                      selectedMethod,
                                                                  date: date,
                                                                  slot: slot),
                                                        )).then((value) {
                                                      dialog.hide();
                                                      bloc.fetchData();
                                                    });
                                                  }
                                                } else {
                                                  // showAlertMessage(context);
                                                  goToLogin();
                                                }
                                              } else {
                                                Toast.show(
                                                    "Not connected to internet",
                                                    context,
                                                    duration:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: Toast.BOTTOM);
                                              }
                                            });
                                          }
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
                  ),
                )
              : noDataView(),
        )
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.colorlightgrey),
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
                                    product.selectedPacking.displayPrice > 0
                                        ? Text(
                                            '₹${getCalculatedPrice(product)}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.colororange,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            textAlign: TextAlign.start,
                                          )
                                        : Container(),
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
                                    width: 105,
                                    decoration: myBoxDecoration3(),
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(right: 8, left: 8),
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
                                showMessage(
                                    context, product, products, position);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 8, left: 16, bottom: 16),
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
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 8, left: 8, top: 16),
                              child: Container(
                                width: 104,
                                //color: Colors.grey,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: IntrinsicHeight(
                                    child: Center(
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                decrementCount(product,
                                                    products, position);
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 2000),
                                                    () {
                                                  setState(() {
                                                    calculateTotal(products);
                                                  });
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                // color: Colors.white,
                                                child: Container(
                                                  decoration:
                                                      myBoxDecoration2(),
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
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
                                                  left: 4,
                                                  right: 4,
                                                  top: 4,
                                                  bottom: 4),
                                              child: Center(
                                                child: Text(
                                                  product.count.toString(),
                                                  style: TextStyle(
                                                      color: Colors.colorgreen,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (walletDiscount >
                                                      totalAmount) {
                                                    setState(() {
                                                      walletDiscount = 0;
                                                      checkoutTotal =
                                                          totalAmount -
                                                              discount -
                                                              walletDiscount;
                                                    });
                                                  }
                                                  incrementCount(
                                                      products[position]);
                                                });
                                              },
                                              child: Container(
                                                //  color: Colors.white,
                                                padding:
                                                    EdgeInsets.only(right: 0),
                                                child: Container(
                                                  decoration:
                                                      myBoxDecoration2(),
                                                  padding: EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
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
      padding: EdgeInsets.only(left: 0, top: 0, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 26, top: 8),
            child: Text(
              'Payment method',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.colorgreen,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RadioButtonGroup(
                onSelected: (String selected) => setState(() {
                  selectedMethod = selected.trim();
                }),
                orientation: GroupedButtonsOrientation.VERTICAL,
                labels: <String>["Cash on delivery", "Pay online"],
                picked: selectedMethod,
              ),
            ],
//            child: DropdownButtonHideUnderline(
//              child: ButtonTheme(
//                alignedDropdown: false,
//                child: DropdownButton<String>(
//                  isExpanded: true,
//                  value: selectedMethod,
//                  onChanged: (String newValue) {
//                    setState(() {
//                      selectedMethod = newValue;
//                      if (newValue == "Cash on delivery" ||
//                          newValue == "Select Payment method") {
//                        setState(() {
//                          walletDiscount = 0;
//                        });
//                      }
//                    });
//                  },
//                  items: <String>['Pay online', 'Cash on delivery']
//                      .map<DropdownMenuItem<String>>((String value) {
//                    return DropdownMenuItem<String>(
//                      value: value,
//                      child: Padding(
//                          padding: EdgeInsets.only(left: 16),
//                          child: Text(value)),
//                    );
//                  }).toList(),
//                ),
//              ),
//            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0, left: 10, right: 0),
            child: ListTile(
              title: Text(
                'Coupons',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.colorgreen,
                    fontWeight: FontWeight.bold),
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
          ),
          selectedMethod == "Pay online"
              ? Padding(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 26, right: 16),
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
                                    child: DynamicDialog(
                                        profile, walletDiscount, checkoutTotal),
                                    padding:
                                        EdgeInsets.only(top: 40, bottom: 40),
                                  ),
                                );
                              }).then((value) async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            String vv =
                                await prefs.getString('walletBal') ?? "";
                            setState(() {
                              walletDiscount = int.parse(vv);
//                            getBalance().then((onValue) {
//                              //print("LLLLLLLLLLLL: " + onValue);
//                              setState(() {
//                                walletDiscount = onValue as int;
                            });
//                            });

//                            setState(() {
//                              walletDiscount = int.parse(value);
//                            });
                          });
                        } else {
//                    Toast.show("Insufficiant Balance in Wallet.", context,
//                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                          if (profile == null) {
                            // showAlertMessage(context);
                            goToLogin();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletPage(),
                                )).then((value) {
                              getProfileDetail();
                            });
                          }
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
                            style: TextStyle(
                                fontSize: 18, color: Colors.colorlightgrey),
                          ),
                          Text(
                            walletBalance > 0
                                ? walletBalance.toInt().toString()
                                : "Add",
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
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(
              8,
            ),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, left: 0),
            child: ListTile(
              //contentPadding: EdgeInsets.only(top: 0),
              title: Text(
                'Select Delivery Slot',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.colorgreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              _selectDate();
                            },
                            child: Row(
                              children: <Widget>[
                                new Text(
                                  date,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.black38,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              if (date == "Select Date") {
                                Toast.show("Please select date.", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } else {
                                if (profile == null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                        from: 0,
                                      ),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                            child: showCustomDialog2(timeslot,
                                                date, selectedPosition),
                                            padding: EdgeInsets.only(
                                                top: 40, bottom: 40),
                                          ),
                                        );
                                      }).then((value) async {
                                    setState(() {
                                      if (value != null &&
                                          value != "" &&
                                          value != "Select Slot") {
                                        if (diffDays == 0) {
                                          validSlot =
                                              checkTimeSlotValidity(value);
                                          if (!validSlot) {
                                            Toast.show(
                                                "Time slot you have selected is over, please select next slot if available or you can select next date for avialable slots.",
                                                context,
                                                duration: 6,
                                                gravity: Toast.BOTTOM);
                                            return;
                                          }
                                          for (int k = 0;
                                              k < timeslot.length;
                                              k++) {
                                            var from = value.split("-");
                                            if (from[0].trim() ==
                                                    timeslot[k].time_from &&
                                                from[1].trim() ==
                                                    timeslot[k].time_to) {
                                              setState(() {
                                                selectedPosition = k;
                                              });
                                            }
                                          }
                                          slot = value;
                                        } else {
                                          for (int k = 0;
                                              k < timeslot.length;
                                              k++) {
                                            var from = value.split("-");
                                            if (from[0].trim() ==
                                                    timeslot[k].time_from &&
                                                from[1].trim() ==
                                                    timeslot[k].time_to) {
                                              setState(() {
                                                selectedPosition = k;
                                              });
                                            }
                                          }
                                          slot = value;
                                        }
                                      }
//                              setState(() {
//                                walletDiscount = onValue as int;
                                    });
                                  });
                                }
                              }
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    slot,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  Icon(
                                    Icons.navigate_next,
                                    color: Colors.black38,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(
              8,
            ),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, left: 10),
            child: ListTile(
              //contentPadding: EdgeInsets.only(top: 0),
              title: Text(
                'Price Details',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.colorgreen,
                  fontWeight: FontWeight.bold,
                ),
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
                          style: TextStyle(
                              fontSize: 18, color: Colors.colorlightgrey),
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.colorlightgrey),
                              ),
                              Text(
                                '-₹$discount',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.colorlightgrey),
                              ),
                              Text(
                                '-₹$walletDiscount',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
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
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹$checkoutTotal',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: ListTile(
              // contentPadding: EdgeInsets.only(bottom: 0),
              title: Text(
                'Shipping Address',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.colorgreen,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.edit),
                ],
              ),
              onTap: () {
                if (profile == null) {
                  // showAlertMessage(context);
                  goToLogin();
                } else {
                  Utils.checkInternet().then((connected) {
                    if (connected != null && connected) {
                      //Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        bloc.fetchData();
                        blocCity.fetchData();
                      });
                      // });
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (selectedArea != null && selectedCity != null) {
                          _showAddressDialog(context);
                        } else {
                          Toast.show("Please wait Loading Data", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      });
                    } else {
                      Toast.show("Not connected to internet", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  });
                }
              },
            ),
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
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: ListTile(
              //  contentPadding: EdgeInsets.only(top: 0),
              title: Text(
                address,
                style: TextStyle(color: Colors.colorlightgrey),
                // style: TextStyle(color: Colors.black),
              ),
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

  void showMessage(context, product, List<Product> products, int position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(
              "Are you sure you want to clear this product from the cart?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _database.remove(product);
                  products.removeAt(position);
                  if (products.length == 0) {
                    setState(() {
                      saveToPrefs(0);
                      discount = 0;
                      walletDiscount = 0;
                    });
                  }
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  saveToPrefs(int discount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('promoApplies', "");
    await prefs.setString('couponCode', "");
    await prefs.setInt("discount", discount);
  }

  Future removePromoFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('promoApplies', "");
    await prefs.setString('couponCode', "");
    await prefs.setInt('discount', 0);
    setState(() {
      check = "";
      discount = 0;
      appliedValue = "Apply promo code";
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
    });
  }

  getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
    String vv = await prefs.getString('walletBal') ?? "";
    if (vv == "0") {
      return vv;
    }
    if (profile.walletCredits >= int.parse(vv)) {
      if (checkoutTotal >= int.parse(vv)) {
        setState(() {
          walletDiscount = int.parse(vv);
        });
      } else {
        showAlert("Amount should not be more than your cart total.", context);
//          Toast.show("Amount should not be more than your cart total.", context,
//              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      vv = "0";
      showAlert("Amount is more than Balance in Wallet.", context);
//        Toast.show("Amount is more than Balance in Wallet.", context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    return vv;
  }

  Widget productContent(List<Product> products) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (products.length > 0) {
        setState(() {
          calculateTotal(products);
        });
      }
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
      Toast.show(
          "Current available quantity is " + product.inventory.toString(),
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    }
  }

  void decrementCount(Product product, List<Product> products, position) {
    if (product.count > 1) {
      setState(() {
        product.count = product.count - 1;
        _database.update(product);
      });
    } else if (product.count == 1) {
      // product.count = product.count - 1;
      showMessage(context, product, products, position);
    }
    // remove from database
  }

  calculateTotal(List<Product> products) async {
    totalAmount = 0;
    for (Product product in products) {
      totalAmount += (product.selectedPacking.price * product.count);
    }

//    if (walletDiscount > totalAmount) {
//      setState(() {
//        walletDiscount = 0;
//      });
//    }
    if (walletDiscount + discount > totalAmount ||
        discount > totalAmount ||
        walletDiscount > totalAmount) {
      setState(() {
        saveToPrefs(0);
        discount = 0;
        walletDiscount = 0;
        check = "";
        removePromoFromPrefs();
      });
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
      color: Colors.white,
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/noproduct.png'),
              ),
            ),
            height: 150,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              "No products in your cart",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      )),
    );
  }

  void handlePayTmResponse(String response, BuildContext context) {
    final _prefs = SharedPrefs();

    _prefs.getCouponCode().then((value) {
      setState(() {
        couponCode = value;
      });
    });

    if (response.contains("KITKAT")) {
      print(response);
    } else {
      if (date == "" || date == "Select Date") {
        Toast.show("Select date", context, duration: 3, gravity: Toast.BOTTOM);
        dialog.hide();
        return;
      }
      if (slot == "" || slot == "Select Slot") {
        Toast.show("Select Slot", context, duration: 3, gravity: Toast.BOTTOM);
        dialog.hide();
        return;
      }
      // Navigator.of(context).pop();
      Map<String, dynamic> data = {
        'total': checkoutTotal,
        'address': address,
        'city': profile.city,
        'area': profile.area,
        'type': profile.type,
        'discount': discount,
        'wallet_use_amount': walletDiscount,
        'coupon_code': couponCode,
      };

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
                response: response,
                cartExtra: data,
                from: "1",
                method: selectedMethod,
                date: date,
                slot: slot),
          )).then((value) {
        bloc.fetchData();
        dialog.hide();
      });
    }
  }

  getCheckSum(context) {
    if (date == "" || date == "Select Date") {
      Toast.show("Select date", context, duration: 3, gravity: Toast.BOTTOM);
      dialog.hide();
      return;
    }
    if (slot == "" || slot == "Select Slot") {
      Toast.show("Select Slot", context, duration: 3, gravity: Toast.BOTTOM);
      dialog.hide();
      return;
    }
//    Future.delayed(const Duration(milliseconds: 3000), () {
    dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    dialog.setMessage("Please wait...");
    dialog.show();
    setState(() {
      orderId = "NF${new DateTime.now().millisecondsSinceEpoch}";
      mapPayTm['ORDER_ID'] = orderId;
      mapPayTm['CUST_ID'] = "C_" + profile.phoneNo;
      mapPayTm['MOBILE_NO'] = profile.phoneNo;
      mapPayTm['EMAIL'] = profile.email;
      mapPayTm['TXN_AMOUNT'] = checkoutTotal.toString();
      mapPayTm['CALLBACK_URL'] =
          "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    });
    Utils.checkInternet().then((connected) {
      if (connected != null && connected) {
        blocCheck.fetchData(mapPayTm);
      } else {
        dialog.hide();
        Toast.show("Not connected to internet", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });

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
    //  if (selectedCity.name == null) {

    //}
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
                          color: Colors.colorgreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
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
                                borderSide:
                                    BorderSide(color: Colors.colorgreen)),
                            hasFloatingPlaceholder: true,
                          ),
                          textCapitalization: TextCapitalization.sentences,
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
                              decoration: InputDecoration.collapsed(
                                  hintText: selectedCity.name),
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
                                  getCityAreas2(newValue);
                                  Navigator.of(context).pop();
//                                  Utils.checkInternet().then((connected) {
//                                    if (connected != null && connected) {
//                                      Future.delayed(
//                                          const Duration(milliseconds: 500),
//                                          () {
//                                        setState(() {
//                                          bloc.fetchData();
//                                          blocCity.fetchData();
//                                        });
//                                      });
                                  if (selectedArea != null &&
                                      selectedCity != null) {
                                    _showAddressDialog(context);
                                  } else {
                                    Toast.show(
                                        "Please wait Loading Data", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  }
//                                    } else {
//                                      Toast.show(
//                                          "Not connected to internet", context,
//                                          duration: Toast.LENGTH_SHORT,
//                                          gravity: Toast.BOTTOM);
//                                    }
//                                  });
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
                              decoration: InputDecoration.collapsed(
                                  hintText: selectedArea.name),
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
//                                  Utils.checkInternet().then((connected) {
//                                    if (connected != null && connected) {
//                                      Future.delayed(
//                                          const Duration(milliseconds: 500),
//                                          () {
//                                        setState(() {
//                                          bloc.fetchData();
//                                          blocCity.fetchData();
//                                        });
//                                      });
                                  if (selectedArea != null &&
                                      selectedCity != null) {
                                    _showAddressDialog(context);
                                  } else {
                                    Toast.show(
                                        "Please wait Loading Data", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  }
//                                    } else {
//                                      Toast.show(
//                                          "Not connected to internet", context,
//                                          duration: Toast.LENGTH_SHORT,
//                                          gravity: Toast.BOTTOM);
//                                    }
//                                  });
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
                          var dialog = new ProgressDialog(
                              context, ProgressDialogType.Normal);
                          dialog.setMessage("Please wait...");
                          dialog.show();

                          blocAddress.fetchData(
                              localAddress, selectedCity.id, selectedArea.id);
                          blocAddress.profileData.listen((response) {
                            if (response.status == "true") {
                              Navigator.of(context).pop();
                              String data = jsonEncode(response.profile);
                              prefs.saveProfile(data);
                              getProfileDetail();
                            }
                            Toast.show(response.msg, context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
                            bloc.fetchData();
                            blocCity.fetchData();
                            dialog.hide();
                          });
                        } else {
                          Toast.show("Address cannot be empty", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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

  double getCalculatedPrice(Product product) {
    return (product.selectedPacking.displayPrice).toDouble();
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

  void showAlert(String msg, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(msg),
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

  void goToLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            from: 1,
          ),
        )).then((value) {
      getProfileDetail();
      blocCity.fetchData();
    });
  }

  void checkAvailableProducts() {
    List<Product> productss = List();
    List<Product> productsnew = List();
    _database.queryAllProducts().then((products) {
      productss = products;
      products.forEach((product) {
        Map<String, dynamic> map = {
          'product_id': product.id,
          'unitqty': product.selectedPacking.unitQty,
          'qty': product.count,
        };
        lineItems2.add(map);
      });
      blocInvent.fetchData(lineItems2);
    });
    blocInvent.inventory.listen((responsee) {
      if (responsee.status == "true") {
        List<ProductInvent> array = responsee.products;

        for (int i = 0; i < productss.length; i++) {
          var exists = 0;
          for (int j = 0; j < array.length; j++) {
            if (array[j].product_id == productss[i].id &&
                array[j].unitQty == productss[i].packing[0].unitQty) {
              exists = 1;

              productss[i].packing[0].unitQtyShow = array[j].qty.toString();
              _database.update(productss[i]);
            }
          }
          if (exists == 0) {
            productsnew.add(productss[i]);
          }
        }
        for (int k = 0; k < productsnew.length; k++) {
          _database.remove(productsnew[k]);
        }
        _database.queryAllProducts().then((products) {
          setState(() {
            mProducts = products;
          });
        });
      }
    });
  }

  void placeOrder(
      {String response,
      Map<String, dynamic> cartExtra,
      BuildContext context1,
      BuildContext contexte}) {
    List<Map<String, dynamic>> lineItems1 = [];
    var bloc2 = CreateOrderBloc();
    setState(() {
//      message = "Placing your order. Please wait...";
//      showLoader = true;
    });

    _database.queryAllProducts().then((products) {
      products.forEach((product) {
        Map<String, dynamic> map = {
          'product_id': product.id,
          'unitqty': product.selectedPacking.unitQty,
          'qty': product.count,
        };
        lineItems1.add(map);
      });
      if (date == "" || date == "Select Date") {
        Toast.show("Select date", context, duration: 3, gravity: Toast.BOTTOM);
        return;
      }
      if (slot == "" || slot == "Select Slot") {
        Toast.show("Select Slot", context, duration: 3, gravity: Toast.BOTTOM);
        return;
      }
      var slots = slot.split("-");
      bloc2.fetchData(
          lineItems1, cartExtra, response, date, slots[0], slots[1]);
    });
    bloc2.createOrderResponse.listen((res) {
      var obj = jsonDecode(res);
      String status = obj['status'];
      setState(() {
        dialog.hide();
//        showLoader = false;
//        message = obj['msg'];
      });
      if (status == "true") {
        _database.clearCart();
        Navigator.pop(contexte);
      }
    });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2999));
    if (picked != null) {
      var now1 = new DateTime.now();
      DateTime aprilFirst = DateTime.utc(picked.year, picked.month, picked.day);
      DateTime marchThirty = DateTime.utc(now1.year, now1.month, now1.day);
      var diffDays2 = aprilFirst.difference(marchThirty).inDays;
      if (diffDays2 < 0) {
        Toast.show("You cannot select past date.", context,
            duration: 6, gravity: Toast.BOTTOM);
        return;
      }
      if (diffDays2 > 7) {
        Toast.show(
            "You cannot select date beyond 7 days from current date.", context,
            duration: 6, gravity: Toast.BOTTOM);
        return;
      }
      setState(() {
        slot = "Select Slot";
        diffDays = diffDays2;
        date = new DateFormat("yyyy-MM-dd").format(picked).toString();
      });
    }
  }

  void profileObserver() {
    blocProfile.profileData.listen((res) {
      print("Profile Status = " + res.status);
      if (res.status == "true") {
        setState(() {
          timeslot = res.timeslot;
          profile = res.profile;
        });

        String profileData = jsonEncode(res.profile);
//        _prefs.saveProfile(profileData);
//        _prefs.saveFirstTime(false);
      }
    });
  }

  bool checkTimeSlotValidity(value) {
    var aw = value.split("-");
    final dateFormat = DateFormat("hh:mm a");
    DateTime now = DateTime.now();
    DateTime open = dateFormat.parse(aw[0]);
    open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);

    int ff = open.difference(DateTime.now()).inMinutes;
    if (ff <= 0) {
      return false;
    } else {
      return true;
    }
    return false;
  }
}

class LogoutOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<LogoutOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {});
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Please Enter Promo code",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 20.0, right: 20.0),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
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
  int walletBalance;
  int checkoutTotal;
  DynamicDialog(ProfileModel waletb, int walletBalance, int checkoutTotal) {
    this.waletb = waletb;
    this.walletBalance = walletBalance;
    this.checkoutTotal = checkoutTotal;
  }

//  DynamicDialog({this.title});

//  final String title;

  @override
  _DynamicDialogState createState() => _DynamicDialogState(waletb);
}

class _DynamicDialogState extends State<DynamicDialog> {
  var liked = false;
  String image1 = "assets/fav_filled.png";
  String image2 = "assets/ic_fav.png";
  String currentimage = "assets/ic_fav.png";
  var textFieldController = TextEditingController();
  bool _value = false;

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
    //saveToPrefs("0");
  }

  @override
  Widget build(BuildContext context) {
    textFieldController.text = widget.walletBalance.toString();
    textFieldController.selection =
        TextSelection.collapsed(offset: widget.walletBalance.toString().length);
    return Container(
      child: GestureDetector(
        onTap: () {
          // saveToPrefs("0");
          Navigator.of(context).pop();
        },
        child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                                waletb.walletCredits.toInt().toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 26),
                              ),
                              Text(
                                "credits",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(labelText: 'Enter Amount'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: GestureDetector(
                    onTap: () {
                      if (_value) {
                        saveToPrefs("0");
                      } else {
                        if (textFieldController.text.toString().isNotEmpty &&
                            !textFieldController.text
                                .toString()
                                .contains(",") &&
                            !textFieldController.text
                                .toString()
                                .contains(".")) {
                          int enteredAmount =
                              int.parse(textFieldController.text.toString());
                          if (widget.checkoutTotal < enteredAmount) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              textFieldController.text = "";
                            });

                            Toast.show(
                                "You cannot add amount more than cart total.",
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            return;
                          }
                          if (waletb.walletCredits < enteredAmount) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            Toast.show(
                                "Entered amount is more than available balance in wallet.",
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            return;
                          }
                        }

                        saveToPrefs(textFieldController.text.toString());
                      }
                      if (textFieldController.text.trim().toString().isEmpty) {
                        saveToPrefs("0");
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                      // textFieldController.toString();
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(100.0)),
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
                widget.walletBalance > 0
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            saveToPrefs(textFieldController.text.toString());
                            if (_value) {
                              saveToPrefs("0");
                            }
                            Navigator.pop(context);
                            // textFieldController.toString();
                          },
                          child: Container(
                              height: 70,
                              width: 300,
                              child: Row(
                                children: <Widget>[
                                  Center(
                                      child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _value = !_value;
                                      });
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: !_value
                                            ? Icon(
                                                Icons.check_box_outline_blank,
                                                size: 20.0,
                                                color: Colors.grey,
                                              )
                                            : Icon(
                                                Icons.check_box,
                                                size: 20.0,
                                                color: Colors.blue,
                                              ),
                                      ),
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child:
                                        Text("Remove Applied Wallet balance.",
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            )),
                                  ),
                                ],
                              )),
                        ),
                      )
                    : Container(
                        height: 5,
                        width: 270,
                      )
              ]))
            ])),
      ),
    );
  }

  void saveToPrefs(String string) async {
    if (string.isEmpty) {
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
      await prefs.setString('walletBal', string);
    }
  }
}

class showCustomDialog2 extends StatefulWidget {
  List<TimeSlot> timeslot = [];
  String date = "";
  int selectedPosition = -1;
  showCustomDialog2(
      List<TimeSlot> timeslot, String date, int selectedPosition) {
    this.timeslot = timeslot;
    this.selectedPosition = selectedPosition;
    //this.date = date;
  }
  @override
  _MyDialogState createState() => _MyDialogState(timeslot);
}

class _MyDialogState extends State<showCustomDialog2> {
  String _picked = "Select Slot";
  String SelectedLanguage = "Select Slot";
  var array = <String>[];
  double width = 40;
  List<TimeSlot> timeslot = [];
  _MyDialogState(List<TimeSlot> timeslot) {
    this.timeslot = timeslot;
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      if (timeslot.length > 1) {
        width = 150;
      }
    });
    for (int i = 0; i < timeslot.length; i++) {
      if (widget.selectedPosition == i) {
        setState(() {
          _picked = timeslot[i].time_from + " - " + timeslot[i].time_to;
        });
      }
      array.add(timeslot[i].time_from + " - " + timeslot[i].time_to);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Select Time Slot"),
      content: Container(
        width: 260.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // dialog top
            Container(
              height: width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                child: new Column(
                  children: <Widget>[
                    Center(
                        child: RadioButtonGroup(
                      onSelected: (String selected) => setState(() {
                        _picked = selected.trim();
                      }),
                      margin: EdgeInsets.only(left: 14),
                      orientation: GroupedButtonsOrientation.VERTICAL,
                      labels: array,
                      picked: _picked,
                    ))
                  ],
                ),
              ),
            ),

            new Container(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              setState(() {
                                SelectedLanguage = _picked;
                              });
                              if (SelectedLanguage == "Select Slot") {
                                Toast.show("Please select time slot.", context,
                                    duration: 3, gravity: Toast.BOTTOM);
                                return;
                              }
                              Navigator.pop(context, SelectedLanguage);
                            }
                          },
                          child: Container(
                            height: 40.0,
                            width: 80,
                            color: Colors.transparent,
                            child: new Container(
                                decoration: new BoxDecoration(
                                    color: Colors.mygreen,
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(40.0),
                                        bottomLeft: const Radius.circular(40.0),
                                        bottomRight:
                                            const Radius.circular(40.0),
                                        topRight: const Radius.circular(40.0))),
                                child: new Center(
                                  child: new Text(("Done"),
                                      style: new TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              setState(() {
                                SelectedLanguage = _picked;
                              });

                              Navigator.pop(context, "");
                            }
                          },
                          child: Container(
                            height: 40.0,
                            width: 80,
                            color: Colors.transparent,
                            child: new Container(
                                decoration: new BoxDecoration(
                                    color: Colors.mygreen,
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(40.0),
                                        bottomLeft: const Radius.circular(40.0),
                                        bottomRight:
                                            const Radius.circular(40.0),
                                        topRight: const Radius.circular(40.0))),
                                child: new Center(
                                  child: new Text(("Cancel"),
                                      style: new TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                )),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
