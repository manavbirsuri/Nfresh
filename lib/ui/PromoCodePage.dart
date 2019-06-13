import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoCodePage extends StatefulWidget {
  @override
  PromoCodeState createState() => PromoCodeState();
}

class PromoCodeState extends State<PromoCodePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
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
              title: Text('Apply Coupon'),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText: 'Enter promo code'),
                                      ),
                                      flex: 4,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          saveToPrefs();
                                          Navigator.pop(context);
                                          setState(() {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: Container(
                                                      child: DynamicDialog(),
                                                      padding: EdgeInsets.only(
                                                          top: 40, bottom: 40),
                                                    ),
                                                  );
                                                });
                                          });
                                        },
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                              color: Colors.colorgreen,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                                    child: Text(
                                      "AVAILABLE COUPONS",
                                      style: TextStyle(
                                          color: Colors.colorgreen,
                                          fontSize: 16),
                                      textAlign: TextAlign.start,
                                    )),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ))
                              ],
                            )),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, position) {
                              return getListItem(position);
                            },
                            itemCount: 3,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget getListItem(int position) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: DottedBorder(
                  color: Colors.black,
                  gap: 3,
                  strokeWidth: 1,
                  child: Text(
                    "28V9MP",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  saveToPrefs();
                  Navigator.pop(context);

                  setState(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Material(
                            type: MaterialType.transparency,
                            child: Container(
                              child: DynamicDialog(),
                              padding: EdgeInsets.only(top: 40, bottom: 40),
                            ),
                          );
                        });
                  });
                },
                child: Text(
                  'Apply',
                  style: TextStyle(
                      color: Colors.colorgreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'fgdsgdfgsdfgsdfgsdfgsdfgsdfgsdfgsdfgsdgsd',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 16),
            child: Text(
              'view details',
              style: TextStyle(color: Colors.colorgreen),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: Divider(
                color: Colors.grey,
                height: 1,
              )),
        ],
      ),
    );
  }

  saveToPrefs() async {
    print("GGGGGGGGGGGGG tttttttttt");
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
    await prefs.setString('promoApplies', "yes");
  }
}

class DynamicDialog extends StatefulWidget {
//  DynamicDialog({this.title});

//  final String title;

  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  String _title;
  var liked = false;
  String image1 = "assets/fav_filled.png";
  String image2 = "assets/ic_fav.png";
  String currentimage = "assets/ic_fav.png";

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
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Image.asset(
            "assets/donepromo.png",
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            "Promo code succefully applied.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.colorgrey,
                fontSize: 22),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40,
              width: 150,
              decoration: new BoxDecoration(
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(100.0)),
                  color: Colors.colorgreen),
              child: Center(
                child: new Text("Ok",
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
}
