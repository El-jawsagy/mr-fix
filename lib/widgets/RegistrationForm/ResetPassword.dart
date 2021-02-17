import 'package:flutter/material.dart';
import '../../Network_utils/auth_Network.dart';
import '../UI/SimilarWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Categories.dart';
import 'User.dart';

class ResetPassword extends StatefulWidget {
  String userId;

  ResetPassword({this.userId});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  SimilarWidgets similarWidgets = new SimilarWidgets();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AuthNetwork pagesNetwork =  AuthNetwork();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Foget Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              similarWidgets.buildLogo(size),
              //-----------------password Field-------------------------------------------------
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
              //-----------------------------------------------------------------------------

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
                    MediaQuery.of(context).size.height / 30),
              ),

              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 35),
                child: FlatButton(
                  onPressed: () {
                    // TODO: implement validate function
//          validate();
                    // Navigator.pop(context);
                    validateForm();
                  },
                  child: Text(
                    "Forget Password",
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
    );
  }

  Future<void> validateForm() async {
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      //SharedPreferences prefs = await SharedPreferences.getInstance();

      User user = await pagesNetwork.createAndForgetUser(
          url: 'https://mr-fix.org/en/api/addnewpassword',
          body: {
            'token':
                'hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv',
            'id': widget.userId,
            'password': passwordController.text
          });
      //print(newUser.toMap());

      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            ModalRoute.withName('/ResetPassword'));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("idPref", /*3*/ user.userID);
        await prefs.setString("namePref", user.name);
        await prefs.setString("emailPref", user.email);
        await prefs.setString("phonePref", user.phoneNumber);
        await prefs.setString("tokenPref", user.token);
        await prefs.setString("locationPref", user.location);
      }

      formState.reset();
    }
  }
}
