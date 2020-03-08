import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mr_fix/Network_utils/Pages_Network.dart';
import 'package:mr_fix/UI/SimilarWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Categories.dart';
import 'User.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController extraLocationController = new TextEditingController();

  SimilarWidgets similarWidgets = new SimilarWidgets();
  PagesNetwork pagesNetwork = new PagesNetwork();

  final _formKey = GlobalKey<FormState>();

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
    print(coords);

    final double latitude = double.parse(coords[0].substring(5));
    final double longitude = double.parse(coords[1].substring(6));
    print(latitude);
    print(longitude);
    //print(longitude.toString());
    final List<Placemark> placemarks =
        await _geolocator.placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.thoroughfare +
            ', ' +
            pos.subThoroughfare +
            ', ' +
            pos.locality +
            ', ' +
            pos.subLocality;
      });
    }

    print(_placemark);
  }

//////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_placemark == ", ") {
      errorLocation =
          "Google can't recognize your location, Please Write it Manually";
    } else {
      locationController.text = _placemark.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: size.height / 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                similarWidgets.nameField(nameController, context),

//-------------------------------Email Field-------------------------------------------------
                similarWidgets.emailField(emailController, context),
                //------------------------------------------------------------------------------------
                similarWidgets.phoneField(phoneController),

                similarWidgets.locationField(
                    locationController, _onLookupAddressPressed, context),

                similarWidgets.extraLocationField(
                    extraLocationController, context),

                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    errorLocation,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                Container(
//      padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      //suffixIcon: buildEye(visible),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "password_shouldnt_be_empty";
                      } else if (value.length < 6) {
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
                  child: TextFormField(
                      obscureText: true,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "The Password cannot be empty";
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          return "Not Matched";
                        }
                        return null;
                      }),
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.height / 30,
                      0,
                      MediaQuery.of(context).size.height / 30,
                      MediaQuery.of(context).size.height / 60),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height / 30),
                  child: FlatButton(
                    onPressed: () {
                      // TODO: implement validate function
                      validateForm();
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    shape: StadiumBorder(),
                    color: Colors.yellow,
                    //splashColor: Colors.indigo,
                    padding: EdgeInsets.fromLTRB(
                        size.width / 8, 15, size.width / 8, 15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String fcmToken = prefs.getString("fcm_token");
      print("your token is $fcmToken");

      User newUser = User(
          token: "hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv",
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          phoneNumber: phoneController.text,
          location: locationController.text,
          address: extraLocationController.text);

      User user = await pagesNetwork.createAndForgetUser(
          context, 'http://mr-fix.org/en/api/register',
          body: newUser.toMap());
      print(newUser.toMap());
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            ModalRoute.withName('/SignUp'));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("idPref", /*3*/ user.userID);
        await prefs.setString("namePref", user.name);
        await prefs.setString("emailPref", user.email);
        await prefs.setString("phonePref", user.phoneNumber);
        await prefs.setString("tokenPref", user.token);
        await prefs.setString("locationPref", user.location);
        await prefs.setString("addressPref", user.address);
      }
      formState.reset();
    }
  }
}
