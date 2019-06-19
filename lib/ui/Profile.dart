import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: stateProfile(),
    );
  }
}

class stateProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return stateProfilePage();
  }
}

class stateProfilePage extends State<stateProfile> {
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: Image.asset(
            'assets/sigbg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        new Scaffold(
          appBar: new AppBar(
            /* leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),*/
            actions: [
              Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    "UPDATE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
//              IconButton(
//                  icon: new Icon(
//                    Icons.edit,
//                    color: Colors.white,
//                  ),
//                  onPressed: () => Navigator.pop(context)),
            ],
            title: new Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(''),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, right: 20, left: 20),
                child: Material(
                  elevation: 16.0,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18), topLeft: Radius.circular(18)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18), topLeft: Radius.circular(18)),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        autofocus: true,
                                        decoration: InputDecoration(labelText: 'Name'),
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(focus);
                                        },
                                      ),

//                                      Text(
//                                        'Name',
//                                        style: TextStyle(fontSize: 12),
//                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextFormField(
                                        focusNode: focus,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(labelText: 'Email'),
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(focus1);
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextFormField(
                                        focusNode: focus1,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(labelText: 'Phone Number'),
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(focus2);
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextFormField(
                                        focusNode: focus2,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(labelText: 'Password'),
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(focus3);
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextFormField(
                                        focusNode: focus3,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(labelText: 'City'),
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(focus4);
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextFormField(
                                        focusNode: focus4,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(labelText: 'Area'),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Text(
                                        'Type of user',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Text(
                                        'Retailer',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
