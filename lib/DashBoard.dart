import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'OffersPage.dart';
import 'OrderHistory.dart';
import 'Profile.dart';
import 'SearchPage.dart';
import 'WalletPage.dart';
import 'WishListPage.dart';
import 'cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashBoard(),
    );
  }
}

class DashBoard extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.colorgreen, fontFamily: 'Bold'),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> {
  String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _curIndex = 0;

  _MyHomePageState(String title) {
    this.title = title;
  }

  int _selectedDrawerIndex = 0;
  void changeTabs(int tabIndex) {
    setState(() {
      _curIndex = tabIndex;
      _selectedDrawerIndex = tabIndex;
    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomePage();
      case 1:
        return new WishListPage();
      case 2:
        return new OffersPage();
      case 3:
        return new SearchPage();

      //return new LoginPage();
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
      Scaffold(
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
            Padding(
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "assets/noti.png",
                height: 25,
                width: 25,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ));
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
                          '3',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
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
        body: _getDrawerItemWidget(_selectedDrawerIndex),
        bottomNavigationBar: _bottomNormal(_curIndex),
        drawer: Drawer(
          elevation: 8,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'assets/bg.jpg',
                      fit: BoxFit.fill,
                      height: 200,
                    ),
                  ),
                  Container(
                    color: Colors.transparent.withOpacity(0.3),
                    height: 200,
                    child: Padding(
                      padding: EdgeInsets.only(top: 48, left: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new Profile(),
                              ));
                        },
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Image.asset(
                                    'assets/logo.png',
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "John Doe",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        )),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Johndoe@gmai.com",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              flex: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: <Widget>[
//                ListTile(
//                  leading: Image.asset(
//                    'assets/logo.png',
//                    width: 30.0,
//                    height: 30.0,
//                  ),
//                  title: Text(
//                    "Categories",
//                    style: TextStyle(
//                      fontSize: 18,
//                    ),
//                  ),
//                  onTap: () {
////                    Navigator.pop(context);
////                    Navigator.push(
////                        context,
////                        MaterialPageRoute(
////                          builder: (context) => new Profile(),
////                        ));
//                  },
//                ),
//                Divider(
//                  height: 1,
//                  color: Colors.grey,
//                ),
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
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new CartPage(),
                          ));
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
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalletPage()));
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
                              builder: (context) => OrderHistory()));
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
                  ListTile(
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
//                    Navigator.of(context).pop();
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => TermAndPrivacy(),
//                      ),
//                    );
                    },
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _bottomNormal(int curIndex) => Container(
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
          print("GGGGGGGGG  " + index.toString());
          setState(() {
            _selectedDrawerIndex = index;
            _curIndex = index;
            switch (_curIndex) {
              case 0:
                _getDrawerItemWidget(0);
                break;
              case 1:
                _getDrawerItemWidget(1);
                break;
              case 2:
                _getDrawerItemWidget(2);
                break;
              case 2:
                _getDrawerItemWidget(3);
                break;
            }
          });
        },
      ));
}

class DrawerList {
  String name;
  String image;
}
