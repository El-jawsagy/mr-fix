import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../Network_utils/auth_Network.dart';
import '../UI/SimilarWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  SimilarWidgets similarWidgets = new SimilarWidgets();

  AuthNetwork authNetwork = AuthNetwork();

  final _EditKey = GlobalKey<FormState>();
  int id;
  String pass;

  Future<void> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    nameController.text = prefs.get("namePref");
    emailController.text = prefs.get("emailPref");
    phoneController.text = prefs.get("phonePref");
    setState(() {
      if (check) {
        if (_placemark == ", ") {
          errorLocation =
              "Google can't recognize your location, Please Write it Manually";
        } else {
          locationController.text = "";

          locationController.text = _placemark.toString();
        }
      } else {
        locationController.text = prefs.get("locationPref");
      }

      id = prefs.get("idPref");
      pass = prefs.get("passwordPref");
    });
  }

  ////////////////////////////////////////////////////////////////////////////
  /*Return Coordiantes from geolocator and then take this coordinates to get place */
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  String _placemark = '', errorLocation = '';
  bool check = false;

  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !true
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        //
      });
  }

  Future<void> _onLookupAddressPressed() async {
    final List<String> coords = _currentPosition.toString().split(',');

    final double latitude = double.parse(coords[0].substring(5));
    final double longitude = double.parse(coords[1].substring(6));
    
    //print(longitude.toString());
    final List<Placemark> placemarks =
        await _geolocator.placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.thoroughfare + ', ' + pos.locality;
      });
    }
    check = true;

  }

//////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Edit Your Profile" /*AppLocalizations.of(context).translate("Edit Your Profile")*/),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: retrieveData(),
            builder: (context, snapshots) {
              return Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _EditKey,
                    child: Column(children: <Widget>[
                      similarWidgets.buildLogo(size),
                      similarWidgets.nameField(
                        nameController,
                        context,
                      ),
                      similarWidgets.emailField(
                        emailController,
                        context,
                      ),
                      similarWidgets.phoneField(
                        phoneController,
                      ),
                      similarWidgets.locationField(
                          locationController, _onLookupAddressPressed, context),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 60),
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          errorLocation,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Password",
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return null;
                            }
                            if (value.length < 6) {
                              return "password_should_be_long";
                            }
                            return null;
                          },
                        ),
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.height / 30,
                            0,
                            MediaQuery.of(context).size.height / 30,
                            MediaQuery.of(context).size.height / 30),
                      ),
                      Container(
                        child: FlatButton(
                          onPressed: () {
                            validateForm();
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          shape: StadiumBorder(),
                          color: Colors.yellow,
                          //splashColor: Colors.indigo,
                          padding: EdgeInsets.fromLTRB(
                              size.width / 8, 15, size.width / 8, 15),
                        ),
                      )
                    ]),
                  )));
            }));
  }

  Future<void> validateForm() async {
    if (_EditKey.currentState.validate()) {
      User newUser = User(
          token: "hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv",
          userIDStr: "$id",
          name: nameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          location: locationController.text,
          password:
              passwordController.text == "" ? pass : passwordController.text);

      User user = await authNetwork.updateUser(
          'https://mr-fix.org/en/api/updateprofile',
          body: newUser.toUpdate());

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("idPref", /*3*/ user.userID);
        await prefs.setString("namePref", user.name);
        await prefs.setString("emailPref", user.email);
        await prefs.setString("phonePref", user.phoneNumber);
        await prefs.setString("tokenPref", user.token);

        print("hii: ${prefs.get("idPref")}");
        similarWidgets.showDialogWidget(
            "Your Data is updated successfully ", context);
        Navigator.pop(context);
      } else {
        //  _showDialog("make_sure_of_email_or_password");
      }
    }
  }
}
