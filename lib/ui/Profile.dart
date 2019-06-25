import 'package:flutter/material.dart';
import 'package:nfresh/bloc/cities_bloc.dart';
import 'package:nfresh/models/area_model.dart';
import 'package:nfresh/models/city_model.dart';
import 'package:nfresh/models/profile_model.dart';
import 'package:nfresh/resources/prefrences.dart';

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
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();

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
        passwordController.text = profile.password;
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
                  Navigator.pop(context);
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
                                        autofocus: true,
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
                                        focusNode: focus,
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
}
