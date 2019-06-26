import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/models/responses/response_home.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/ui/HomePage.dart';
import 'package:nfresh/ui/OffersPage.dart';
import 'package:nfresh/ui/OrderHistory.dart';
import 'package:nfresh/ui/Profile.dart';
import 'package:nfresh/ui/SearchPage.dart';
import 'package:nfresh/ui/WalletPage.dart';
import 'package:nfresh/ui/WishListPage.dart';
import 'package:nfresh/ui/cart.dart';
import 'package:nfresh/ui/login.dart';
import 'package:nfresh/ui/notifications.dart';

import 'bloc/home_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'count_listener.dart';

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
  var _prefs = SharedPrefs();
  var _database = DatabaseHelper.instance;

  int _count = 0;
  ProfileModel profile;

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
    blocProfile.fetchData();
    blocProfile.profileData.listen((res) {
      print("Profile Status = " + res.status);
      if (res.status == "true") {
        String profile = jsonEncode(res.profile);
        _prefs.getProfile().then((modelProfile) {
          if (modelProfile == null && res.profile.type != 1) {
            _database.clearCart();
            showMessage(context);
            getCartCount();
          }
          _prefs.saveProfile(profile);
        });
      }
    });
    getCartCount();
    Future.delayed(const Duration(milliseconds: 1000), () async {
      profile = await _prefs.getProfile();
      print("PROFILE : $profile");
    });
  }

  Future getCartCount() async {
    var count = await _database.getCartCount();
    setState(() {
      print("COUNT: $count");
      _count = count;
    });
  }

  int _selectedDrawerIndex = 0;
  void changeTabs(int tabIndex) {
    setState(() {
      _curIndex = tabIndex;
      _selectedDrawerIndex = tabIndex;
    });
  }

  _getDrawerItemWidget(int pos, AsyncSnapshot<ResponseHome> snapshot) {
    switch (pos) {
      case 0:
        return new HomePage(data: snapshot, listener: this);
      case 1:
        return new WishListPage(
          listener: this,
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
    ]);
  }

  Widget bodyContent(AsyncSnapshot<ResponseHome> snapshot) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.colorgreen.withOpacity(0.0),
        title: _getTitle(_selectedDrawerIndex),
        centerTitle: true,
        leading:
//          new Image.asset(
//            "assets/setting.png",
//            width: 2,
//            height: 2,
//          ),

            new IconButton(
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
                    image: DecorationImage(image: AssetImage('assets/bg.jpg'), fit: BoxFit.fill),
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
                              builder: (context) => profile == null ? LoginPage() : new Profile(),
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
    );
  }

  Widget _bottomNormal(int curIndex, AsyncSnapshot<ResponseHome> snapshot) => Container(
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
}

class DrawerList {
  String name;
  String image;
}
