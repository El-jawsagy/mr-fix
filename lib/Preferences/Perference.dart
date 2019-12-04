import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<int> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("idPref");
    print(datId);
    return datId;
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("namePref");
    print(datId);
    return datId;
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("emailPref");
    print(datId);
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
    print(datId);
    return datId;
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("tokenPref");
    print(datId);
    return datId;
  }
}
