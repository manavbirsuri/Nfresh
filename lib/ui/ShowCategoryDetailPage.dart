import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nfresh/bloc/cat_products_bloc.dart';
import 'package:nfresh/bloc/set_fav_bloc.dart';
import 'package:nfresh/models/category_model.dart';
import 'package:nfresh/models/packing_model.dart';
import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/models/responses/response_cat_products.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/ui/ProductDetailPage.dart';
import 'package:nfresh/ui/cart.dart';

class ShowCategoryDetailPage extends StatefulWidget {
  final Category subCategory;
  ShowCategoryDetailPage({Key key, @required this.subCategory}) : super(key: key);

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

  var blocFav = SetFavBloc();
  var _database = DatabaseHelper.instance;
  int totalAmount = 0;
  //var blocCart = CartBloc();

  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    getCartCount();
    getCartTotal();
    bloc.fetchData(widget.subCategory.id.toString());
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
            // automaticallyImplyLeading: true,
            title: Text(
              widget.subCategory.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
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
                      )).then((value) {
                    getCartCount();
                    getCartTotal();
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
                      new Positioned(
                        right: 0,
                        child: cartCount > 0
                            ? Container(
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
                                  cartCount.toString(),
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Text(""),
                      )
                    ],
                  ),
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
          ),
        )
      ],
    );
  }

  showListView(List<Product> products) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
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
      ),
    );
  }

  /* Widget getListItem(position, Product product) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            //color: Colors.white,
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
                                              builder: (context) => ProductDetailPage(
                                                    product: product,
                                                  )));
                                    },
                                    child: Center(
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        width: 80,
                                        height: 80,
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
                                          blocFav.fetchData(product.fav, product.id.toString());
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
                                          builder: (context) => ProductDetailPage(
                                                product: product,
                                              ),
                                        ),
                                      );
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
                                                fontSize: 16, color: Colors.colorlightgrey),
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
                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                                decoration: TextDecoration.lineThrough),
                                            textAlign: TextAlign.start,
                                          ),
                                        ]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 32,
                                          width: 100,
                                          decoration: myBoxDecoration3(),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 8, left: 8),
                                              child: DropdownButtonFormField<Packing>(
                                                decoration: InputDecoration.collapsed(hintText: ''),
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
                                                    product.count = 0;
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          // color: Colors.grey,
                                          child: GestureDetector(
                                            onTap: () {
                                              decrementCount(product);
                                            },
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
                                              incrementCount(product);
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
  }*/
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
                                  GestureDetector(
                                    onTap: () {
                                      goToProductDetail(product);
                                    },
                                    child: Center(
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.grey,
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (product.fav == "1") {
                                              product.fav = "0";
                                            } else {
                                              product.fav = "1";
                                            }
                                            blocFav.fetchData(product.fav, product.id.toString());
                                          });
                                        },
                                        child: Container(
                                          //  color: Colors.grey,
                                          padding: EdgeInsets.only(right: 15, bottom: 15),
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
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: GestureDetector(
                                onTap: () {
                                  goToProductDetail(product);
                                },
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
                                        style:
                                            TextStyle(fontSize: 16, color: Colors.colorlightgrey),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                  decoration: TextDecoration.lineThrough),
                                              textAlign: TextAlign.start,
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: 32,
                                            width: 115,
                                            decoration: myBoxDecoration3(),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 8, left: 8),
                                                child: DropdownButtonFormField<Packing>(
                                                  decoration: InputDecoration.collapsed(
                                                      hintText:
                                                          product.selectedPacking.unitQtyShow),
                                                  value: null,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 2,
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              goToProductDetail(product);
                            },
                            child: Container(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.chevron_right,
                                ),
                              ),
                            ),
                          ),
                          /*Padding(
                            padding: EdgeInsets.only(right: 0, left: 0),
                            child: Container(
                              height: 30,
                              decoration: myBoxDecoration2(),
                              child: Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: IntrinsicHeight(
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ),*/
                          Padding(
                            padding: EdgeInsets.only(right: 0, left: 0, top: 16),
                            child: Container(
                              // width: 120,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: IntrinsicHeight(
                                  // child: Center(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            decrementCount(product);
                                          },
                                          child: Container(
                                            // padding: EdgeInsets.only(left: 20),
                                            // color: Colors.white,
                                            child: Container(
                                              decoration: myBoxDecoration2(),
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: Image.asset(
                                                'assets/minus.png',
                                                height: 10,
                                                width: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                          child: Center(
                                            child: Text(
                                              product.count.toString(),
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
                                            incrementCount(product);
                                          },
                                          child: Container(
                                            //  color: Colors.white,
                                            // padding: EdgeInsets.only(right: 20),
                                            child: Container(
                                              decoration: myBoxDecoration2(),
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: Image.asset(
                                                'assets/plus.png',
                                                height: 10,
                                                width: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //  ),
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
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Divider(
              height: 1,
              color: Colors.black38,
            ),
          )
        ]);
  }

  showGridView(List<Product> products) {
//    var size = MediaQuery.of(context).size;
//    double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//    itemHeight = itemHeight;
//    double itemWidth = size.width / 2;
//    itemWidth = itemWidth;

    return Expanded(
        child: Container(
      padding: EdgeInsets.all(4),
      color: Colors.colorlightgreyback,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        shrinkWrap: true,
        primary: false,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) => new Container(
              child: girdViewItem(index, context, products),
            ),
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
      ),
      /*  child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this would produce 2 rows.
        //childAspectRatio: (itemWidth / itemHeight),
        childAspectRatio: MediaQuery.of(context).size.width <= 360 ? 1 / 1.70 : 1 / 1.55,
        crossAxisCount: 2,
        shrinkWrap: true,
        // Generate 100 Widgets that display their index in the List
        children: List.generate(products.length, (index) {
          var product = products[index];
          return Material(
            color: Colors.transparent,
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
                                    blocFav.fetchData(product.fav, product.id.toString());
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
                          goToProductDetail(product);
                        },
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              product.image,
                              fit: BoxFit.contain,
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
                                style: TextStyle(fontSize: 16, color: Colors.colorlightgrey),
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
                                    decoration: InputDecoration.collapsed(hintText: ''),
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
                      */ /* Padding(
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
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                              padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
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
                                            padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
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
                      ),*/ /*
                      Padding(
                        padding: EdgeInsets.only(right: 8, left: 8, top: 16),
                        child: Container(
                          width: 150,
                          //color: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IntrinsicHeight(
                              child: Center(
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            decrementCount(products[index]);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          // color: Colors.white,
                                          child: Container(
                                            decoration: myBoxDecoration2(),
                                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                            child: Image.asset(
                                              'assets/minus.png',
                                              height: 12,
                                              width: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                        child: Center(
                                          child: Text(
                                            product.count.toString(),
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
                                            incrementCount(products[index]);
                                          });
                                        },
                                        child: Container(
                                          //  color: Colors.white,
                                          padding: EdgeInsets.only(right: 20),
                                          child: Container(
                                            decoration: myBoxDecoration2(),
                                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                            child: Image.asset(
                                              'assets/plus.png',
                                              height: 12,
                                              width: 12,
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
      ),*/
    ));
  }

  Future incrementCount(Product product) async {
    if (product.count < product.inventory) {
      product.count = product.count + 1;
      await _database.update(product);
      getCartCount();
      getCartTotal();
      // Future.delayed(const Duration(milliseconds: 500), () async {});
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Available inventory : ${product.inventory}"),
      ));
    }
  }

  Future decrementCount(Product product) async {
    if (product.count > 1) {
      product.count = product.count - 1;
      await _database.update(product);
    } else if (product.count == 1) {
      product.count = product.count - 1;
      _database.remove(product);
    }
    getCartCount();
    getCartTotal();
    // Future.delayed(const Duration(milliseconds: 500), () async {});
  }

  getCartCount() {
    _database.getCartCount().then((count) {
      setState(() {
        cartCount = count;
      });
    });
  }

  getCartTotal() {
    _database.queryAllProducts().then((products) {
      var amount = 0;
      for (int i = 0; i < products.length; i++) {
        var product = products[i];
        amount += (product.selectedPacking.price * product.count);
      }
      setState(() {
        totalAmount = amount;
      });
    });
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
      borderRadius: BorderRadius.all(Radius.circular(8)),
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

  // calculate the offer percentage
  String getOff(Product product) {
    var salePrice = product.packing[0].price;
    var costPrice = product.displayPrice;
    var profit = costPrice - salePrice;
    var offer = (profit / costPrice) * 100;
    return "${offer.round()}% off";
  }

  Widget mainContent(AsyncSnapshot<ResponseCatProducts> snapshot) {
    print("Products: ${snapshot.data.products.length}");
    return snapshot.data.products.length > 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
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
                              child: Image.asset('assets/sort.png', height: 20, width: 20))),
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
                  height: 65,
                  padding: EdgeInsets.all(0),
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
                                        '₹$totalAmount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.colorgrey,
                                        ),
                                      ),
                                      Text(
                                        'Total amount',
                                        style: TextStyle(
                                          fontSize: 12,
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
                            margin: EdgeInsets.only(top: 4, bottom: 4),
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
                                        style: TextStyle(fontSize: 18, color: Colors.white),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartPage(),
                              ),
                            ).then((value) {
                              getCartTotal();
                              getCartCount();
                            });
                          },
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          )
        : noDataView();
  }

  void goToProductDetail(Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
                product: product,
              ),
        ));
  }

  Widget noDataView() {
    return Container(
      child: Column(
        children: <Widget>[Text("No product available")],
      ),
    );
  }

  girdViewItem(int index, BuildContext context, List<Product> products) {
    var product = products[index];
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Container(
            //height: 330,
            padding: EdgeInsets.only(bottom: 12),
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
                              blocFav.fetchData(product.fav, product.id.toString());
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
                          getOff(product),
                          style: TextStyle(
                            fontSize: 12,
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
                    goToProductDetail(product);
                  },
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        product.image,
                        fit: BoxFit.contain,
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
                          style: TextStyle(fontSize: 16, color: Colors.colorlightgrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                              decoration: InputDecoration.collapsed(
                                  hintText: product.selectedPacking.unitQtyShow),
                              value: null,
                              //value: product.selectedPacking,
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
                                  product.count = 0;
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
                  padding: EdgeInsets.only(right: 8, left: 8, top: 16),
                  child: Container(
                    width: 150,
                    //color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IntrinsicHeight(
                        child: Center(
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    decrementCount(products[index]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20),
                                    // color: Colors.white,
                                    child: Container(
                                      decoration: myBoxDecoration2(),
                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Image.asset(
                                        'assets/minus.png',
                                        height: 12,
                                        width: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                  child: Center(
                                    child: Text(
                                      product.count.toString(),
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
                                    incrementCount(products[index]);
                                  },
                                  child: Container(
                                    //  color: Colors.white,
                                    padding: EdgeInsets.only(right: 20),
                                    child: Container(
                                      decoration: myBoxDecoration2(),
                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Image.asset(
                                        'assets/plus.png',
                                        height: 12,
                                        width: 12,
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
  }
}
