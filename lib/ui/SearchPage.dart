import 'package:flutter/material.dart';
import 'package:nfresh/bloc/search_bloc.dart';
import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/responses/response_search.dart';
import 'package:nfresh/ui/ProductDetailPage.dart';

class SearchPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new MyHomePage(title: 'ListView with Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();
//  var items = List<ModelProduct>();
  var viewList = false;
  var viewGrid = true;
  var gridImage = 'assets/selected_grid.png';
  var listImage = 'assets/unselected_list.png';
  // List<ModelProduct> productArray = List();

  var bloc = SearchBloc();
  // var pos = 0;

  @override
  void initState() {
    super.initState();
  }

//  void filterSearchResults(String query) {
//    List<ModelProduct> dummySearchList = List<ModelProduct>();
//    dummySearchList.addAll(productArray);
//    if (query.isNotEmpty) {
//      List<ModelProduct> dummyListData = List<ModelProduct>();
//      dummySearchList.forEach((item) {
//        if (item.name.toLowerCase().contains(query.toLowerCase())) {
//          dummyListData.add(item);
//        }
//      });
//      setState(() {
//        // items.clear();
//        //  items.addAll(dummyListData);
//      });
//      return;
//    } else {
//      setState(() {
//        // items.clear();
////        items.addAll(productArray);
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  //  filterSearchResults(value);
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    bloc.fetchSearchData(value);
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
            StreamBuilder(
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
            )
          ],
        ),
      ),
    );
  }

  showListView(List<Product> products) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, position) {
        var product = products[position];
        return Padding(
          padding: EdgeInsets.only(top: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ProductDetailPage()));
            },
            child: getListItem(position, product),
          ),
        );
      },
      itemCount: products.length,
    );
  }

  Widget getListItem(position, Product product) {
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
                                  Center(
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Image.asset(
                                      'assets/fav.png',
                                      width: 20.0,
                                      height: 20.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 0, right: 0),
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
                                          Text(
                                            '₹${product.displayPrice}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.colororange,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                            textAlign: TextAlign.start,
                                          ),
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
                                          width: 100,
                                          decoration: myBoxDecoration3(),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 8, left: 8),
                                              child: DropdownButtonFormField<
                                                  Packing>(
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: ''),
                                                value: product.selectedPacking,
                                                items: product.packing
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 3,
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.navigate_next,
                              color: Colors.black,
                              size: 30.0,
                            ),

//                            Image.asset(
//                              'assets/delete.png',
//                              height: 20,
//                              width: 20,
//                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 0, left: 0),
                            child: Container(
                              height: 30,
                              decoration: myBoxDecoration2(),
                              child: Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: IntrinsicHeight(
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 16),
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
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black38,
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
        child: GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this would produce 2 rows.
      childAspectRatio: 1 / 1.5,
      crossAxisCount: 2,
      shrinkWrap: true,
      // Generate 100 Widgets that display their index in the List
      children: List.generate(products.length, (index) {
        var product = products[index];
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ProductDetailPage()));
            },
            child: Material(
                child: Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                decoration: myBoxDecoration(),
                //       <--- BoxDecoration here
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
                    Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      height: 90,
                    ),
                    Text(
                      product.name,
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
                        product.nameHindi,
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
                              '₹${product.selectedPacking.price}  ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.colorlightgrey,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '₹${product.displayPrice}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.colororange,
                                  decoration: TextDecoration.lineThrough),
                              textAlign: TextAlign.center,
                            ),
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 32,
                            width: 120,
                            decoration: myBoxDecoration3(),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: DropdownButtonFormField<Packing>(
                                  decoration:
                                      InputDecoration.collapsed(hintText: ''),
                                  value: product.selectedPacking,
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
                      padding: EdgeInsets.only(right: 42, left: 42, top: 16),
                      child: Container(
                        height: 35,
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
            )));
      }),
    ));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 0.5, color: Colors.colorlightgrey),
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

  Widget mainContent(AsyncSnapshot<ResponseSearch> snapshot) {
    return Expanded(
      child: snapshot.data.products.length > 0
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
                          onTap: () {},
                          child: Image.asset('assets/sort.png',
                              height: 20, width: 20)),
                    ],
                  ),
                ),
                viewList
                    ? Expanded(
                        child: showListView(snapshot.data.products),
                      )
                    : Container(),
                viewGrid ? showGridView(snapshot.data.products) : Container(),
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

//  getPos(int position) {
//    //if(position==0){
//    return selectedValues[pos];
//    // }
//  }
}
