import 'package:flutter/material.dart';
import 'package:nfresh/models/category_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/section_model.dart';
import 'package:page_indicator/page_indicator.dart';

import 'CategoryDetails.dart';
import 'ProductDetailPage.dart';
import 'models/response_home.dart';

class HomePage extends StatefulWidget {
  final AsyncSnapshot<ResponseHome> data;
  HomePage({Key key, @required this.data}) : super(key: key);

  @override
  State createState() => HOrderPage();
}

class HOrderPage extends State<HomePage> {
  // List<Category> list = List();
  // List<ModelProduct> listPro = List();

  List _cities = ["500gm", "1kg", "1.5kg", "2kg", "2.5kg"];
  var _pageController = new PageController();
//  List<String> selectedValues = List();
  var pos = 0;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  AsyncSnapshot<ResponseHome> snapshot;

  @override
  void initState() {
    super.initState();
//    selectedValues = List();
    snapshot = widget.data;
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Colors.colorlightgreyback,
            child: Stack(children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(height: 150, child: showTopPager()),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Image.asset('assets/ribbon.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6),
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
                          height: 150,
                          child: showCategories(snapshot.data.categories)),
                      Container(
                          child: productsCategories(snapshot.data.sections)),
                    ],
                  ),
                  //),
                ],
              )
            ])));
  }

  showTopPager() {
    return new PageIndicatorContainer(
      pageView: new PageView(
        controller: _pageController,
        children: <Widget>[
          Container(
            child: Image.asset(
              "assets/dummy.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
              child: Image.asset(
            "assets/dummy.jpg",
            fit: BoxFit.cover,
          )),
          Container(
              child: Image.asset(
            "assets/dummy.jpg",
            fit: BoxFit.cover,
          )),
          Container(
              child: Image.asset(
            "assets/dummy.jpg",
            fit: BoxFit.cover,
          )),
        ],
        // controller: controller,
      ),
      align: IndicatorAlign.bottom,
      length: 4,
      indicatorSpace: 8.0,
      padding: const EdgeInsets.all(10),
      indicatorColor: Colors.grey,
      indicatorSelectorColor: Colors.blue,
      shape: IndicatorShape.circle(size: 12),
    );
  }

  showCategories(List<Category> categories) {
    return Padding(
        padding: EdgeInsets.only(top: 16),
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
                              CategoryDetails(categories[position])));
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
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.colorlightgrey),
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

  showProductsCategories(List<Product> products) {
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Material(
              color: Colors.colorlightgreyback,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                          child: Container(
                            width: 150,
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
                                  builder: (context) => ProductDetailPage(),
                                ));
                          },
                          child: Column(
                            children: <Widget>[
                              Image.network(
                                products[position].image,
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.colorlightgrey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        products[position]
                                            .displayPrice
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.colorlightgrey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        products[position]
                                            .displayPrice
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.colororange,
                                            decoration:
                                                TextDecoration.lineThrough),
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
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Qty'),
                                      value: products[position].quantity,
                                      //value: null,
                                      items: <String>[
                                        "500gm",
                                        "1kg",
                                        "1.5kg",
                                        "2kg",
                                        "2.5kg"
                                      ].map((String value) {
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
                                          products[position].quantity =
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
                          padding:
                              EdgeInsets.only(right: 32, left: 32, top: 16),
                          child: Container(
                            decoration: myBoxDecoration2(),
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
                                            setState(() {
                                              if (products[position].inventory >
                                                  0) {
                                                products[position].inventory =
                                                    (products[position]
                                                            .inventory -
                                                        1);
                                              }
                                            });
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    18, 10, 18, 10),
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
                                              products[position]
                                                  .inventory
                                                  .toString(),
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
                                              products[position].inventory =
                                                  (products[position]
                                                          .inventory) +
                                                      1;
                                            });
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  18, 10, 18, 10),
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
                  padding: EdgeInsets.only(top: 16),
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
                Container(
                    height: 330,
                    child: showProductsCategories(sections[position].products)),
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
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );
  }

  BoxDecoration myBoxDecoration3() {
    return BoxDecoration(
      border: Border.all(color: Colors.colorlightgrey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }

//  getPos(int position) {
//    //if(position==0){
//    return selectedValues[pos];
//    // }
//  }
}

//class Category {
//  String image;
//  String name;
//}
