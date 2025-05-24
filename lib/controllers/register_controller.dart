
import 'dart:convert';

import 'package:demo/functions/handle_validation.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController  extends GetxController{
  
  final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool isPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isConfirmPasswordHidden = false.obs;
  get formKey => _formKey;
  Future<void> register() async {
    try{
    if (_formKey.currentState!.validate()) {
      isLoading.value = true;
      final response=await http.post(Uri.parse('http://192.168.100.4:8000/api/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
        'password_confirmation': confirmPasswordController.text.trim(),
      }),
      );
      print("Response status: ${response.statusCode}");
      if(response.statusCode == 200) {
        
        Get.offAllNamed(RouteClass.getLoginRoute());
      } else {
        UsefulFunctions.handleValidationErrors(response);
      }
      
    } 
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}