import 'package:flutter/material.dart';

class WishListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wish(),
    );
  }
}

class Wish extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WishPage();
  }
}

class WishPage extends State<Wish> {
  List<String> selectedValues = List();
  var pos = 0;

  @override
  Widget build(BuildContext context) {
    selectedValues.clear();
    selectedValues.add("1");
    selectedValues.add("2");
    selectedValues.add("3");
    selectedValues.add("4");
    selectedValues.add("5");
    return Material(
        child: Padding(
            padding: EdgeInsets.only(top: 16),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, position) {
                return IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IntrinsicHeight(
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
                                    child: Image.asset(
                                      'assets/pea.png',
                                      fit: BoxFit.fill,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        padding:
                                            EdgeInsets.fromLTRB(0, 8, 0, 0),
                                        child: Text(
                                          'हरी मटर',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.colorlightgrey),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '₹60.00  ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.colorlightgrey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                '₹70.00',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.colororange,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                                textAlign: TextAlign.start,
                                              ),
                                            ]),
                                      ),
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
                                              width: 100,
                                              decoration: myBoxDecoration3(),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8, left: 8),
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText: ''),
                                                    value: selectedValues[pos],
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
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        pos = 0;
                                                        for (int i = 0;
                                                            i <
                                                                selectedValues
                                                                    .length;
                                                            i++) {
                                                          if (selectedValues[
                                                                  i] ==
                                                              newValue) {
                                                            pos = i;
                                                            break;
                                                          }
                                                        }
                                                        print("GGGGGGGGG " +
                                                            newValue +
                                                            " " +
                                                            pos.toString());
                                                        selectedValues[pos] =
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Image.asset(
                                            'assets/delete.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 0, left: 16),
                                        child: Container(
                                            height: 32,
                                            width: 80,
                                            decoration: myBoxDecoration2(),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        child: Icon(
                                                          Icons.minimize,
                                                          color:
                                                              Colors.colorgreen,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    flex: 1,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "0",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.colorgreen,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    flex: 1,
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            Colors.colorgreen,
                                                        size: 16,
                                                      ),
                                                    ),
                                                    flex: 1,
                                                  )
                                                ],
                                              ),
                                            )),
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
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: 5,
            )));
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
}
