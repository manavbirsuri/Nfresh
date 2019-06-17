import 'package:flutter/material.dart';
import 'package:nfresh/bloc/set_fav_bloc.dart';
import 'package:nfresh/models/banner_model.dart';
import 'package:nfresh/models/category_model.dart';
import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/responses/response_home.dart';
import 'package:nfresh/models/section_model.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/ui/CategoryDetails.dart';
import 'package:nfresh/ui/ProductDetailPage.dart';
import 'package:page_indicator/page_indicator.dart';

import '../count_listener.dart';

class HomePage extends StatefulWidget {
  final CountListener listener;
  final AsyncSnapshot<ResponseHome> data;
  HomePage({Key key, @required this.data, this.listener}) : super(key: key);

  @override
  State createState() => HOrderPage();
}

class HOrderPage extends State<HomePage> {
  // List<Category> list = List();
  // List<ModelProduct> listPro = List();
  var _database = DatabaseHelper.instance;
  var blocFav = SetFavBloc();
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
    //  updateProducts();
    updateUI();
  }

  Future updateProducts() async {
    var sections = snapshot.data.sections;
    for (int i = 0; i < sections.length; i++) {
      var products = sections[i].products;
      for (int j = 0; j < products.length; j++) {
        var model = products[j];
        var product = await _database.queryConditionalProduct(model);
        setState(() {
          model = product;
        });
      }
    }
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
                  AspectRatio(
                    aspectRatio: 2.5 / 1,
                    child: showTopPager(snapshot.data.banners),
                  ),
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
                          height: 130,
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

  Widget showTopPager(List<BannerModel> banners) {
    return new PageIndicatorContainer(
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
                          builder: (context) => CategoryDetails(
                              selectedCategory: categories[position])));
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
            var product = products[position];
            print("Countvvv : $product.count");
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
                                padding:
                                    EdgeInsets.only(right: 4, left: 0, top: 0),
                                child: Container(
                                  width: 168,
                                  //color: Colors.green,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (product.fav == "1") {
                                                product.fav = "0";
                                              } else {
                                                product.fav = "1";
                                              }

                                              blocFav.fetchData(product.fav,
                                                  product.id.toString());
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.mygrey,
                                            padding: EdgeInsets.all(8),
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
                                          )),
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
                                        builder: (context) => ProductDetailPage(
                                              product: product,
                                            ),
                                      ));
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
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.colorlightgrey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "₹" +
                                                  product.selectedPacking.price
                                                      .toString() +
                                                  "  ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.colorlightgrey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "₹" +
                                                  products[position]
                                                      .displayPrice
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.colororange,
                                                  decoration: TextDecoration
                                                      .lineThrough),
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
                                          padding: EdgeInsets.only(
                                              right: 8, left: 8),
                                          child:
                                              DropdownButtonFormField<Packing>(
                                            decoration:
                                                InputDecoration.collapsed(
                                                    hintText: product.packing[0]
                                                        .unitQtyShow),
                                            // value: product.selectedPacking,
                                            value: null,
                                            items: product
                                                .packing //getQtyList(products[position])
                                                .map((Packing value) {
                                              return new DropdownMenuItem<
                                                  Packing>(
                                                value: value,
                                                child: new Text(
                                                  value.unitQtyShow,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                products[position]
                                                    .selectedPacking = newValue;
                                                product.count = 0;
                                                // product.selectedPrice =
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
                                    right: 32, left: 32, top: 16),
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
                                                    decrementCount(
                                                        products[position]);
                                                  });
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
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
                                                    product.count.toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.colorgreen,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                    textAlign: TextAlign.center,
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
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
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

  void incrementCount(Product product) {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
    }
    _database.update(product);
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.listener.onCartUpdate();
    });
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
      widget.listener.onCartUpdate();
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
}
