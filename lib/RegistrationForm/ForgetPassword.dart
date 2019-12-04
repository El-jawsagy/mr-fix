import 'package:flutter/material.dart';
import 'package:mr_fix/Network_utils/Pages_Network.dart';
import 'package:mr_fix/UI/SimilarWidgets.dart';

import 'ResetPassword.dart';
import 'User.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  SimilarWidgets similarWidgets = new SimilarWidgets();
  TextEditingController emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PagesNetwork pagesNetwork = new PagesNetwork();

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
              //-----------------Email Field-------------------------------------------------
              similarWidgets.emailField(emailController, context),
              //-----------------------------------------------------------------------------
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

      User newUser = User(
          token: "hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv",
          email: emailController.text);

      User user = await pagesNetwork.forgetPassword(
          context, 'http://mr-fix.org/en/api/forgetpassword',
          body: newUser.toForget());
      //print(newUser.toMap());
      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ResetPassword(
            userId: '${user.userID}',
          );
        }));
        /*SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("idPref", /*3*/ user.userID);
        prefs.setString("namePref", user.name);
        prefs.setString("emailPref", user.email);
        prefs.setString("phonePref", user.phoneNumber);
        prefs.setString("tokenPref", user.token);*/
      }
      formState.reset();
    }
  }
}
