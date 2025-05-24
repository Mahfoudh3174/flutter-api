import 'dart:convert';

import 'package:demo/models/user.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Example getters and setters
  String? getToken() => _prefs.getString('token');

  Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  Future<void> clearToken() async {
    await _prefs.remove('token');
  }
  Future<void> saveUser(User user) async {
  final userJson = jsonEncode(user.toJson());
  await _prefs.setString('user', userJson);
}

User? getUser() {
  final userString = _prefs.getString('user');
  if (userString != null) {
    final Map<String, dynamic> json = jsonDecode(userString);
    return User.fromJson(json);
  }
  return null;
}
  void clearUser() async {
    await _prefs.remove('user');
  }

}
