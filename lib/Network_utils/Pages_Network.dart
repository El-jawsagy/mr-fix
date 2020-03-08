import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mr_fix/RegistrationForm/User.dart';
import 'package:mr_fix/UI/SimilarWidgets.dart';

class PagesNetwork {
  Future<List<dynamic>> serviceCategories(String url) async {
    try {
      return http.get(url).then((http.Response response) async {
        final String responseBody = response.body;
        List<dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        print(ordersItem);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<List<dynamic>> service(String url) async {
    print(url);
    try {
      return http.get(url).then((http.Response response) async {
        // print();
        final String responseBody = response.body;
        List<dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        print(ordersItem);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<Map<String, dynamic>> certainService(String url) async {
    print(url);
    try {
      return http.get(url).then((http.Response response) async {
        // print();
        final String responseBody = response.body;
        Map<String, dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        print(ordersItem);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  // ignore: missing_return
  Future<User> userLogin(BuildContext con, String url, {Map body}) async {
    SimilarWidgets similarWidgets = new SimilarWidgets();

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;
        if (response.body == "false" || response.body == "password wrong") {
          return null;
        }
        print(responseBody);
        Map<String, dynamic> getObject = json.decode(responseBody);

        print(getObject);

        User userGet = User.fromJson(json.decode(responseBody));
        print(userGet.name);

        if (userGet.email != null) {
          return userGet;
        } else {
          Navigator.of(con).pop(null);
          return null;
        }
      });
    } catch (ex) {
      similarWidgets.showDialogWidget("Something happened errored", con);
    }

    similarWidgets.showDialogWidget("Something happened errored", con);
  }

  Future<User> createAndForgetUser(BuildContext con, String url,
      {Map body}) async {
    print(body);
    SimilarWidgets similarWidgets = new SimilarWidgets();
    similarWidgets.showWaiting(con);

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;
        print(json.decode(responseBody));
        Map<String, dynamic> getObject = json.decode(responseBody);

        print("000000000000000000000");
        print(getObject);

        User userGet = User.fromJson(json.decode(responseBody));

        return userGet;

        //User.fromJson(json.decode(response.body));
      });
    } catch (ex) {
      //showDialog("Something happened errored");
    }
  }

  Future<User> forgetPassword(BuildContext con, String url, {Map body}) async {
    print(body);
    SimilarWidgets similarWidgets = new SimilarWidgets();
    //similarWidgets.showWaiting(con);

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;
        //print(json.decode(responseBody));
        Map<String, dynamic> getObject = json.decode(responseBody);

        //print("000000000000000000000");
        print(getObject);

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

/*//---------------------------will be handled--------
  Future<User> resetPassword(BuildContext con, String url, {Map body}) async {
    print(body);
    SimilarWidgets similarWidgets = new SimilarWidgets();
    //similarWidgets.showWaiting(con);

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;
        Map<String, dynamic> getObject = json.decode(responseBody);

        //print("000000000000000000000");
        print(getObject);

        User userGet = User.fromJson(json.decode(responseBody));

        return userGet;
      });
    } catch (ex) {
      //showDialog("Something happened errored");
    }
  }
//---------------------------will be handled--------*/

  Future<User> updateUser(String url, {Map body}) async {
    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;
        print(responseBody);
        Map<String, dynamic> getObject = json.decode(responseBody);

        User userGet = User.fromJson(json.decode(responseBody));

        return userGet; //User.fromJson(json.decode(response.body));
      });
    } catch (ex) {
      // _showDialog("Something happened errored");
    }
  }

  Future<bool> makeOrder(String url, {Map body}) async {
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;

        bool getObject = json.decode(responseBody);

        print(getObject);
        return getObject;
        //_showDialog(jsondecode.toString());
      });
    } catch (ex) {
      // _showDialog("Something happened errored");
    }
  }

  Future<dynamic> IsOrdered(String url) async {
    print(url);
    try {
      return http.get(url).then((http.Response response) async {
        // print();
        var responseBody = jsonDecode(response.body);
        var answer = responseBody["data"];
        print(answer);
        return answer;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<String> MakeReview(
      String url, int userId, int serviceID, double stars) async {
    print(url);
    print(userId);
    print(serviceID);
    print(stars);
    Map<String, dynamic> body = {
      'user_id': userId.toString(),
      'service_id': serviceID.toString(),
      'stars': stars.toString(),
    };

    try {
      return http.post(url, body: body).then((http.Response response) {
        var responseBody = jsonDecode(response.body);
        print(responseBody["data"]);
        final String answer = responseBody["data"];
        return answer;
      });
    } catch (ex) {
      //showDialog("Something happened errored");
    }
  }

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
