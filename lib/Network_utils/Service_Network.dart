import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ServiceNetwork {
  Future<List<dynamic>> serviceCategories(String url) async {
    try {
      return http.get(url).then((http.Response response) async {
        final String responseBody = response.body;
        List<dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        // print(ordersItem);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<List<dynamic>> service(String url) async {
    try {
      return http.get(url).then((http.Response response) async {
        final String responseBody = response.body;
        List<dynamic> ordersItem;
        ordersItem = json.decode(responseBody);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<Map<String, dynamic>> certainService(String url) async {
    try {
      return http.get(url).then((http.Response response) async {
        final String responseBody = response.body;
        Map<String, dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        // print(response.body);
        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  // ignore: missing_return

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
