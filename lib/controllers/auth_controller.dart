
import 'package:get/get.dart';
import 'package:demo/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authcontroller extends GetxController {
    final RxBool isLoggedIn = false.obs;
final storage=FlutterSecureStorage();
  final RxString user_name = ''.obs;
  final RxString user_email = ''.obs;
  final RxString user_phone = ''.obs;
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.100.13:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON.
      var data = jsonDecode(response.body);
      print(data['user']);
      User user = User.fromJson(data['user']);
      String token = data['token'];
      print(token);
      storage.write(key: 'token', value: token);
      user_name.value = user.name;
      user_email.value = user.email;
      user_phone.value = user.phone;
      Get.snackbar('Login Successful', 'Welcome ${user.name}');
      Get.offAllNamed('/'); // Navigate to the home page
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      Get.snackbar('Login Failed', 'Invalid email or password');
    }
  }
}
