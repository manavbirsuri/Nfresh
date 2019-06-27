import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfresh/bloc/cities_bloc.dart';
import 'package:nfresh/bloc/update_address_bloc.dart';
import 'package:nfresh/bloc/update_password_bloc.dart';
import 'package:nfresh/bloc/update_profile_bloc.dart';
import 'package:nfresh/models/area_model.dart';
import 'package:nfresh/models/city_model.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

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
    return StateProfilePage();
  }
}

class StateProfilePage extends State<stateProfile> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController conPasswordController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  var _prefs = SharedPrefs();

  ProfileModel profile;
  List<CityModel> cities = [];
  List<AreaModel> areas = [];
  List<AreaModel> cityAreas = [];
  CityModel selectedCity;
  AreaModel selectedArea;

  var blocCity = CityBloc();
  var blocProfile = UpdateProfileBloc();
  var blocAddress = UpdateAddressBloc();
  var blocPassword = UpdatePasswordBloc();
  String customerType = "";

  ProgressDialog dialog;

  @override
  void initState() {
    super.initState();
    blocCity.fetchData();
    _prefs.getProfile().then((value) {
      setState(() {
        profile = value;
        nameController.text = profile.name;
        emailController.text = profile.email;
        phoneController.text = profile.phoneNo;
        addressController.text = profile.address;
        if (profile.type == 1) {
          customerType = "Retailer";
        } else if (profile.type == 2) {
          customerType = "Customer Daily";
        } else if (profile.type == 3) {
          customerType = "Customer Monthly";
        }
        //  cityController.text = profile.city;
        //  areaController.text = profile.name;
      });

      blocCity.cities.listen((res) {
        setState(() {
          this.cities = res.cities;
          for (int i = 0; i < cities.length; i++) {
            var city = cities[i];
            if (profile.city == city.id) {
              selectedCity = city;
            }
          }

          this.areas = res.areas;
          for (int i = 0; i < areas.length; i++) {
            var area = areas[i];
            if (profile.area == area.id) {
              selectedArea = area;
            }
          }

          getCityAreas(selectedCity);
        });
      });
    });
  }

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
                  //Navigator.pop(context);
                  updateProfileWebservice(nameController.text.trim().toString(),
                      emailController.text.trim().toString());
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    "Update",
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
                                        // autofocus: true,
                                        controller: nameController,
                                        decoration: InputDecoration(labelText: 'Name'),
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(focus);
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextFormField(
                                        //  focusNode: focus,
                                        controller: emailController,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(labelText: 'Email'),
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).requestFocus(focus1);
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text(
                                          "Phone Number",
                                          style: TextStyle(
                                            color: Colors.colorlightgrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        subtitle: Text(
                                          profile.phoneNo,
                                          style: TextStyle(
                                            color: Colors.black,
                                            // fontSize: 12,
                                          ),
                                        ),
                                        trailing: Icon(Icons.chevron_right),
                                        onTap: () {
                                          _showPhoneDialog(context);
                                        },
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.colorlightgrey,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text("Update Password"),
                                        trailing: Icon(Icons.chevron_right),
                                        onTap: () {
                                          _showPasswordDialog(context);
                                        },
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.colorlightgrey,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text("Update Address"),
                                        trailing: Icon(Icons.chevron_right),
                                        onTap: () {
                                          _showAddressDialog(context);
                                        },
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.colorlightgrey,
                                    ),
                                    /*  Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "City",
                                            style: TextStyle(
                                              color: Colors.colorlightgrey,
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Center(
                                        child: DropdownButtonFormField<CityModel>(
                                          decoration: InputDecoration.collapsed(hintText: ''),
                                          value: selectedCity,
                                          items: cities.map((CityModel value) {
                                            return new DropdownMenuItem<CityModel>(
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
                                    Divider(
                                      height: 1,
                                      color: Colors.colorlightgrey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Area",
                                            style: TextStyle(
                                              color: Colors.colorlightgrey,
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Center(
                                        child: DropdownButtonFormField<AreaModel>(
                                          decoration: InputDecoration.collapsed(hintText: ''),
                                          value: selectedArea,
                                          items: cityAreas.map((AreaModel value) {
                                            return new DropdownMenuItem<AreaModel>(
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
                                    Divider(
                                      height: 1,
                                      color: Colors.colorlightgrey,
                                    ),*/
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
                                        customerType,
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

  void getCityAreas(CityModel selectedCity) {
    cityAreas = [];
    for (int i = 0; i < areas.length; i++) {
      var modelArea = areas[i];
      if (modelArea.cityId == selectedCity.id) {
        cityAreas.add(modelArea);
      }
    }
    if (cityAreas.length > 0) {
      selectedArea = cityAreas[0];
    } else {
      selectedArea = null;
    }
  }

  void _showPasswordDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Center(
            child: SingleChildScrollView(
          child: AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "Update Password",
                      style: TextStyle(
                          color: Colors.colorgreen, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          obscureText: true,
                          controller: oldPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Old Password',
                            hasFloatingPlaceholder: true,
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: TextField(
                              controller: newPasswordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hasFloatingPlaceholder: true,
                                  labelText: 'New Password'),
                              obscureText: true,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: TextField(
                            obscureText: true,
                            controller: conPasswordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Confirm Password',
                                hasFloatingPlaceholder: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Flexible(
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      splashColor: Colors.black12,
                      color: Colors.colorgreen,
                      onPressed: () {
                        updatePasswordWebservice(
                            oldPasswordController.text.toString(),
                            newPasswordController.text.toString(),
                            conPasswordController.text.toString());
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  void _showPhoneDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Center(
            child: SingleChildScrollView(
          child: AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "Update Contact",
                      style: TextStyle(
                          color: Colors.colorgreen, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter new number',
                            hasFloatingPlaceholder: true,
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                  // Flexible(
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      splashColor: Colors.black12,
                      color: Colors.colorgreen,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  void _showAddressDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Center(
            child: SingleChildScrollView(
          child: AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "Update Address",
                      style: TextStyle(
                          color: Colors.colorgreen, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.colorgreen)),
                            hasFloatingPlaceholder: true,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          controller: addressController,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "City",
                                style: TextStyle(
                                  color: Colors.colorlightgrey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Center(
                            child: DropdownButtonFormField<CityModel>(
                              decoration: InputDecoration.collapsed(hintText: selectedCity.name),
                              value: null,
                              items: cities.map((CityModel value) {
                                return new DropdownMenuItem<CityModel>(
                                  value: value,
                                  child: new Text(value.name),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCity = newValue;
                                  getCityAreas(newValue);
                                  Navigator.of(context).pop();
                                  _showAddressDialog(context);
                                });
                              },
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.colorlightgrey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Area",
                                style: TextStyle(
                                  color: Colors.colorlightgrey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Center(
                            child: DropdownButtonFormField<AreaModel>(
                              decoration: InputDecoration.collapsed(hintText: selectedArea.name),
                              value: null,
                              items: cityAreas.map((AreaModel value) {
                                return new DropdownMenuItem<AreaModel>(
                                  value: value,
                                  child: new Text(value.name),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedArea = newValue;
                                  Navigator.of(context).pop();
                                  _showAddressDialog(context);
                                });
                              },
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.colorlightgrey,
                        ),
                      ],
                    ),
                  ),
                  // Flexible(
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      splashColor: Colors.black12,
                      color: Colors.colorgreen,
                      onPressed: () {
                        var localAddress = addressController.text.toString();
                        if (localAddress.length > 0) {
                          dialog = new ProgressDialog(context, ProgressDialogType.Normal);
                          dialog.setMessage("Please wait...");
                          dialog.show();

                          blocAddress.fetchData(localAddress, selectedCity.id, selectedArea.id);
                          blocAddress.profileData.listen((response) {
                            dialog.hide();
                            if (response.status == "true") {
                              Navigator.of(context).pop();
                              String data = jsonEncode(response.profile);
                              _prefs.saveProfile(data);
                            }
                            Toast.show(response.msg, context,
                                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                          });
                        } else {
                          Toast.show("Address cannot be empty", context,
                              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  // call webservice for update profile
  void updateProfileWebservice(String name, String email) {
    if (name.length == 0) {
      Toast.show("Name should not be empty", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    if (email.length == 0 || !isEmail(email)) {
      Toast.show("Enter valid email", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }

    dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    dialog.setMessage("Please wait...");
    dialog.show();
    blocProfile.fetchData(name, email);
    blocProfile.profileData.listen((response) {
      dialog.hide();
      if (response.status == "true") {
        // Navigator.of(context).pop();
        String data = jsonEncode(response.profile);
        _prefs.saveProfile(data);
      }
      Toast.show(response.msg, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    });
  }

  // call webservice for update profile
  void updatePasswordWebservice(String oldPass, String newPass, String conPass) {
    if (oldPass.length == 0) {
      Toast.show("Enter old password", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    if (newPass.length == 0) {
      Toast.show("Enter new password", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    if (conPass.length == 0) {
      Toast.show("Confirm new password", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    if (conPass != newPass) {
      Toast.show("Password not  matched", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }

    dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    dialog.setMessage("Please wait...");
    dialog.show();
    blocPassword.fetchData(oldPass, newPass);
    blocPassword.passwordData.listen((response) {
      dialog.hide();
      var obj = jsonDecode(response);
      if (obj['status'] == "true") {
        Navigator.of(context).pop();
      }
      Toast.show(obj['msg'], context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    });
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
}
