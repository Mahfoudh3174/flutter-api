import 'package:demo/controllers/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:demo/wigets/form_field.dart';
class CreateUser extends StatelessWidget {
  CreateUser({super.key});
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Clientscontroller clientsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Create Employee',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blue[800]),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Header with icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_add, size: 40, color: Colors.blue[800]),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    'Add New Employee',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in the employee details',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormField(controller: nameController,icon: Icons.person,keyboardType: TextInputType.name,label: "Full name", child: Text('Name'), validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },),
                        const SizedBox(height: 20),
                        CustomFormField(child: Text('Email'), controller: emailController, keyboardType: TextInputType.emailAddress, label: "email", icon: Icons.email, validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        }),
                        SizedBox(height: 20),
                        CustomFormField(child: Text("Password"), controller: passwordController, keyboardType: TextInputType.visiblePassword, label: "password", icon: Icons.lock, validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        }),
                        SizedBox(height: 20),
                        CustomFormField(child: Text("Confirm Password"), controller: confirmPasswordController, keyboardType: TextInputType.visiblePassword, label: "confirm password", icon: Icons.lock, validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        }),
                        SizedBox(height: 20),
                        CustomFormField(child: Text("Phone"), controller: phoneController, keyboardType: TextInputType.phone, label: "phone", icon: Icons.phone, validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone';
                          }if(!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)){
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        }),
                        const SizedBox(height: 40),
                        // Create button
                        SpecialButton(
                          text: 'Create Client',
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              clientsController.createClient(
                                name: nameController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}