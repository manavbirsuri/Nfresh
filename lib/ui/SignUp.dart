import 'package:flutter/material.dart';
import 'package:nfresh/bloc/cities_bloc.dart';
import 'package:nfresh/bloc/signup_bloc.dart';
import 'package:nfresh/models/area_model.dart';
import 'package:nfresh/models/city_model.dart';
import 'package:nfresh/ui/PinView.dart';

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
  var bloc = SignUpBloc();
  var blocCity = CityBloc();
  List<UserType> userTypes = [];
  UserType selectedType;
  List<CityModel> cities = [];
  List<AreaModel> areas = [];
  List<AreaModel> cityAreas = [];
  CityModel selectedCity;
  AreaModel selectedArea;
  bool showLoader = false;
  @override
  void initState() {
    super.initState();
    blocCity.fetchData();
    blocCity.cities.listen((res) {
      setState(() {
        this.cities = res.cities;
        Map<String, dynamic> map = {'id': -1, 'name': "Select City"};
        var model = CityModel(map);
        this.cities.insert(0, model);
        selectedCity = cities[0];
        this.areas = res.areas;
      });
    });
    userTypes.add(UserType("0", "Select Type"));
    userTypes.add(UserType("1", "Retailer"));
    userTypes.add(UserType("2", "Wholesaler"));
    userTypes.add(UserType("3", "Marriage Palace"));
    selectedType = userTypes[0];

    bloc.signUp.listen((response) {
      setState(() {
        showLoader = false;
      });
      if (response.status == "true") {
        // Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => PinViewPage(
                  response.userId, mobileController.text.toString())),
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(response.msg),
          ),
        );
      }
    });
  }

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
//            leading: new IconButton(
//                icon: new Icon(
//                  Icons.arrow_back,
//                  color: Colors.black,
//                ),
//                onPressed: () => Navigator.pop(context)),
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
                                        keyboardType: TextInputType.phone,
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
                                      child: DropdownButtonFormField<UserType>(
                                        decoration: InputDecoration.collapsed(
                                            hintText: ''),
                                        value: selectedType,
                                        items: userTypes.map((UserType value) {
                                          return new DropdownMenuItem<UserType>(
                                            value: value,
                                            child: new Text(value.userType),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedType = newValue;
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
                                      child: DropdownButtonFormField<CityModel>(
                                        decoration: InputDecoration.collapsed(
                                            hintText: ''),
                                        value: selectedCity,
                                        items: cities.map((CityModel value) {
                                          return new DropdownMenuItem<
                                              CityModel>(
                                            value: value,
                                            child: new Text(value.name),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCity = newValue;
                                            getCityAreas(newValue);
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
                                      child: DropdownButtonFormField<AreaModel>(
                                        decoration: InputDecoration.collapsed(
                                            hintText: ''),
                                        value: selectedArea,
                                        items: cityAreas.map((AreaModel value) {
                                          return new DropdownMenuItem<
                                              AreaModel>(
                                            value: value,
                                            child: new Text(value.name),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedArea = newValue;
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

                                              print("Accepted: $_currValue");
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
                                          style: new TextStyle(fontSize: 14.0),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: new Text(
                                            'Terms of Use ',
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.colorgreen),
                                          ),
                                        ),
                                        new Text(
                                          'and ',
                                          style: new TextStyle(fontSize: 14.0),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: new Text(
                                            'Privacy Policy',
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.colorgreen),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  showLoader
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              32, 8, 32, 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              createAccountWebservice();
                                            },
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          new Radius.circular(
                                                              100.0)),
                                                  color: Colors.colorgreen),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 60,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              32, 8, 32, 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              createAccountWebservice();
                                            },
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          new Radius.circular(
                                                              100.0)),
                                                  color: Colors.colorgreen),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 60,
                                                child: Center(
                                                  child:
                                                      new Text("Create Account",
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

  void getCityAreas(CityModel selectedCity) {
    cityAreas = [];
    for (int i = 0; i < areas.length; i++) {
      var modelArea = areas[i];
      if (modelArea.cityId == selectedCity.id) {
        cityAreas.add(modelArea);
      }
    }
    if (cityAreas.length > 0) {
      Map<String, dynamic> map = {
        'id': -1,
        'name': "Select Area",
        'city_id': -1
      };
      var model = AreaModel(map);
      cityAreas.insert(0, model);
      selectedArea = cityAreas[0];
    } else {
      selectedArea = null;
    }
  }

  void createAccountWebservice() {
    String name = nameController.text.toString();
    String email = emailController.text.toString();
    String phone = mobileController.text.toString();
    String password = passwordController.text.toString();
    String referral = refralController.text.toString();
    int aggreed = _currValue;

    if (name.length == 0) {
      showMessage("Enter valid name");
      return;
    }
    if (email.length == 0 || !isEmail(email)) {
      showMessage("Enter valid email address");
      return;
    }
    if (phone.length == 0) {
      showMessage("Enter valid Phone number");
      return;
    }
    if (phone.length < 10 || phone.length > 10) {
      showMessage("Phone number should be 10 digit long");
      return;
    }
    if (password.length == 0) {
      showMessage("Enter valid password");
      return;
    }

    if (selectedType.userTypeId == "0") {
      showMessage("Select user type");
      return;
    }
    if (selectedCity.id == -1) {
      showMessage("Select City");
      return;
    }
    if (selectedArea.id == -1) {
      showMessage("Select Area");
      return;
    }

    if (aggreed == 0) {
      showMessage("Accept Terms and Conditions");
      return;
    }

    setState(() {
      showLoader = true;
    });
    var profile = ProfileSend(
        name,
        email,
        phone,
        password,
        selectedArea.name,
        selectedType.userTypeId,
        selectedCity.id,
        selectedArea.id,
        refralController.text.toString());
    bloc.doSignUp(profile);
  }

  void showMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
}

class ProfileSend {
  String name;
  String email;
  String phone;
  String password;
  String address;
  String type;
  int city;
  int area;
  String referal = "";
  ProfileSend(
      name, email, phone, password, address, type, city, area, referal) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.password = password;
    this.address = address;
    this.type = type;
    this.city = city;
    this.area = area;
    this.referal = referal;
  }
}

class UserType {
  String userTypeId;
  String userType;

  UserType(String id, String type) {
    userTypeId = id;
    userType = type;
  }
}
