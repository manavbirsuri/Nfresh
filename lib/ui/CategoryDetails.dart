import 'package:flutter/material.dart';
import 'package:nfresh/bloc/subcat_bloc.dart';
import 'package:nfresh/models/category_model.dart';
import 'package:nfresh/models/responses/response_subcat.dart';
import 'package:nfresh/resources/database.dart';
import 'package:nfresh/ui/ShowCategoryDetailPage.dart';
import 'package:nfresh/ui/cart.dart';

class CategoryDetails extends StatefulWidget {
  final Category selectedCategory;
  CategoryDetails({Key key, @required this.selectedCategory}) : super(key: key);
  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  var bloc = SubCatBloc();

  var _database = DatabaseHelper.instance;

  int cartCount = 0;
  @override
  void initState() {
    super.initState();
    _database.getCartCount().then((value) {
      setState(() {
        cartCount = value;
      });
    });

    bloc.fetchSubCategories(widget.selectedCategory.id.toString());
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
        appBar: AppBar(
          backgroundColor: Colors.colorgreen.withOpacity(0.0),
          automaticallyImplyLeading: true,
          title: Text(
            widget.selectedCategory.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
//          leading: IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: () => Navigator.pop(context, false),
//          ),
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
                    )).then((onValue) {
                  _database.getCartCount().then((value) {
                    setState(() {
                      cartCount = value;
                    });
                  });
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
                          : Text(''),
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
        body: StreamBuilder(
          stream: bloc.subCatData,
          builder: (context, AsyncSnapshot<ResponseSubCat> snapshot) {
            if (snapshot.hasData) {
              return mainContent(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      )
    ]);
  }

  Widget mainContent(AsyncSnapshot<ResponseSubCat> snapshot) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          var subCat = snapshot.data.categories[position];
          return Padding(
            padding: EdgeInsets.only(top: 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => ShowCategoryDetailPage(subCategory: subCat),
                  ),
                ).then((onValue) {
                  _database.getCartCount().then((value) {
                    setState(() {
                      cartCount = value;
                    });
                  });
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(subCat.name),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: snapshot.data.categories.length,
      ),
    );
  }
}
