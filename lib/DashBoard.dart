import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/models/responses/response_home.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/CategoryDetails.dart';
import 'package:nfresh/ui/OffersPage.dart';
import 'package:nfresh/ui/OrderHistory.dart';
import 'package:nfresh/ui/ProductDetailPage.dart';
import 'package:nfresh/ui/Profile.dart';
import 'package:nfresh/ui/SearchPage.dart';
import 'package:nfresh/ui/WalletPage.dart';
import 'package:nfresh/ui/cart.dart';
import 'package:nfresh/ui/login.dart';
import 'package:nfresh/ui/notifications.dart';
import 'package:page_indicator/page_indicator.dart';

import 'bloc/get_fav_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/set_fav_bloc.dart';
import 'count_listener.dart';
import 'models/banner_model.dart';
import 'models/category_model.dart';
import 'models/packing_model.dart';
import 'models/product_model.dart';
import 'models/responses/response_getFavorite.dart';
import 'models/section_model.dart';

void main() => runApp(MyApp());

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
  String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _curIndex = 0;
  var bloc = HomeBloc();
  var blocProfile = ProfileBloc();
  var blocFav = SetFavBloc();
  var blocFavGet = GetFavBloc();
  var _pageController = new PageController();
  var _pageControllerOffers = new PageController();
  var _prefs = SharedPrefs();
  var _database = DatabaseHelper.instance;
  var showLoader = true;
  var showLoaderFav = true;

  int _count = 0;
  ProfileModel profile;
  ResponseHome homeResponse;
  ResponseGetFav favResponse;

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
    bloc.fetchHomeData();
    bloc.homeData.listen((response) {
      homeResponse = response;
      setState(() {
        showLoader = false;
      });
      blocProfile.fetchData();
      profileObserver();

      blocFavGet.fetchFavData();
      favObserver();
    });
    getCartCount();
  }

  Future updateProducts() async {
    for (int i = 0; i < homeResponse.sections.length; i++) {
      // var products = snapshot.sections[i].products;
      for (int j = 0; j < homeResponse.sections[i].products.length; j++) {
        var product = await _database.queryConditionalProduct(homeResponse.sections[i].products[j]);
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
  }

  Future updateFavProducts() async {
    if (favResponse != null && favResponse.products != null && favResponse.products.length > 0) {
      for (int i = 0; i < favResponse.products.length; i++) {
        var product = await _database.queryConditionalProduct(favResponse.products[i]);
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

  void favObserver() {
    blocFavGet.favList.listen((resFav) {
      setState(() {
        showLoaderFav = false;
      });
      favResponse = resFav;
      updateFavProducts();
    });
  }

  void profileObserver() {
    blocProfile.profileData.listen((res) {
      print("Profile Status = " + res.status);
      if (res.status == "true") {
        String profileData = jsonEncode(res.profile);
        _prefs.getProfile().then((modelProfile) {
          if (modelProfile == null && res.profile.type != 1) {
            _database.clearCart();
            showMessage(context);
            getCartCount();
          }
          _prefs.saveProfile(profileData);
          // getProfileDetail();
          setState(() {
            profile = res.profile;
          });
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
  void changeTabs(int tabIndex) {
    setState(() {
      _curIndex = tabIndex;
      _selectedDrawerIndex = tabIndex;
    });
  }

  _getDrawerItemWidget(int pos, ResponseHome snapshot) {
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
//                ),
              )
            ],
          ),
        );
      // return new HomePage(data: snapshot, listener: this);
      case 1:
        // blocFavGet.fetchFavData();
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
        return new SearchPage(listener: this);
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
          'WishList',
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
        // color: Colors.white,
        child: showLoader
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : bodyContent(homeResponse),
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
    String status = snapshot.status;
    return status == "true"
        ? Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.colorgreen.withOpacity(0.0),
              title: _getTitle(_selectedDrawerIndex),
              centerTitle: true,
              leading: IconButton(
                  icon: new Image.asset(
                    'assets/setting.png',
                    width: 25,
                    height: 25,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsPage(),
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
                      getCartCount();
                      updateProducts();
                      updateFavProducts();
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
                          image:
                              DecorationImage(image: AssetImage('assets/bg.jpg'), fit: BoxFit.fill),
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
                                    builder: (context) =>
                                        profile == null ? LoginPage() : new Profile(),
                                  ));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(12),
                                  padding: EdgeInsets.all(5),
                                  height: 80,
                                  width: 80,
                                  color: Colors.white,
                                  child: Image.asset(
                                    'assets/logo.png',
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      profile == null ? "No name" : profile.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      profile == null ? "Please login" : profile.email,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: profile == null ? Colors.grey : Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
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
                                changeTabs(2);
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
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => WalletPage()));
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
                                changeTabs(1);
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderHistory(),
                                    )).then((onValue) {
                                  getCartCount();
                                });
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
                                          builder: (context) => LoginPage(),
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
                                      _prefs.saveProfile("");
                                      setState(() {
                                        profile = null;
                                      });
                                    },
                                  )
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
                  fontSize: 10, color: _curIndex == 0 ? Colors.colorgreen : Colors.black38),
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
                  fontSize: 10, color: _curIndex == 1 ? Colors.colorgreen : Colors.black38),
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
                  fontSize: 10, color: _curIndex == 2 ? Colors.colorgreen : Colors.black38),
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
                  fontSize: 10, color: _curIndex == 3 ? Colors.colorgreen : Colors.black38),
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
          print("GGGGGGGGG  " + index.toString());
          if (index == 1) {
            blocFavGet.fetchFavData();
          }

          setState(() {
            _selectedDrawerIndex = index;
            _curIndex = index;
            switch (_curIndex) {
              case 0:
                _getDrawerItemWidget(0, snapshot);
                break;
              case 1:
                _getDrawerItemWidget(1, snapshot);
                break;
              case 2:
                _getDrawerItemWidget(2, snapshot);
                break;
              case 3:
                _getDrawerItemWidget(3, snapshot);
                break;
            }
          });
        },
      ));

  void showMessage(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text(
              "You logged in as a non customer account. So if there is any pruduct added into card brfore login will be removed."),
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
      child: Center(
        child: Text("No Data"),
      ),
    );
  }

  //**************************************************************
  // Methods for Home page
  //***************************************************************
  Widget homeWidget(ResponseHome snapshot) {
    return SingleChildScrollView(
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
                      Container(height: 122, child: showCategories(snapshot.categories)),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
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
                          ],
                        ),
                      ),
                      Container(
                        height: 12,
                        child: Text(""),
                      ),
                      AspectRatio(
                        aspectRatio: 2 / 1,
                        child: showTopPagerOffer(snapshot.offerBanners),
                      ),
                      Container(
                        height: 4,
                        child: Text(""),
                      ),
                      Container(child: productsCategories(snapshot.sections)),
                    ],
                  ),
                  //),
                ],
              )
            ])));
  }

  Widget showTopPager(List<BannerModel> banners) {
    return PageIndicatorContainer(
      pageView: new PageView.builder(
        controller: _pageController,
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

  Widget showTopPagerOffer(List<BannerModel> banners) {
    return new PageIndicatorContainer(
      pageView: new PageView.builder(
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
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Padding(
              padding: EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  CategoryDetails(selectedCategory: categories[position])))
                      .then((value) {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Image.network(
                            categories[position].image,
                            //list[position].image,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          flex: 2,
                        ),
                        Flexible(
                          child: Center(
                            child: position == 0
                                ? Text(
                                    categories[position].name,
                                    style: TextStyle(fontSize: 14, color: Colors.colorlightgrey),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    categories[position].name,
                                    style: TextStyle(fontSize: 14, color: Colors.colorgreen),
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

  showProductsCategories(List<Product> products) {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            var product = products[position];
            return Material(
              color: Colors.colorlightgreyback,
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
                                              if (product.fav == "1") {
                                                product.fav = "0";
                                              } else {
                                                product.fav = "1";
                                              }

                                              blocFav.fetchData(product.fav, product.id.toString());
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.mygrey,
                                            padding: EdgeInsets.only(
                                                bottom: 8, right: 30, top: 8, left: 8),
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
                                      Text(
                                        getOff(product),
                                        style: TextStyle(
                                          fontSize: 14,
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(
                                              product: product,
                                            ),
                                      )).then((value) {
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
                                            Text(
                                              "₹" + product.selectedDisplayPrice.toString(),
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
                                                  setState(() {
                                                    decrementCount(products[position]);
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
          },
          itemCount: products.length,
        ));
  }

  Widget productsCategories(List<Section> sections) {
    return Padding(
        padding: EdgeInsets.only(top: 0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                            sections[position].title,
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
                Container(height: 335, child: showProductsCategories(sections[position].products)),
              ],
//              ),
            );
          },
          itemCount: sections.length,
        ));
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
      onCartUpdate();
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
    var costPrice = product.selectedDisplayPrice;
    var profit = costPrice - salePrice;
    var offer = (profit / costPrice) * 100;
    if (costPrice == 0) {
      return "";
    }
    return "${offer.round()}% off";
  }

  double getCalculatedPrice(Product product) {
    return (product.selectedPacking.unitQty * product.displayPrice);
  }

//**************************************************************
// Methods for Wish List page
//***************************************************************

  Widget wishListWidget() {
    return Container(
        color: Colors.white,
        child: showLoaderFav
            ? Column(
                mainAxisSize: MainAxisSize.max,
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
    return Container(
        padding: EdgeInsets.only(top: 4),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, position) {
            var product = products[position];
            return getListItem(position, product, products);
          },
          itemCount: products.length,
        ));
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
                                        style:
                                            TextStyle(fontSize: 16, color: Colors.colorlightgrey),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '₹ ${product.selectedPacking.price}  ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.colorlightgrey,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              '₹${product.selectedDisplayPrice}',
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
                                                child: DropdownButtonFormField<Packing>(
                                                  decoration: InputDecoration.collapsed(
                                                      hintText:
                                                          product.selectedPacking.unitQtyShow),
                                                  value: null,
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
                              showMessageFav(context, product, products, position);
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
                            padding: EdgeInsets.only(right: 0, left: 0, top: 16),
                            child: Container(
                              // width: 120,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: IntrinsicHeight(
                                  // child: Center(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                            incrementCount(product);
                                          },
                                          child: Container(
                                            //  color: Colors.white,
                                            // padding: EdgeInsets.only(right: 20),
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

  void showMessageFav(context, product, List<Product> products, int position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert!"),
          content: new Text("Would you like to remove this product from your Wishlist?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                blocFav.fetchData("0", product.id.toString());
                setState(() {
                  products.removeAt(position);
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
}

class DrawerList {
  String name;
  String image;
}
