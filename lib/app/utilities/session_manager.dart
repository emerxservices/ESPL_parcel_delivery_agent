import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  //constants prefs key string
  static const String USERID = "USERID";
  static const String userToken = "userToken";
  static const String isLogin = "isLogin";
  static const String isOnline = "isOnline";

  static final SessionManager _singleton = SessionManager._internal();

  factory SessionManager() {
    return _singleton;
  }

  SessionManager._internal();

  //common for all string type prefs
  Future<void> setString(String key, String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  Future<String?> getString(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? null;
  }

  //common for all boolean type prefs
  Future<bool?> setBoolean(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getBoolean(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  //common for all int type prefs
  void setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  onLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLogin);
    await prefs.remove(isOnline);
    await prefs.remove(USERID);
    await prefs.remove(userToken);
  }

  // Future<String?> getLoginData() async {
  //   return await getString(loginData);
  // }

  Future<bool> removeData(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}
