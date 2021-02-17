import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<int> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("idPref");
    return datId;
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("namePref");
    return datId;
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("emailPref");
    return datId;
  }

  static Future<String> getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("passwordPref");
    return datId;
  }

  static Future<String> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("phonePref");
    return datId;
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("tokenPref");
    return datId;
  }
}
