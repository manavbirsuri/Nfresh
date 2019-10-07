import 'dart:convert';
import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/models/responses/response_home.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/CategoryDetails.dart';
import 'package:nfresh/ui/OffersPage.dart';
import 'package:nfresh/ui/OrderHistory.dart';
import 'package:nfresh/ui/ProductDetailPage.dart';
import 'package:nfresh/ui/Profile.dart';
import 'package:nfresh/ui/ShowCategoryDetailPage.dart';
import 'package:nfresh/ui/WalletPage.dart';
import 'package:nfresh/ui/cart.dart';
import 'package:nfresh/ui/login.dart';
import 'package:nfresh/ui/notifications.dart';
import 'package:nfresh/ui/refers_earn.dart';
import 'package:nfresh/utils.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bloc/get_fav_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/logout_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/search_bloc.dart';
import 'bloc/set_fav_bloc.dart';
import 'count_listener.dart';
import 'models/banner_model.dart';
import 'models/category_model.dart';
import 'models/packing_model.dart';
import 'models/product_model.dart';
import 'models/responses/response_getFavorite.dart';
import 'models/responses/response_search.dart';
import 'models/section_model.dart';

void backgroundFetchHeadlessTask() async {
  BackgroundFetch.finish();
}

void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  runApp(new MyApp());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.colorgreen, fontFamily: 'Bold'),
      home: DashBoard(),
    );
  }
}

//class DashBoard extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: MyHomePage(title: 'Home'),
//    );
//  }
//}

class DashBoard extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState("Home");
}

class _MyHomePageState extends State<DashBoard> implements CountListener {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController editingController = TextEditingController();
  var _curIndex = 0;
  String codee = '';
  var bloc = HomeBloc();
  var blocProfile = ProfileBloc();
  var blocFav = SetFavBloc();
  var blocFavGet = GetFavBloc();
  var blocSearch = SearchBloc();
  var _pageController = new PageController();
  var _pageControllerOffers = new PageController();
  var _prefs = SharedPrefs();
  var _database = DatabaseHelper.instance;
  var showLoader = true;
  var network = true;
  var showLoaderFav = true;
  List<Product> mainProduct = List();
  var viewList = false;
  var viewGrid = true;
  int noNetwork = 0;
  var gridImage = 'assets/selected_grid.png';
  var listImage = 'assets/unselected_list.png';
//  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//      new GlobalKey<RefreshIndicatorState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _count = 0;
  ProfileModel profile;
  ResponseHome homeResponse;
  ResponseGetFav favResponse;
  String SelectedLanguage = "A to Z";
  String _picked = "A to Z";
  var showLoaderSearch = true;

  ResponseSearch responseSearch;

  String mToken = "1234";

  _MyHomePageState(String title) {
    this.title = title;
  }

  @override
  Future onCartUpdate() async {
    var count = await _database.getCartCount();
    print("Cart update $_count");
    setState(() {
      _count = count;
    });
  }

  initState() {
    super.initState();

    Utils.checkInternet().then((connected) {
      if (connected != null && connected) {
        blocProfile.fetchData();
        profileObserver();
        // blocFavGet.fetchFavData();
        //favObserver();
        setState(() {
          network = true;
        });
      } else {
        setState(() {
          network = false;
          showLoader = false;
        });
        Toast.show("Not connected to internet", context,
            duration: 6, gravity: Toast.BOTTOM);
      }
    });

    bloc.homeData.listen((response) {
      setState(() {
        homeResponse = response;
      });

      // initPlatformState();
      //blocFavGet.fetchFavData();
      //favObserver();
      updateProducts();
//      _refreshController.refreshCompleted();
//      _refreshController.loadComplete();
    });
    getCartCount();

    blocSearch.searchedData.listen((data) {
      setState(() {
        showLoaderSearch = false;
      });
      responseSearch = data;
      updateSearchProducts();
    });
    //  OneSignal.shared.init("fddecd6c-3940-472d-a65d-4200ae829891");
    firebaseCloudMessagingListeners();
  }

  Future updateProducts() async {
    for (int i = 0; i < homeResponse.sections.length; i++) {
      // var products = snapshot.sections[i].products;
      for (int j = 0; j < homeResponse.sections[i].products.length; j++) {
        var product = await _database
            .queryConditionalProduct(homeResponse.sections[i].products[j]);
        if (product != null) {
          product.selectedDisplayPrice = getCalculatedPrice(product);
          setState(() {
            homeResponse.sections[i].products[j] = product;
          });
        } else {
          setState(() {
            homeResponse.sections[i].products[j].count = 0;
          });
        }
      }
    }
    setState(() {
      showLoader = false;
    });
  }

  Future updateFavProducts() async {
    if (favResponse != null &&
        favResponse.products != null &&
        favResponse.products.length > 0) {
      for (int i = 0; i < favResponse.products.length; i++) {
        var product =
            await _database.queryConditionalProduct(favResponse.products[i]);
        if (product != null) {
          product.selectedDisplayPrice = getCalculatedPrice(product);
          setState(() {
            favResponse.products[i] = product;
          });
        } else {
          setState(() {
            favResponse.products[i].count = 0;
          });
        }
      }
    }
  }

  Future updateSearchProducts2() async {
    if (responseSearch != null &&
        responseSearch.products != null &&
        responseSearch.products.length > 0) {
      for (int i = 0; i < responseSearch.products.length; i++) {
        var product =
            await _database.queryConditionalProduct(responseSearch.products[i]);
        if (product != null) {
          product.selectedDisplayPrice = getCalculatedPrice(product);
          setState(() {
            responseSearch.products[i] = product;
          });
        } else {
          setState(() {
            responseSearch.products[i].count = 0;
          });
        }
      }
    }
  }

  Future updateSearchProducts() async {
//    if (responseSearch != null &&
//        responseSearch.products != null &&
//        responseSearch.products.length > 0) {
//      for (int i = 0; i < responseSearch.products.length; i++) {
//        var product =
//            await _database.queryConditionalProduct(responseSearch.products[i]);
//        if (product != null) {
//          product.selectedDisplayPrice = getCalculatedPrice(product);
//          setState(() {
//            responseSearch.products[i] = product;
//          });
//        } else {
//          setState(() {
//            responseSearch.products[i].count = 0;
//          });
//        }
//      }
//    }
  }

  void favObserver() {
    blocFavGet.favList.listen((resFav) {
      setState(() {
        showLoaderFav = false;
      });
      favResponse = resFav;
      // updateFavProducts();
      List<Product> product1 = resFav.products;
      if (product1.length > 0) {
        for (int i = 0; i < product1.length; i++) {
          for (int j = 0; j < mainProduct.length; j++) {
            if (product1[i].id == mainProduct[j].id) {
              setState(() {
                mainProduct[j].fav = product1[i].fav;
              });
            }
          }
        }
      }
    });
    setState(() {
      showLoader = false;
    });
  }

  void profileObserver() {
    blocProfile.profileData.listen((res) {
      print("Profile Status = " + res.status);
      if (res.status == "true") {
        setState(() {
          profile = res.profile;
        });
        if (profile != null) {
          var prefs = SharedPrefs();
          prefs.getProfile().then((profile) {
            setState(() {
              codee = profile.referralCode;
            });
          });
        }
        _prefs.isFirstTime().then((isFirst) {
          print("First time = $isFirst");
          if (isFirst && res.profile.type != 1) {
            _database.clearCart();
            showMessage(context);
            getCartCount();
          }

          String profileData = jsonEncode(res.profile);
          _prefs.saveProfile(profileData);
          _prefs.saveFirstTime(false);
          // getProfileDetail();
        });
      }
    });
  }

  Future getCartCount() async {
    var count = await _database.getCartCount();
    setState(() {
      print("COUNT: $count");
      _count = count;
    });
  }

  void getProfileDetail() {
    _prefs.getProfile().then((onValue) {
      setState(() {
        profile = onValue;
      });
    });
  }

  int _selectedDrawerIndex = 0;
  void changeTabs(int tabIndex, ResponseHome snapshot) {
    setState(() {
      _curIndex = tabIndex;
      _selectedDrawerIndex = tabIndex;
    });
  }

  _getDrawerItemWidget(int pos, ResponseHome snapshot) {
//    if (pos != 3) {
//      mainProduct.clear();
//    }

    switch (pos) {
      case 0:
        return Container(
          color: Colors.white,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: homeWidget(snapshot),
//                child: HomePage(
//                  data: snapshot,
//                  listener: this,
              ),
//              )
            ],
          ),
        );
      // return new HomePage(data: snapshot, listener: this);
      case 1:
        //blocFavGet.fetchFavData();
        favObserver();
        return Container(
          color: Colors.white,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: wishListWidget(),
//                child: WishListPage(
//                  listener: this,
//                ),
              )
            ],
          ),
        );
      case 2:
        return new OffersPage();
      case 3:
        //return new SearchPage(listener: this);

        return searchViewWidget();
      default:
        return new Text("Error");
    }
  }

  _getTitle(int pos) {
    switch (pos) {
      case 0:
        return Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      case 1:
        return Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      case 2:
        return Text(
          'Offers',
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      case 3:
        return Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        );

      default:
        return new Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      Positioned(
        child: Image.asset(
          'assets/sigbg.jpg',
          fit: BoxFit.cover,
        ),
      ),
      Container(
        //color: Colors.white,
        child: showLoader
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : network
                ? bodyContent(homeResponse)
                : Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "Network Error! Please check your network connection.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showLoader = true;
                                      });
                                      blocFavGet.fetchFavData();
                                      favObserver();

                                      bloc.homeData.listen((response) {
                                        homeResponse = response;
                                        setState(() {
                                          showLoader = false;
                                        });
                                        blocProfile.fetchData();
                                        profileObserver();

                                        blocFavGet.fetchFavData();
                                        favObserver();
                                        updateProducts();
                                      });
                                      getCartCount();

                                      blocSearch.searchedData.listen((data) {
                                        setState(() {
                                          showLoaderSearch = false;
                                        });
                                        responseSearch = data;
                                        updateSearchProducts();
                                      });
                                      //  OneSignal.shared.init("fddecd6c-3940-472d-a65d-4200ae829891");
                                      firebaseCloudMessagingListeners();
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          "Click here to reload",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
        /* child: StreamBuilder(
          stream: bloc.homeData,
          builder: (context, AsyncSnapshot<ResponseHome> snapshot) {
            if (snapshot.hasData) {
              return bodyContent(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            //showMessage(context);
            return Center(child: CircularProgressIndicator());
          },
        ),*/
        /*child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: bloc.homeData,
              builder: (context, AsyncSnapshot<ResponseHome> snapshot) {
                if (snapshot.hasData) {
                  return bodyContent(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                //showMessage(context);
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),*/
      )
    ]);
  }

  Widget bodyContent(ResponseHome snapshot) {
    String status = "false";
    setState(() {
      if (snapshot != null) {
        status = snapshot.status;
      }
    });
    return status == "true"
        ? Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.colorgreen.withOpacity(0.0),
              title: _getTitle(_selectedDrawerIndex),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30.0,
                  ),
//                  new Image.asset(
//                    'assets/setting.png',
//                    width: 25,
//                    height: 25,
//                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
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
                      ),
                    ).then((value) {
                      // blocFavGet.fetchFavData();
                      getCartCount();
                      updateProducts();
                      updateFavProducts();
                      updateSearchProducts();
                      updateSearchProducts2();
                      getProfileDetail();
                    });
                  },
                  child: Padding(
                    //padding: EdgeInsets.fromLTRB(8, 16, 16, 0),
                    padding:
                        EdgeInsets.only(left: 8, top: 16, right: 16, bottom: 0),
                    child: Stack(
                      children: <Widget>[
                        new Image.asset(
                          "assets/cart.png",
                          height: 25,
                          width: 25,
                        ),
                        _count > 0
                            ? Positioned(
                                right: 0,
                                child: new Container(
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
                                    _count.toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Text('')
                      ],
                    ),

//              child: Image.asset(
//                "assets/cart.png",
//                height: 25,
//                width: 25,
//              ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.colorgreen.withOpacity(0.5),
            body: _getDrawerItemWidget(_selectedDrawerIndex, snapshot),
            bottomNavigationBar: _bottomNormal(_curIndex, snapshot),
            drawer: Drawer(
              elevation: 8,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.transparent.withOpacity(0.5),
                          image: DecorationImage(
                              image: AssetImage('assets/bg.jpg'),
                              fit: BoxFit.fill),
                        ),
                        margin: EdgeInsets.all(0),
                        child: Container(
                          color: Colors.transparent.withOpacity(0.3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => profile == null
                                        ? LoginPage(
                                            from: 0,
                                          )
                                        : new Profile(),
                                  ));
                            },
                            child: Row(
                              children: <Widget>[
                                /* Container(
                                  margin: EdgeInsets.all(12),
                                  padding: EdgeInsets.all(5),
                                  height: 75,
                                  width: 75,
                                  color: Colors.white,
                                  child: Image.asset(
                                    'assets/logo.png',
                                  ),
                                ),*/
                                Container(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "NFresh",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 45,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        profile == null
                                            ? "Please login"
                                            : profile.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      profile != null
                                          ? Text(
                                              profile == null
                                                  ? ""
                                                  : profile.email,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: profile == null
                                                    ? Colors.grey
                                                    : Colors.white,
                                              ),
                                              textAlign: TextAlign.start,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(0),
                      ),
                      Container(
                        // color: Colors.colorPink,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Image.asset(
                                'assets/offer.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              title: Text(
                                "Offers & Promotions",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                /* Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new OffersPage(),
                                ));*/
                                Navigator.pop(context);
                                changeTabs(2, snapshot);
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/mywallet.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              title: Text(
                                "My Wallet",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WalletPage()));
                                }
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/fav.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              title: Text(
                                "My Wishlist",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
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
                                  Utils.checkInternet().then((connected) {
                                    if (connected != null && connected) {
                                      blocFavGet.fetchFavData();
                                      changeTabs(1, snapshot);
                                      setState(() {
                                        network = true;
                                      });
                                    } else {
                                      setState(() {
                                        showLoader = false;
                                      });
                                      Toast.show(
                                          "Not connected to internet", context,
                                          duration: 6, gravity: Toast.BOTTOM);
                                    }
                                  });
                                }
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/orderhistory.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              title: Text(
                                "Order History",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderHistory(),
                                      )).then((onValue) {
                                    getCartCount();
                                  });
                                }
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/contactus.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              title: Text(
                                "Contact Us",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                openEmailComposer();

//                    Navigator.of(context).pop();
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => LoginPage(),
//                      ),
//                    );
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/help.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              title: Text(
                                "Help Center",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                openEmailComposer();
//                    Navigator.of(context).pop();
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => TermAndPrivacy(),
//                      ),
//                    );
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image.asset(
                                'assets/referearn.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              title: Text(
                                "Refer & Earn",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReferEarnPage(),
                                    ),
                                  );
                                }
                              },
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            profile == null
                                ? ListTile(
                                    leading: Image.asset(
                                      'assets/logout.png',
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                    title: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                            from: 0,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : ListTile(
                                    leading: Image.asset(
                                      'assets/logout.png',
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                    title: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    onTap: () {
                                      // logout webservice
                                      Utils.checkInternet().then((connected) {
                                        if (connected != null && connected) {
                                          var blocLogout = LogoutBloc();
                                          blocLogout.fetchData();
                                          _database.clearCart();
                                          getCartCount();
                                          removePromoFromPrefs();
                                          _prefs.saveProfile("");
                                          _prefs.saveFirstTime(true);

                                          setState(() {
                                            network = true;
                                            profile = null;
                                          });
                                        } else {
                                          setState(() {
                                            showLoader = false;
                                          });
                                          Toast.show(
                                              "Not connected to internet",
                                              context,
                                              duration: 6,
                                              gravity: Toast.BOTTOM);
                                        }
                                      });
                                    },
                                  ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          )
        : noDataView();
  }

  Widget _bottomNormal(int curIndex, ResponseHome snapshot) => Container(
          child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/homel.png",
              width: 30,
              height: 30,
            ),
            title: Text(
              "HOME",
              style: TextStyle(
                  fontSize: 10,
                  color: _curIndex == 0 ? Colors.colorgreen : Colors.black38),
            ),
            activeIcon: Image.asset(
              "assets/homel.png",
              width: 30,
              height: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/fav.png",
              width: 30,
              height: 30,
              color: Colors.black38,
            ),
            title: Text(
              "WISHLIST",
              style: TextStyle(
                  fontSize: 10,
                  color: _curIndex == 1 ? Colors.colorgreen : Colors.black38),
            ),
            activeIcon: Image.asset(
              "assets/fav.png",
              width: 30,
              height: 30,
              color: Colors.colorgreen,
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/settings.png",
              width: 30,
              height: 30,
              color: Colors.black38,
            ),
            title: Text(
              "OFFERS",
              style: TextStyle(
                  fontSize: 10,
                  color: _curIndex == 2 ? Colors.colorgreen : Colors.black38),
            ),
            activeIcon: Image.asset(
              "assets/settings.png",
              width: 30,
              height: 30,
              color: Colors.colorgreen,
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/search.png",
              width: 30,
              height: 30,
              color: Colors.black38,
            ),
            title: Text(
              "SEARCH",
              style: TextStyle(
                  fontSize: 10,
                  color: _curIndex == 3 ? Colors.colorgreen : Colors.black38),
            ),
            activeIcon: Image.asset(
              "assets/search.png",
              width: 30,
              height: 30,
              color: Colors.colorgreen,
            ),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _curIndex,
        onTap: (index) {
          if (index == 1) {
            if (profile != null) {
              blocFavGet.fetchFavData();
            } else {
              goToLogin();
            }
          }

          setState(() {
            _selectedDrawerIndex = index;
            _curIndex = index;
            switch (_curIndex) {
              case 0:
                /* bloc.fetchHomeData(mToken);
                bloc.homeData.listen((response) {
                  homeResponse = response;
                  setState(() {
                    showLoader = false;
                  });
                  blocProfile.fetchData();
                  profileObserver();

                  blocFavGet.fetchFavData();
                 favObserver();
                });*/
                _getDrawerItemWidget(0, snapshot);
                updateProducts();
                // homeWidget(homeResponse);
                break;
              case 1:
                if (profile != null) {
                  _getDrawerItemWidget(1, snapshot);
                } else {
                  goToLogin();
                }
                break;
              case 2:
                _getDrawerItemWidget(2, snapshot);
                break;
              case 3:
                _getDrawerItemWidget(3, snapshot);
                setState(() {
                  showLoaderSearch = true;
                  editingController.text = "";
                  mainProduct.clear();
                });

                updateProducts();
                break;
            }
          });
        },
      ));

  void showMessage(context) {
    var uType = "";
    if (profile.type == 2) {
      uType = "Wholesaler";
    } else if (profile.type == 3) {
      uType = " Marriage Palace";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(
              "Seems like you have logged in using a $uType account. The items in the cart will be removed due to the pricing being different for your account type. Please add the items again in the cart and proceed. "),
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

  Widget noDataView() {
    return Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  //**************************************************************
  // Methods for Home page
  //***************************************************************
  Widget homeWidget(ResponseHome snapshot) {
    return SmartRefresher(
        //key: _refreshIndicatorKey,
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _refreshStockPrices,
        child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                color: Colors.colorlightgreyback,
                child: Stack(children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 2 / 1,
                        child: showTopPager(snapshot.banners),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Image.asset('assets/ribbon.png'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "CATEGORIES",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 122,
                              child: showCategories(snapshot.categories)),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Image.asset('assets/ribbon.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              "OFFERS & PROMOTIONS",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
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
                          Container(
                            height: 4,
                            child: Text(""),
                          ),
                          AspectRatio(
                            aspectRatio: 2 / 1,
                            //child: showTopPagerOffer(snapshot.offerBanners),
                            child: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, position) {
                                    return Padding(
                                      padding: EdgeInsets.all(1),
                                      child: GestureDetector(
                                        onTap: () {
                                          Category cat = Category.init(
                                              snapshot.offerBanners[position]);
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  duration:
                                                      Duration(microseconds: 1),
                                                  child: ShowCategoryDetailPage(
                                                      subCategory: cat))
//                                            new MaterialPageRoute(
//                                              builder: (context) =>
//                                                  ShowCategoryDetailPage(
//                                                      subCategory: cat),
//                                            ),
                                              );
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          ),
                                          child: Container(
                                            // height: 200,

                                            //decoration: myBoxDecoration(),
                                            //       <--- BoxDecoration here
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  child: AspectRatio(
                                                    aspectRatio: 1.7 / 1,
                                                    child: Image.network(
                                                      snapshot
                                                          .offerBanners[
                                                              position]
                                                          .image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  flex: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.offerBanners.length,
                                )),
                          ),
                          Container(
                            height: 4,
                            child: Text(""),
                          ),
                          Container(
                              child: productsCategories(snapshot.sections)),
                          Container(
                            child: Center(
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  crossAxisAlignment:
//                                      CrossAxisAlignment.baseline,
//                                  textBaseline: TextBaseline.alphabetic,
//                                  children: <Widget>[
                              child: Image.asset(
                                "assets/refer.png",
                                height: 120,
                                width: 120,
                              ),
//                                  ],
//                                ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 8, right: 8, bottom: 16),
                            child: Center(
                              child: Text(
                                'You can refer your friends and earn bonus credits when they join using your referral code.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.colorgreen,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 32, top: 8, right: 32, bottom: 16),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (profile != null) {
//                                    WcFlutterShare.share(
//                                        sharePopupTitle: 'Share',
//                                        subject: 'This is subject',
//                                        text: 'This is text',
//                                        mimeType: 'text/plain');
//                                    Share.share(
//                                        'Hey! Use referral code <$codee> to join NFresh and earn bonus credits. Visit https://nfreshonline.com/ to join now.');
//

//                                    Share.text(
//                                        'my text title',
//                                        'This is my text to share with other applications.',
//                                        'text/plain');
//                                    if (Platform.isIOS) {
//                                       } else {
//                                      Share.share(
//                                          'Hey! Use referral code <$codee> to join NFresh and earn bonus credits. Visit https://nfreshonline.com/ to join now.');
//                                    }
                                    Share.share(
                                        ('Hey! Use referral code <$codee> to join NFresh and earn bonus credits. Visit https://nfreshonline.com/ to join now.'));

//                                    final RenderBox box =
//                                        context.findRenderObject();
//                                    Share.plainText(
//                                      text:
//                                          "Hey!",
//                                    ).share(
//                                        sharePositionOrigin:
//                                            box.localToGlobal(Offset.zero) &
//                                                box.size);
                                  } else {
                                    goToLogin();
                                    // showAlertMessage(context);
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(100.0)),
                                      color: Colors.colorgreen),
                                  child: Center(
                                    child: new Text("Share now",
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ]))));
  }

  Widget showTopPager(List<BannerModel> banners) {
    return PageIndicatorContainer(
      pageView: new PageView.builder(
        controller: _pageController,
        // physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Category cat = Category.init(banners[index]);

              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) =>
                      ShowCategoryDetailPage(subCategory: cat),
                ),
              );
            },
            child: Container(
              child: Image.network(
                banners[index].image,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        // controller: controller,
        itemCount: banners.length,
      ),
      align: IndicatorAlign.bottom,
      length: banners.length,
      indicatorSpace: 8.0,
      padding: const EdgeInsets.all(8),
      indicatorColor: Colors.grey,
      indicatorSelectorColor: Colors.green,
      shape: IndicatorShape.circle(size: 8),
    );
  }

  Widget showTopPagerOffer(List<BannerModel> banners) {
    return new PageIndicatorContainer(
      pageView: new PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _pageControllerOffers,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Image.network(
              banners[index].image,
              fit: BoxFit.cover,
            ),
          );
        },
        // controller: controller,
        itemCount: banners.length,
      ),
      align: IndicatorAlign.bottom,
      length: banners.length,
      indicatorSpace: 8.0,
      padding: const EdgeInsets.all(8),
      indicatorColor: Colors.grey,
      indicatorSelectorColor: Colors.green,
      shape: IndicatorShape.circle(size: 8),
    );
  }

  showCategories(List<Category> categories) {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Padding(
              padding: EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => CategoryDetails(
                                  selectedCategory: categories[position])))
                      .then((value) {
                    Utils.checkInternet().then((connected) {
                      if (connected != null && connected) {
                        blocFavGet.fetchFavData();

                        setState(() {
                          network = true;
                        });
                      } else {
                        setState(() {
                          showLoader = false;
                        });
                        Toast.show("Not connected to internet", context,
                            duration: 6, gravity: Toast.BOTTOM);
                      }
                    });

                    onCartUpdate();
                    updateProducts();
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,

                    //decoration: myBoxDecoration(),
                    //       <--- BoxDecoration here
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: AspectRatio(
                            aspectRatio: 1.3 / 1,
                            child: Image.network(
                              categories[position].icon,
                              fit: BoxFit.fill,
                            ),
                          ),
                          flex: 3,
                        ),
                        Flexible(
                          child: Center(
                            child: position == 0
                                ? Text(
                                    categories[position].name,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.colorgreen),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    categories[position].name,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.colorgreen),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: categories.length,
        ));
  }

  showProductsCategories(List<Product> products, name, id) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 8),
        child: Row(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, position) {
                var product = products[position];
                return Material(
                  color: Colors.colorlightgreyback,
                  child: product == null
                      ? Text('')
                      : Padding(
                          padding: EdgeInsets.all(0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 0, left: 0, top: 0),
                                    child: Container(
                                      width: 178,
                                      //color: Colors.green,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          1 < 0
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (profile == null) {
                                                        showAlertMessage(
                                                            context);
                                                      } else {
                                                        if (product.fav ==
                                                            "1") {
                                                          product.fav = "0";
                                                        } else {
                                                          product.fav = "1";
                                                        }
                                                        Utils.checkInternet()
                                                            .then((connected) {
                                                          if (connected !=
                                                                  null &&
                                                              connected) {
                                                            blocFav.fetchData(
                                                                product.fav,
                                                                product.id
                                                                    .toString());
                                                            setState(() {
                                                              network = true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              network = false;
                                                              showLoader =
                                                                  false;
                                                            });
                                                            Toast.show(
                                                                "Not connected to internet",
                                                                context,
                                                                duration: 6,
                                                                gravity: Toast
                                                                    .BOTTOM);
                                                          }
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    // color: Colors.mygrey,
                                                    padding: EdgeInsets.only(
                                                        bottom: 8,
                                                        right: 30,
                                                        top: 8,
                                                        left: 8),
                                                    child: product != null &&
                                                            product.fav == "1"
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
                                                  ))
                                              : Container(
                                                  height: 30,
                                                ),
                                          products[position]
                                                      .selectedPacking
                                                      .displayPrice >
                                                  0
                                              ? Container(
                                                  // color: Colors.mygrey,
                                                  padding: EdgeInsets.only(
                                                    right: 10,
                                                  ),
                                                  child: Text(
                                                    getOff(products[position]),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.colororange,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  duration:
                                                      Duration(microseconds: 1),
                                                  child: ProductDetailPage(
                                                      product: product))
//                                      MaterialPageRoute(
//                                        builder: (context) => ProductDetailPage(
//                                          product: product,
//                                        ),
//                                      )
                                              )
                                          .then((value) {
                                        onCartUpdate();
                                        updateProducts();
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
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 0),
                                          child: Text(
                                            products[position].nameHindi,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.colorlightgrey),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "₹" +
                                                      product
                                                          .selectedPacking.price
                                                          .toString() +
                                                      "  ",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.colorlightgrey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                products[position]
                                                            .selectedPacking
                                                            .displayPrice >
                                                        0
                                                    ? Text(
                                                        "₹" +
                                                            products[position]
                                                                .selectedPacking
                                                                .displayPrice
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .colororange,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                        textAlign:
                                                            TextAlign.center,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 35,
                                          width: 130,
                                          decoration: myBoxDecoration3(),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 6, left: 6),
                                              child: DropdownButtonFormField<
                                                  Packing>(
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: product
                                                            .selectedPacking
                                                            .unitQtyShow),
                                                // value: product.selectedPacking,
                                                value: null,
                                                items: product
                                                    .packing //getQtyList(products[position])
                                                    .map((Packing value) {
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
                                                      children: <Widget>[
                                                        new Text(
                                                          value.unitQtyShow,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        new Text(
                                                          "₹" +
                                                              value.price
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    products[position]
                                                            .selectedPacking =
                                                        newValue;
                                                    product.count = 0;
                                                    product.selectedDisplayPrice =
                                                        getCalculatedPrice(
                                                            product);
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
                                        right: 8, left: 8, top: 16),
                                    child: Container(
                                      width: 150,
                                      //color: Colors.grey,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                                      setState(() {
                                                        decrementCount(
                                                            products[position]);
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 17),
                                                      // color: Colors.white,
                                                      child: Container(
                                                        decoration:
                                                            myBoxDecoration2(),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 8, 0),
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
                                                        left: 6,
                                                        right: 6,
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
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        incrementCount(
                                                            products[position]);
                                                      });
                                                    },
                                                    child: Container(
                                                      //  color: Colors.white,
                                                      padding: EdgeInsets.only(
                                                          right: 17),
                                                      child: Container(
                                                        decoration:
                                                            myBoxDecoration2(),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
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
//                  ),
                              ),
                            ),
                          ),
                        ),
                );
              },
              itemCount: products.length,
            ),
            viewMoreSection(name, id),
          ],
        ));
  }

  Widget viewMoreSection(name, id) {
    Category category = new Category.fromName(name, id);
    category.icon = "ii";
    return Container(
      height: 335,
      width: 120,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          // view more action here
          Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          ShowCategoryDetailPage(subCategory: category)))
              .then((value) {
            onCartUpdate();
            updateProducts();
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child:
                  Icon(Icons.arrow_forward), //Image.asset("assets/cart.png"),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              width: 60,
            ),
            Container(
              height: 8,
            ),
            Text(
              "View All",
              style: TextStyle(color: Colors.colorgreen),
            )
          ],
        ),
      ),
    );
  }

  Widget productsCategories(List<Section> sections) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      //physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, position) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/ribbon.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        sections[position].title.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 335,
                child: showProductsCategories(sections[position].products,
                    sections[position].title, sections[position].id)),
          ],
//              ),
        );
      },
      itemCount: sections.length,
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.colorlightgrey),
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

  void incrementCount(Product product) {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
      _database.update(product);
      Future.delayed(const Duration(milliseconds: 500), () {
        onCartUpdate();
        // updateProducts();
      });
    } else {
      Toast.show(
          "Current available quantity is " + product.inventory.toString(),
          context,
          duration: 6,
          gravity: Toast.BOTTOM);
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
      onCartUpdate();
      //updateProducts();
    });
  }

  List<String> getQtyList(Product product) {
    List<String> qtyList = [];
    for (int i = 0; i < product.packing.length; i++) {
      qtyList.add(product.packing[i].unitQtyShow);
    }
    return qtyList;
  }

  String getProductCount(product) {
    _database.queryConditionalProduct(product).then((onValue) {
      setState(() {
        product = onValue;
      });
    });
    return "0";
  }

  void updateUI() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {});
    });
  }

  // calculate the offer percentage
  String getOff(Product product) {
    var salePrice = product.selectedPacking.price;
    var costPrice = product.selectedPacking.displayPrice;
    var profit = costPrice - salePrice;
    var offer = (profit / costPrice) * 100;
    if (costPrice == 0) {
      return "";
    }
    return "${offer.round()}% off";
  }

  double getCalculatedPrice(Product product) {
    return (product.selectedPacking.displayPrice).toDouble();
  }

//**************************************************************
// Methods for Wish List page
//***************************************************************

  Widget wishListWidget() {
//
    return Container(
        color: Colors.white,
        child: showLoaderFav
            ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Center(child: CircularProgressIndicator())],
              )
            : bodyViewFav()

        /*child: StreamBuilder(
        stream: bloc.favList,
        builder: (context, AsyncSnapshot<ResponseGetFav> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.products.length > 0 ? mainContent(snapshot) : noDataViewFav();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[Center(child: CircularProgressIndicator())],
          );
        },
      ),*/
        );
  }

  Widget bodyViewFav() {
    return favResponse.products != null && favResponse.products.length > 0
        ? mainContent(favResponse.products)
        : noDataViewFav();
  }

  Widget mainContent(List<Product> products) {
    return Stack(children: <Widget>[
      Container(
        padding: EdgeInsets.only(bottom: 42),
        child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            var product = products[position];
            return getListItem(position, product, products);
          },
          itemCount: products.length,
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: GestureDetector(
              onTap: () {
                Utils.checkInternet().then((connected) {
                  if (connected != null && connected) {
                    showMessageFav2(context, products);
                  } else {
                    Toast.show("Not connected to internet", context,
                        duration: 6, gravity: Toast.BOTTOM);
                  }
                });
              },
              child: Container(
                height: 40.0,
                width: double.infinity,
                color: Colors.colorgreen,
                child: Center(
                  child: Text(
                    "Clear Wishlist",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ),
      ),
    ]);
  }

  Widget getListItem(position, Product product, List<Product> products) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(8.0),
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
                                      // goToProductDetail(product);
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
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: GestureDetector(
                                onTap: () {
                                  // goToProductDetail(product);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                            fontSize: 16,
                                            color: Colors.colorlightgrey),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '₹ ${product.selectedPacking.price}  ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.colorlightgrey,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.start,
                                            ),
                                            product.selectedPacking
                                                        .displayPrice >
                                                    0
                                                ? Text(
                                                    '₹${product.selectedPacking.displayPrice}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.colororange,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                    textAlign: TextAlign.start,
                                                  )
                                                : Container(),
                                          ]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: 32,
                                            width: 115,
                                            decoration: myBoxDecoration3(),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 8, left: 8),
                                                child: DropdownButtonFormField<
                                                    Packing>(
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                          hintText: product
                                                              .selectedPacking
                                                              .unitQtyShow),
                                                  value: null,
                                                  items: product.packing
                                                      .map((Packing value) {
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
                                                        children: <Widget>[
                                                          new Text(
                                                            value.unitQtyShow,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          new Text(
                                                            "₹" +
                                                                value.price
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
                                                      product.count = 0;
                                                      product.selectedDisplayPrice =
                                                          getCalculatedPrice(
                                                              product);
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
                          ),
                        ],
                      ),
                    ),
                    flex: 2,
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Utils.checkInternet().then((connected) {
                                if (connected != null && connected) {
                                  showMessageFav(
                                      context, product, products, position);
                                } else {
                                  Toast.show(
                                      "Not connected to internet", context,
                                      duration: 6, gravity: Toast.BOTTOM);
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 16, right: 8),
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
                                EdgeInsets.only(right: 0, left: 0, top: 16),
                            child: Container(
                              // width: 120,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: IntrinsicHeight(
                                  // child: Center(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            decrementCount(product);
                                          },
                                          child: Container(
                                            // padding: EdgeInsets.only(left: 20),
                                            // color: Colors.white,
                                            child: Container(
                                              decoration: myBoxDecoration2(),
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
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
                                              left: 8,
                                              right: 8,
                                              top: 4,
                                              bottom: 4),
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
                                            incrementCount(product);
                                          },
                                          child: Container(
                                            //  color: Colors.white,
                                            // padding: EdgeInsets.only(right: 20),
                                            child: Container(
                                              decoration: myBoxDecoration2(),
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
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
                                  //  ),
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
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          )
        ]);
  }

  Widget noDataViewFav() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Image.asset('assets/noproduct.png'),
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
              "No products in your wishlist",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void showMessageFav(context, product, List<Product> products, int position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(
              "Would you like to remove this product from your Wishlist?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Utils.checkInternet().then((connected) {
                  if (connected != null && connected) {
                    blocFav.fetchData("0", product.id.toString());
                    setState(() {
                      products.removeAt(position);
                    });
                    setState(() {
                      network = true;
                    });
                  } else {
                    setState(() {
                      showLoader = false;
                    });
                    Toast.show("Not connected to internet", context,
                        duration: 6, gravity: Toast.BOTTOM);
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

  void showMessageFav2(context, List<Product> products) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(
              "Would you like to remove all the products from your Wishlist?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Utils.checkInternet().then((connected) {
                  if (connected != null && connected) {
                    for (int i = 0; i < products.length; i++) {
                      blocFav.fetchData("0", products[i].id.toString());
                    }
                    setState(() {
                      products.clear();
                    });
                    setState(() {
                      network = true;
                    });
                  } else {
                    setState(() {
                      network = false;
                      showLoader = false;
                    });
                    Toast.show("Not connected to internet", context,
                        duration: 6, gravity: Toast.BOTTOM);
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

  //**************************************************************
// Methods for Search page
//***************************************************************
  searchViewWidget() {
    //updateSearchProducts2();
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  //  filterSearchResults(value);
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    blocSearch.fetchSearchData(value.trim());
                  });
                },
                controller: editingController,
                decoration: InputDecoration(
//                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)))),
              ),
            ),
            showLoaderSearch
                ? Center(
                    child: Text("Search to display products"),
                  )
                : mainContentSearch(responseSearch)
            /*StreamBuilder(
              stream: bloc.searchedData,
              builder: (context, AsyncSnapshot<ResponseSearch> snapshot) {
                if (snapshot.hasData) {
                  return mainContent(snapshot);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(
                  child: Text("Search to display products"),
                );
              },
            )*/
          ],
        ),
      ),
    );
  }

  Widget mainContentSearch(ResponseSearch responseSearch) {
    return Expanded(
      child: responseSearch.products.length > 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
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
                        child: Image.asset(
                          gridImage,
                          height: 20,
                          width: 20,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.black,
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
                        child: Image.asset(listImage, height: 20, width: 20),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.black,
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
                                        responseSearch.products.sort(
                                            (a, b) => a.name.compareTo(b.name));
                                        print(responseSearch.products);
                                      } else {
                                        responseSearch.products.sort(
                                            (a, b) => a.name.compareTo(b.name));
                                        responseSearch.products = responseSearch
                                            .products.reversed
                                            .toList();
                                        print(responseSearch.products);
                                      }
                                    });
                                  });
                                }));
                          },
                          child: Image.asset('assets/sort.png',
                              height: 20, width: 20)),
                    ],
                  ),
                ),
                viewList
                    ? Expanded(
                        child: showListView(responseSearch.products),
                      )
                    : Container(),
                viewGrid ? showGridView(responseSearch.products) : Container(),
              ],
            )
          : Container(
              child: Center(
                child: Text(
                  "No Data",
                  style: TextStyle(
                      color: Colors.colorgreen,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  showListView(List<Product> products) {
    mainProduct = products;
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, position) {
        var product = mainProduct[position];
        return Padding(
          padding: EdgeInsets.only(top: 4),
          child: getListItemSearch(position, product),
        );
      },
      itemCount: products.length,
    );
  }

  Widget getListItemSearch(position, Product product) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(8.0),
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
//                      alignment: Alignment.topRight,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: <Widget>[
//                          GestureDetector(
//                            onTap: () {
//                              goToProductDetail(product);
//                            },
//                            child: Container(
//                              child: Align(
//                                alignment: Alignment.bottomRight,
//                                child: Icon(
//                                  Icons.chevron_right,
//                                ),
//                              ),
//                            ),
//                          ),
//                          Padding(
//                            padding:
//                                EdgeInsets.only(right: 0, left: 0, top: 16),
//                            child: Container(
//                              // width: 120,
//                              alignment: Alignment.centerRight,
//                              child: Padding(
//                                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
//                                child: IntrinsicHeight(
//                                  // child: Center(
//                                  child: IntrinsicHeight(
//                                    child: Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.stretch,
//                                      mainAxisAlignment: MainAxisAlignment.end,
//                                      children: <Widget>[
//                                        GestureDetector(
//                                          onTap: () {
//                                            decrementCount(product);
//                                          },
//                                          child: Container(
//                                            // padding: EdgeInsets.only(left: 20),
//                                            // color: Colors.white,
//                                            child: Container(
//                                              decoration: myBoxDecoration2(),
//                                              padding: EdgeInsets.fromLTRB(
//                                                  10, 0, 10, 0),
//                                              child: Image.asset(
//                                                'assets/minus.png',
//                                                height: 10,
//                                                width: 10,
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                        Container(
//                                          margin: EdgeInsets.only(
//                                              left: 8,
//                                              right: 8,
//                                              top: 4,
//                                              bottom: 4),
//                                          child: Center(
//                                            child: Text(
//                                              product.count.toString(),
//                                              style: TextStyle(
//                                                  color: Colors.colorgreen,
//                                                  fontWeight: FontWeight.bold,
//                                                  fontSize: 20),
//                                              textAlign: TextAlign.center,
//                                            ),
//                                          ),
//                                        ),
//                                        GestureDetector(
//                                          onTap: () {
//                                            incrementCount(product);
//                                          },
//                                          child: Container(
//                                            //  color: Colors.white,
//                                            // padding: EdgeInsets.only(right: 20),
//                                            child: Container(
//                                              decoration: myBoxDecoration2(),
//                                              padding: EdgeInsets.fromLTRB(
//                                                  10, 0, 10, 0),
//                                              child: Image.asset(
//                                                'assets/plus.png',
//                                                height: 10,
//                                                width: 10,
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  //  ),
//                                ),
//                              ),
//                            ),
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
    var size = MediaQuery.of(context).size;
    double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemHeight = itemHeight;
    double itemWidth = size.width / 2;
    itemWidth = itemWidth;

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
      ),
    );
  }

  girdViewItem(int index, BuildContext context, List<Product> products) {
    mainProduct = products;
    var product = mainProduct[index];
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
                        width: 130,
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
                                        MainAxisAlignment.spaceBetween,
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

  void goToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product: product,
        ),
      ),
    ).then((value) {
      blocFavGet.fetchFavData();
      getCartCount();
      updateSearchProducts();
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

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iosPermission();
    _firebaseMessaging.getToken().then((token) {
      // print("FBase Token:  $token");
      if (token != null) {
        setState(() {
          mToken = token;
        });
      }
      Utils.checkInternet().then((connected) {
        if (connected != null && connected) {
          bloc.fetchHomeData(mToken);

          setState(() {
            network = true;
          });
        } else {
          setState(() {
            network = false;
            showLoader = false;
          });
          Toast.show("Not connected to internet", context,
              duration: 6, gravity: Toast.BOTTOM);
        }
      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        var json = message['notification']['body'];
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => NotificationPage()),
//        );
        Toast.show(json.toString(), context,
            duration: 6, gravity: Toast.BOTTOM);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => NotificationPage()),
//        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => NotificationPage()),
//        );
      },
    );

    _firebaseMessaging.subscribeToTopic("admin");
  }

  void iosPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

//mailto:smith@example.org?subject=News&body=New%20Flutter%20plugin
  void openEmailComposer() async {
    var url = "";
    if (Platform.isIOS) {
      url = 'mailto:support@nfreshonline.com?subject=Get%20in%20touch&body=';
    } else {
      url = 'mailto:support@nfreshonline.com?subject=Get in touch&body=';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _refreshStockPrices() async {
    List<Product> productss = List();
    productss = await _database.queryAllProducts();
    Utils.checkInternet().then((connected) {
      if (connected != null && connected) {
        bloc.fetchHomeData(mToken);
        bloc.homeData.listen((response) {
          setState(() {
            homeResponse = response;
          });

          for (int i = 0; i < homeResponse.sections.length; i++) {
            // var products = snapshot.sections[i].products;
            for (int j = 0; j < homeResponse.sections[i].products.length; j++) {
//              var product =  _database
//                  .queryConditionalProduct(homeResponse.sections[i].products[j]);
              for (int k = 0; k < productss.length; k++) {
                if (homeResponse.sections[i].products[j].id ==
                    productss[k].id) {
//                product.selectedDisplayPrice = getCalculatedPrice(product);
                  setState(() {
                    homeResponse.sections[i].products[j].count =
                        productss[k].count;
                    _database
                        .updateQuantity(homeResponse.sections[i].products[j]);
                    //homeResponse.sections[i].products[j] = product;
                  });
                }
              }
            }
          }
          // initPlatformState();
          //blocFavGet.fetchFavData();
          //favObserver();
          updateProducts();
//      _refreshController.refreshCompleted();
//      _refreshController.loadComplete();
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
        });
      } else {
        setState(() {
          showLoader = false;
        });
        Toast.show("Not connected to internet", context,
            duration: 6, gravity: Toast.BOTTOM);
      }
    });
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

  Future removePromoFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('promoApplies', "");
    await prefs.setString('couponCode', "");
    await prefs.setInt('discount', 0);
    await prefs.setString('walletBal', "");
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true), () async {
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received');
      setState(() {});
      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish();
    }).then((int status) async {
      print('[BackgroundFetch] SUCCESS: $status');
      //setState(() {
      for (int i = 0; i < homeResponse.sections.length; i++) {
        // var products = snapshot.sections[i].products;
        for (int j = 0; j < homeResponse.sections[i].products.length; j++) {
          var product = await _database
              .queryConditionalProduct(homeResponse.sections[i].products[j]);
          if (product != null) {
            product.selectedDisplayPrice = getCalculatedPrice(product);
            setState(() {
              homeResponse.sections[i].products[j] = product;
            });
          } else {
            setState(() {
              homeResponse.sections[i].products[j].count = 0;
            });
          }
        }
      }
      setState(() {
        showLoader = false;
      });
//      updateProducts().then((value) {
//        print('[BackgroundFetch] Event received');
//      });
      //favObserver();
      //});
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
      setState(() {
        //_status = e;
      });
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    setState(() {
      //  _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }
}

class DrawerList {
  String name;
  String image;
}
