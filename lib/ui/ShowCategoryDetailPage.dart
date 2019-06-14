import 'package:flutter/material.dart';
import 'package:nfresh/bloc/cat_products_bloc.dart';
import 'package:nfresh/models/category_model.dart';
import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/responses/response_cat_products.dart';
import 'package:nfresh/ui/ProductDetailPage.dart';
import 'package:nfresh/ui/cart.dart';

class ShowCategoryDetailPage extends StatefulWidget {
  final Category subCategory;
  ShowCategoryDetailPage({Key key, @required this.subCategory})
      : super(key: key);

  @override
  _ShowCategoryDetailPageState createState() => _ShowCategoryDetailPageState();
}

class _ShowCategoryDetailPageState extends State<ShowCategoryDetailPage> {
  var bloc = CatProductsBloc();
  var viewList = false;
  var viewGrid = true;
  var gridImage = 'assets/selected_grid.png';
  var listImage = 'assets/unselected_list.png';
  List<String> selectedValues = List();

  var pos = 0;

  @override
  void initState() {
    super.initState();

    bloc.fetchData(widget.subCategory.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            widget.subCategory.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
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
        body: StreamBuilder(
          stream: bloc.catProductsList,
          builder: (context, AsyncSnapshot<ResponseCatProducts> snapshot) {
            if (snapshot.hasData) {
              return mainContent(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  showListView(List<Product> products) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, position) {
        var product = products[position];
        return Padding(
          padding: EdgeInsets.only(top: 0),
          child: GestureDetector(
            onTap: () {
//              Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (context) => ProductDetailPage()));
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
          Container(
            padding: EdgeInsets.all(14.0),
            child: IntrinsicHeight(
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
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailPage()));
                                    },
                                    child: Center(
                                      child: Image.asset(
                                        product.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (product.fav == "1") {
                                            product.fav = "0";
                                          } else {
                                            product.fav = "1";
                                          }
                                        });
                                      },
                                      child: product.fav == "1"
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
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailPage()));
                                    },
                                    child: Column(
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
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '₹${product.selectedPacking.price}  ',
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
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.navigate_next,
                              color: Colors.white,
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
                                          // color: Colors.grey,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                decrementCount(product);
                                              });
                                            },
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
                                        ),
                                        Container(
                                          child: Text(
                                            product.count.toString(),
                                            style: TextStyle(
                                                color: Colors.colorgreen,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.grey,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                incrementCount(product);
                                              });
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.colorgreen,
                                              size: 20,
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
      //childAspectRatio: (itemWidth / itemHeight),
      childAspectRatio: 1 / 1.55,
      crossAxisCount: 2,
      shrinkWrap: true,
      // Generate 100 Widgets that display their index in the List
      children: List.generate(products.length, (index) {
        var product = products[index];
        return Material(
          color: Colors.colorlightgreyback,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Container(
                //height: 330,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                      child: Container(
                        width: 150,
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
                                });
                              },
                              child: product.fav == "1"
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
                            ),
                            Text(
                              product.off,
                              style: TextStyle(
                                fontSize: 18,
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
                       goToProductDetail();
                      },
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            product.image,
                            fit: BoxFit.fitHeight,
                            height: 80,
                          ),
                          Text(
                            product.name,
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
                              product.nameHindi,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.colorlightgrey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '₹${product.selectedPacking.price}  ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.colorlightgrey,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                      padding: EdgeInsets.only(right: 16, left: 16, top: 16),
                      child: Container(
                        width: 120,
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
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          decrementCount(product);
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8, 10, 8, 10),
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
                                              color: Colors.colorgreen,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          incrementCount(product);
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 10, 8, 10),
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
      }),
    ));
  }

  void incrementCount(Product product) {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
    }
  }

  void decrementCount(Product product) {
    if (product.count > 0) {
      product.count = product.count - 1;
    }
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        right: BorderSide(width: 0.5, color: Colors.colorlightgrey),
        bottom: BorderSide(width: 1.0, color: Colors.colorlightgrey),
        left: BorderSide(width: 0.5, color: Colors.colorlightgrey),
      ),
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
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
  }

  getPos(int position) {
    //if(position==0){
    return selectedValues[pos];
    // }
  }

  Widget mainContent(AsyncSnapshot<ResponseCatProducts> snapshot) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.colorlightgreyback,
          child: Padding(
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
                  child: Container(
                    child: Image.asset(
                      gridImage,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.colorgrey,
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
                  child: Container(
                    child: Image.asset(listImage, height: 20, width: 20),
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.colorgrey,
                ),
                GestureDetector(
                    onTap: () {},
                    child: Container(
                        child: Image.asset('assets/sort.png',
                            height: 20, width: 20))),
              ],
            ),
          ),
        ),
        viewList
            ? Expanded(
                child: showListView(snapshot.data.products),
              )
            : Container(),
        viewGrid ? showGridView(snapshot.data.products) : Container(),
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
                                    color: Colors.colorgrey,
                                  ),
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
    );
  }

  void goToProductDetail() {}
}
