import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/RegistrationForm/User.dart';
import '../widgets/UI/SimilarWidgets.dart';

class AuthNetwork {
  Future<User> userLogin({
    String url,
    Map body,
  }) async {
    try {
      http.Response response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        print(response.body);
        print(response.statusCode);
        if (response.body == "false" || response.body == "password wrong") {
          return null;
        } else {
          Map<String, dynamic> getObject = json.decode(response.body);
          User userGet = User.fromJson(getObject);
          print(userGet);

          return userGet;
        }
      } else {
        print("ex happend");
        return null;
      }
    } catch (ex) {}
    return null;
  }

  Future<User> createAndForgetUser({String url, Map body}) async {
    try {
      http.Response response = await http.post(url, body: body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        if (response.body == "false" ||
            response.body == "Email already exist") {
          return null;
        }
      } else if (response.statusCode == 201) {
        Map<String, dynamic> getObject = json.decode(response.body);
        print(getObject);

        User userGet = User.fromJson(getObject);
        print(userGet);

        return userGet;
      } else {
        return null;
      }
    } catch (ex) {
      //showDialog("Something happened errored");
    }
  }

  Future<User> forgetPassword(BuildContext con, String url, {Map body}) async {
    SimilarWidgets similarWidgets = new SimilarWidgets();
    //similarWidgets.showWaiting(con);

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;

        Map<String, dynamic> getObject = json.decode(responseBody);

        if (getObject['status'] == "false") {
          similarWidgets.showDialogWidget("Your Email is wrong", con);
          return null;
        } else {
          User userGet = User.fromJson(json.decode(responseBody));

          return userGet;
        }
      });
    } catch (ex) {
      //showDialog("Something happened errored");
    }
  }

  Future<User> updateUser(String url, {Map body}) async {
    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;

        // Map<String, dynamic> getObject = json.decode(responseBody);

        User userGet = User.fromJson(json.decode(responseBody));

        return userGet; //User.fromJson(json.decode(response.body));
      });
    } catch (ex) {
      // _showDialog("Something happened errored");
    }
  }

/*//---------------------------will be handled--------
  Future<User> resetPassword(BuildContext con, String url, {Map body}) async {
   
    SimilarWidgets similarWidgets = new SimilarWidgets();
    //similarWidgets.showWaiting(con);

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;
        Map<String, dynamic> getObject = json.decode(responseBody);

        User userGet = User.fromJson(json.decode(responseBody));

        return userGet;
      });
    } catch (ex) {
      //showDialog("Something happened errored");
    }
  }
//---------------------------will be handled--------*/

  Future<bool> checkConnectivity() async {
    bool connect;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
