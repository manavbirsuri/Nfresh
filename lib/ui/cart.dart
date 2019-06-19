import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/bloc/cart_bloc.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/PromoCodePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

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
  String walletBalance = "₹110";
  String appliedValue = "Apply promo code";
  var bloc = CartBloc();
  int totalAmount = 0;
  int checkoutTotal = 0;
  num discount = 0;
  int walletDiscount = 0;
  ProfileModel waletb;
  var prefs = SharedPrefs();
  @override
  void initState() {
    super.initState();
    setState(() {
      checkIfPromoSaved().then((value) {
        setState(() {
          check = value;
        });
      });
    });
    prefs.getProfile().then((onValue) {
      waletb = onValue;
      walletBalance = waletb.walletCredits.toString();
    });
    bloc.fetchData();
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: StreamBuilder(
                              stream: bloc.catProductsList,
                              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                                if (snapshot.hasData) {
                                  return productContent(snapshot);
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                return Center(child: CircularProgressIndicator());
                              },
                            ),
                          ),
                          getCartDetailView(context),
                        ],
                      ),
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
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                              try {
                                final String result =
                                    await platform.invokeMethod('Message to share on whatsapp');
                                response = result;
                              } on PlatformException catch (e) {
                                response = "Failed to Invoke: '${e.message}'.";
                              }

                              print("RES: $response");
                            },
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
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
                            Padding(
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
                      new MaterialPageRoute(builder: (context) => new PromoCodePage()),
                    ).then((value) {
                      setState(() {
                        checkIfPromoSaved().then((value) {
                          check = value;
                          discount = 20;
                        });
                      });
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
                  if (int.parse(walletBalance) > 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            type: MaterialType.transparency,
                            child: Container(
                              child: DynamicDialog(waletb),
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
                    Toast.show("Insufficiant Balance in Wallet.", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
              'Akshya nagar 1st block, 1st Cross, Rammurty nagar, Banglore-560016',
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
      borderRadius: BorderRadius.all(Radius.circular(100)),
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
    check = await prefs.getString('promoApplies') ?? "";

    if (check.isEmpty) {
      discount = 0;
      appliedValue = "Apply promo code";
    } else {
      discount = 20;
      appliedValue = "Promo code applied";
    }
    // });
    return check;
  }

  Future removePromoFromPrefs() async {
    setState(() async {
      check = "";
      appliedValue = "Apply promo code";
      SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
      await prefs.setString('promoApplies', "");
    });
  }

  Future<String> getBalance() async {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
      String vv = await prefs.getString('walletBal') ?? "";
      print("GGGGGGGGGGGGGWWWW $vv ");
      if (waletb.walletCredits > int.parse(vv)) {
        walletDiscount = int.parse(vv);
      } else {
        vv = "0";
        Toast.show("Amount is more than Balance in Wallet.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      return vv;
    });
  }

  Widget productContent(AsyncSnapshot<List<Product>> snapshot) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        calculateTotal(snapshot.data);
      });
    });

    return ListView.builder(
      itemBuilder: (context, position) {
        return getListItem(position, snapshot.data);
      },
      itemCount: snapshot.data.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      primary: false,
    );
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
