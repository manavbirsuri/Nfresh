import 'package:flutter/material.dart';

import 'PinView.dart';

class SignUp extends StatelessWidget {
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
  var selectedValues = "Select type";
  var areaValues = "Select your area";
  int _currValue = 0;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController refralController = new TextEditingController();
  var showText = true;
  var checked = false;
  var valueShow = "Show";
  void onChanged(int value) {
    setState(() {
      _currValue = value;
    });

    print('Value = $value');
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Scaffold(
          appBar: new AppBar(
            leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context)),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0, right: 20, left: 20),
                child: Material(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/logo.png',
                                ),
                              ),
                            )
                          ]),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Name",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Center(
                                      child: TextFormField(
                                        controller: nameController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (term) {
                                          FocusScope.of(context)
                                              .requestFocus(focus);
                                        },
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText: 'Enter Name'),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Center(
                                      child: TextFormField(
                                        focusNode: focus,
                                        controller: emailController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (term) {
                                          FocusScope.of(context)
                                              .requestFocus(focus1);
                                        },
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText: 'Enter Email'),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Mobile Number",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Center(
                                      child: TextFormField(
                                        focusNode: focus1,
                                        controller: mobileController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (term) {
                                          FocusScope.of(context)
                                              .requestFocus(focus2);
                                        },
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText:
                                                    'Enter Mobile Number'),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Password",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Row(children: <Widget>[
                                        Flexible(
                                          child: Container(
                                            child: Center(
                                              child: TextFormField(
                                                focusNode: focus2,
                                                obscureText: showText,
                                                controller: passwordController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (term) {},
                                                decoration: new InputDecoration
                                                        .collapsed(
                                                    hintText: 'Enter Password'),
                                              ),
                                            ),
                                          ),
                                          flex: 4,
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (passwordController.text
                                                        .toString()
                                                        .length >
                                                    0) {
                                                  if (showText) {
                                                    showText = false;
                                                    valueShow = "Hide";
                                                  } else {
                                                    showText = true;
                                                    valueShow = "Show";
                                                  }
                                                }
                                              });
                                            },
                                            child: Container(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 8, left: 0),
                                                child: Text(
                                                  valueShow,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.colorgreen),
                                                ),
                                              ),
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                      ])),
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Type of User",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Center(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration.collapsed(
                                            hintText: ''),
                                        value: selectedValues,
                                        items: <String>[
                                          "Select type",
                                          "1",
                                          "2",
                                          "3"
                                        ].map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
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
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "City",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Center(
                                      child: TextFormField(
                                        controller: cityController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
//                                        onFieldSubmitted: (term) {
//                                          FocusScope.of(context)
//                                              .requestFocus(focus2);
//                                        },
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText: 'Enter your city'),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Area",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Center(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration.collapsed(
                                            hintText: ''),
                                        value: areaValues,
                                        items: <String>[
                                          "Select your area",
                                          "1",
                                          "2",
                                          "3"
                                        ].map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            areaValues = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Referral code",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Center(
                                      child: TextFormField(
//                                        focusNode: focus1,
                                        controller: refralController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
//                                        onFieldSubmitted: (term) {
//                                          FocusScope.of(context)
//                                              .requestFocus(focus2);
//                                        },
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText:
                                                    'Enter your referral code'),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1, color: Colors.black),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (_currValue == 0) {
                                                _currValue = 1;
                                              } else {
                                                _currValue = 0;
                                              }
                                            });
                                          },
                                          child: new Radio(
                                            value: 1,
                                            groupValue: _currValue,
                                            activeColor: Colors.colorgreen,

//                                              onChanged: (int value) {
//                                                onChanged(value);
//                                              }
                                          ),
                                        ),
                                        new Text(
                                          'Agree to the ',
                                          style: new TextStyle(fontSize: 16.0),
                                        ),
                                        new Text(
                                          'terms & conditions ',
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.colorgreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        32, 8, 32, 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new PinViewPage()),
                                        );
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(100.0)),
                                            color: Colors.colorgreen),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: Center(
                                            child: new Text("Create Account",
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                )),
                                          ),
                                        ),
                                      ),
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
            ],
          ),
        ),
      ],
    );
  }
}
