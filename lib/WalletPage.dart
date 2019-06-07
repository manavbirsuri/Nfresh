import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: stateProfile(),
    );
  }
}

class stateProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return stateProfilePage();
  }
}

class stateProfilePage extends State<stateProfile> {
  var valueChecked = 0;
  var amount = "100";
  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: Image.asset(
            'assets/sigbg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
            title: new Text(
              "My Wallet",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            '90',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' CREDITS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        'available balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(''),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 90, right: 20, left: 20),
                child: Material(
                  elevation: 16.0,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18)),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          child: Text(
                                            'Select Amount to Add Credits',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.colorgreen),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  valueChecked = 0;
                                                  amount = "100";
                                                });
                                              },
                                              child: Container(
                                                child: valueChecked == 0
                                                    ? Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration3(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+100',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )
                                                    : Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration2(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+100',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .colorgreen),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  valueChecked = 1;
                                                  amount = "200";
                                                });
                                              },
                                              child: Container(
                                                child: valueChecked == 1
                                                    ? Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration3(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+200',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )
                                                    : Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration2(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+200',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .colorgreen),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  valueChecked = 2;
                                                  amount = "500";
                                                });
                                              },
                                              child: Container(
                                                child: valueChecked == 2
                                                    ? Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration3(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+500',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )
                                                    : Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration2(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+500',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .colorgreen),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  valueChecked = 3;
                                                  amount = "1000";
                                                });
                                              },
                                              child: Container(
                                                child: valueChecked == 3
                                                    ? Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration3(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+1000',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )
                                                    : Container(
                                                        height: 30,
                                                        width: 65,
                                                        decoration:
                                                            myBoxDecoration2(),
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        child: Text(
                                                          '+1000',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .colorgreen),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                          ),
                                        ),
//                                    Container(
//                                      margin: EdgeInsets.only(top: 16),
//                                      child: Text(
//                                        'Enter Amount',
//                                        style: TextStyle(
//                                            fontSize: 12, color: Colors.black),
//                                      ),
//                                    ),
//                                    Container(
//                                      margin: EdgeInsets.only(top: 16),
//                                      child: TextFormField(
//                                        textInputAction: TextInputAction.next,
//                                        autofocus: true,
//                                        decoration: InputDecoration(
//                                          labelText: 'Enter Amount',
//                                        ),
////                                        onFieldSubmitted: (v) {
////                                          FocusScope.of(context)
////                                              .requestFocus(focus);
////                                        },
//                                      ),
//                                    ),
//                                    Container(
//                                      margin: EdgeInsets.only(top: 16),
//                                      child: Divider(
//                                        color: Colors.grey,
//                                        height: 1,
//                                      ),
//                                    ),

                                        Padding(
                                          padding: EdgeInsets.all(36),
                                          child: Container(
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Center(
                                                          child: Text(
                                                            'You will get',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 0),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .baseline,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        children: <Widget>[
                                                          Text(
                                                            amount,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .colorgreen,
                                                                fontSize: 36,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            ' CREDITS',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .colorgreen,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
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
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(32, 8, 32, 16),
                                child: GestureDetector(
                                  onTap: () {
//                              Navigator.push(
//                                context,
//                                new MaterialPageRoute(
//                                    builder: (context) =>
//                                    new PinViewPage()),
//                              );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(100.0)),
                                        color: Colors.colorgreen),
                                    child: Center(
                                      child: new Text("Pay Now",
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
        border: Border.all(color: Colors.colorgreen),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.green);
  }

  BoxDecoration myBoxDecoration2() {
    return BoxDecoration(
        border: Border.all(color: Colors.colorgreen),
        borderRadius: BorderRadius.all(Radius.circular(8)));
  }
}
