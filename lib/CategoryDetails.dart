import 'package:flutter/material.dart';

import 'ShowCategoryDetailPage.dart';
import 'cart.dart';
import 'models/category_model.dart';

class CategoryDetails extends StatelessWidget {
  Category list;

  CategoryDetails(Category list) {
    this.list = list;
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
            list.name,
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
        backgroundColor: Colors.colorgreen.withOpacity(0.5),
        body: Container(
            height: double.infinity,
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  ShowCategoryDetailPage(list)));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text("Subcatagory $position"),
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
              itemCount: 5,
            )),
      )
    ]);
  }
}
