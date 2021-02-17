import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class OrderAndReviewNetwork {

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

    Future<bool> makeOrder(String url, {Map body}) async {
      try {
        return http.post(url, body: body).then((http.Response response) {
          final String responseBody = response.body;
          print("here your response" + responseBody);
          bool getObject = json.decode(responseBody);

          return getObject;
          //_showDialog(jsondecode.toString());
        });
      } catch (ex) {
        // _showDialog("Something happened errored");
      }
    }

    Future<dynamic> IsOrdered(String url) async {
      try {
        return http.get(url).then((http.Response response) async {
          var responseBody = jsonDecode(response.body);
          var answer = responseBody["data"];
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
      Map<String, dynamic> body = {
        'user_id': userId.toString(),
        'service_id': serviceID.toString(),
        'stars': stars.toString(),
      };

      try {
        return http.post(url, body: body).then((http.Response response) {
          var responseBody = jsonDecode(response.body);
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

