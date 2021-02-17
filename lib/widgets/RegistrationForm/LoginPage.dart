import 'package:flutter/material.dart';
import '../../Network_utils/auth_Network.dart';
import '../UI/SimilarWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Categories.dart';
import 'User.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  SimilarWidgets similarWidgets = new SimilarWidgets();
  AuthNetwork pagesNetwork = AuthNetwork();
  bool passwordVisibility = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                similarWidgets.buildLogo(size),
//-------------------------------Email Field-------------------------------------------------
                similarWidgets.emailField(emailController, context),
                //------------------------------------------------------------------------------------
                passwordFormField(passwordVisibility),
                buildForgotPassword(),
                buildLoginButton(size),
                buildSignUpText(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordFormField(bool visible) {
    return Container(
//      padding: EdgeInsets.only(left: 20, right: 15),
      child: TextFormField(
        obscureText: !visible,
        controller: passwordController,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Password",
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          suffixIcon: buildEye(visible),
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
          MediaQuery.of(context).size.height / 100),
    );
  }

  Widget buildLoginButton(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 30,
          bottom: MediaQuery.of(context).size.height / 60),
      child: FlatButton(
        onPressed: () {
          validateForm();
        },
        child: Text(
          "Sign In",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        shape: StadiumBorder(),
        color: Colors.yellow,
        //splashColor: Colors.indigo,
        padding: EdgeInsets.fromLTRB(size.width / 8, 15, size.width / 8, 15),
      ),
    );
  }

  Widget buildSignUpText(Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Don't Have an account yet, "),
          InkWell(
            child: Text(
              "SignUp Now",
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, '/SignUp');
            },
          )
        ],
      ),
    );
  }

  Widget buildEye(bool visible) {
    return IconButton(
        icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            passwordVisibility = !passwordVisibility;
          });
        });
  }

  Widget buildForgotPassword() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 45),
      child: Align(
          child: InkWell(
            child: Text(
              "Forgot Password?!",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/ForgetPassword'),
          ),
          alignment: Alignment.centerLeft),
    );
  }

  Future<bool> forgotPassword() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('You Really Forgot Your Password?!!!'),
            content: new Text('Are you really that dumb?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> validateForm() async {
    if (_formKey.currentState.validate()) {
      similarWidgets.showWaiting(context);
      User newUser = User(
          token: "hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv",
          email: emailController.text,
          password: passwordController.text);

      await pagesNetwork
          .userLogin(
              url: 'https://mr-fix.org/en/api/login', body: newUser.toLogin())
          .then((user) async {
        print("her is $user");
        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt("idPref", user.userID);
          await prefs.setString("namePref", user.name);
          await prefs.setString("emailPref", user.email);
          await prefs.setString("phonePref", user.phoneNumber);
          await prefs.setString("passwordPref", passwordController.text);
          await prefs.setString("tokenPref", user.token);
          await prefs.setString("locationPref", user.location);
          _formKey.currentState.reset();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          Navigator.pop(context);
          similarWidgets.showDialogWidget(
              "make sure of email or password", context);
        }
      });
    }
  }
}
