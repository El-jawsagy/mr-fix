import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/Categories.dart';
import 'Preferences/Perference.dart';
import './widgets/RegistrationForm/EditProfile.dart';
import './widgets/RegistrationForm/ForgetPassword.dart';
import './widgets/RegistrationForm/LoginPage.dart';
import './widgets/RegistrationForm/ResetPassword.dart';
import './widgets/RegistrationForm/SignUp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mr Fix',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        /* localizationsDelegates: [
          const TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('ar', ''),
        ],*/
        home: FutureBuilder(
            future: Preference.getID(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                return MyHomePage();
              }
              return LoginPage();
            }),
        routes: {
          '/ForgetPassword': (context) => ForgetPassword(),
          '/SignUp': (context) => SignUp(),
          '/LoginPage': (context) => LoginPage(),
          '/EditProfile': (context) => EditProfile(),
          '/MyHomePage': (context) => MyHomePage(),
          '/ResetPassword': (context) => ResetPassword(),
          //'/MapPage': (context) => MapPage(),
        });
  }
}

String translate = 'en';
