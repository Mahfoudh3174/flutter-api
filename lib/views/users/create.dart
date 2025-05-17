import 'package:demo/controllers/client_controller.dart';
import 'package:demo/controllers/role_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:demo/wigets/form_field.dart';
import 'package:demo/controllers/user_controller.dart';
class CreateUser extends StatelessWidget {
  CreateUser({super.key});
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find();
  final RoleController rolesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
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
                      CustomFormField(
                        controller: nameController,
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                        label: "Full name", 
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        child: Text("Full name"),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: emailController, 
                        keyboardType: TextInputType.emailAddress, 
                        label: "Email", 
                        icon: Icons.email, 
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        child: Text("Email"),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        label: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        child: Text("Password"),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        label: "Confirm Password",
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        child: Text("Confirm Password"),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        label: "Phone",
                        icon: Icons.phone,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if(!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)){
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        child: Text("Phone"),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        if (rolesController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        return InputDecorator(
                          decoration: InputDecoration(
                            
                            
                            contentPadding: const EdgeInsets.only(top: 2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              value: rolesController.selectedRoleId.value.isEmpty 
                                  ? null 
                                  : rolesController.selectedRoleId.value,
                              isExpanded: true,
                              hint: const Text('Select Role'),
                              items: rolesController.roles.map((role) {
                                return DropdownMenuItem<String>(
                                  value: role.id.toString(),
                                  child: Text(role.name),
                                );
                              }).toList(),
                              validator: (value) => value == null ? 'Please select a role' : null,
                              onChanged: (String? value) {
                                if (value != null) {
                                  rolesController.selectedRoleId.value = value;
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 40),
                      SpecialButton(
                        text: 'Create Employee',
                        onPress: ()async {
                          if (_formKey.currentState!.validate()) {
                            if (rolesController.selectedRoleId.value.isEmpty) {
                              Get.snackbar('Error', 'Please select a role');
                              return;
                            }
                            
                            // Create employee with all fields
                            await userController.createEmployee(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                              roleId: rolesController.selectedRoleId.value,
                            );
                            
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}