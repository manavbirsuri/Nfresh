import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  ProState createState() => ProState();
}

class ProState extends State<ProductDetailPage> {
  Text totalText;
  String code;
  var selectedValues = "1";
  var incrimentedValue = 0;
  var pos = 0;
  var favImage = 'assets/fav.png';
  var liked = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Detail'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2 / 1,
                              child: Image.asset(
                                'assets/pea.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0, left: 0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (liked) {
                                      liked = false;
                                      favImage = 'assets/fav.png';
                                    } else {
                                      liked = true;
                                      favImage = 'assets/fav_filled.png';
                                    }
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Image.asset(
                                    favImage,
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
                            Text(
                              'Green Peas',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.colorgreen,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Text(
                                'हरी मटर',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.colorgrey),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '₹60.00  ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.colorlightgrey,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            '₹70.00',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.colororange,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            textAlign: TextAlign.start,
                                          ),
                                        ]),
                                    Text(
                                      '30%off',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.colororange),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      height: 35,
                                      width: 90,
                                      decoration: myBoxDecoration3(),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration:
                                                InputDecoration.collapsed(
                                                    hintText: ''),
                                            value: selectedValues,
                                            items: <String>[
                                              "1",
                                              "2",
                                              "3",
                                              "4",
                                              "5"
                                            ].map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedValues = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: 40,
                                        width: 90,
                                        decoration: myBoxDecoration2(),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 16),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (incrimentedValue >
                                                          0) {
                                                        incrimentedValue--;
                                                      }
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
                                                incrimentedValue.toString(),
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
                                                      incrimentedValue++;
                                                      print("dddddddd " +
                                                          incrimentedValue
                                                              .toString());
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
                                        )),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "DESCRIPTION",
                                      style:
                                          TextStyle(color: Colors.colorgreen),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        "DESCRIPTIONsdfjasdflasdfjalsdfjasldfjalsdfjaskldfjasdklfjalsdfjasldfjalsdfjadslfsdfjlasfjflasdjffasdnfdfsd,fh",
                                        style:
                                            TextStyle(color: Colors.colorgrey),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text(
                                        "RELATED PRODUCTS",
                                        style:
                                            TextStyle(color: Colors.colorgreen),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                height: 310, child: showProductsCategories()),
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
                height: 55,
                padding: EdgeInsets.all(4),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: GestureDetector(
                        child: Container(
                          //color: Colors.amber,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      '₹250',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                          color: Colors.colorgrey),
                                    ),
                                    Text(
                                      'Total amount',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.colorPink,
                                      ),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                flex: 1,
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
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
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
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => PlaceOrder(),
//                          ));
                        },
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ));
  }

  BoxDecoration myBoxDecoration2() {
    return BoxDecoration(
      border: Border.all(color: Colors.colorgreen, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(100)),
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

  showProductsCategories() {
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Material(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: 160,

                // decoration: myBoxDecoration(),
                //       <--- BoxDecoration here
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.colorlightgrey)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset(
                              'assets/fav.png',
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              '30%off',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.colororange),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Image.asset(
                        "assets/pea.png",
                        fit: BoxFit.fitHeight,
                      ),
                      Text(
                        'Green Peas',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.colorgreen,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                          bottom: 0,
                        ),
                        child: Text(
                          'हरी मटर',
                          style: TextStyle(
                              fontSize: 16, color: Colors.colorlightgrey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '₹60.00  ',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.colorlightgrey,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '₹70.00',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.colororange,
                                    decoration: TextDecoration.lineThrough),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 3, 20, 0),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 35,
                                decoration: myBoxDecoration3(),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8, left: 8),
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration.collapsed(
                                          hintText: ''),
                                      value: selectedValues,
                                      items: <String>["1", "2", "3", "4", "5"]
                                          .map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedValues = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 32, left: 32, top: 16),
                        child: Container(
                          height: 30,
                          decoration: myBoxDecoration2(),
                          child: Padding(
                            padding: EdgeInsets.only(right: 8, left: 8),
                            child: IntrinsicHeight(
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 16),
                                          child: Icon(
                                            Icons.minimize,
                                            color: Colors.colorgreen,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "0",
                                        style: TextStyle(
                                            color: Colors.colorgreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.colorgreen,
                                        size: 20,
                                      ),
                                    ),
                                  ],
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
            ));
          },
          itemCount: 5,
        ));
  }
}
