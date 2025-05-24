import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/register_controller.dart';
import 'package:demo/wigets/form_field.dart';
import 'package:demo/wigets/special_button.dart';

class Register extends GetView<RegisterController> {
  Register({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                       MediaQuery.of(context).padding.top,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Compact logo section
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue[50],
                  child: const Icon(Icons.person, size: 50, color: Colors.blue),
                ),
                const SizedBox(height: 24),
                // Title section
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Text(
                            'Welcome to Our App',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sign up to continue',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 24),
                // Compact form
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      _buildFormFieldSection(context),
                      const SizedBox(height: 16),
                      _buildActionSection(context),
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

  Widget _buildFormFieldSection(BuildContext context) {
    return Column(
      children: [
        CustomFormField(
          controller: controller.nameController,
          keyboardType: TextInputType.name,
          label: 'Name',
          icon: Icons.person,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 12),
        CustomFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          label: 'Email',
          icon: Icons.email,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your email';
            if (!GetUtils.isEmail(value!)) return 'Please enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        CustomFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          label: 'Phone Number',
          icon: Icons.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your phone number';
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Obx(() => TextFormField(
          controller: controller.passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: controller.isPasswordHidden.value,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            border: Theme.of(context).inputDecorationTheme.border,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordHidden.value ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () => controller.isPasswordHidden.toggle(),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your password';
            if (value!.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        
        ),
        SizedBox(height: 12),
        Obx(() => TextFormField(
          controller: controller.confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: controller.isConfirmPasswordHidden.value,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            border: Theme.of(context).inputDecorationTheme.border,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordHidden.value ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () => controller.isConfirmPasswordHidden.toggle(),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please confirm your password';
            if (value != controller.passwordController.text) return 'Passwords do not match';
            return null;
          },
        )),
        ],
    );
  }

 
  Widget _buildActionSection(BuildContext context) {
    return Column(
      children: [
        SpecialButton(
          text: 'Sign Up',
          onPress: () async {
            if (controller.formKey.currentState?.validate() ?? false) {
              await controller.register();
            }
          },
          color: Colors.blue,
          textColor: Colors.white,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('or', style: TextStyle(color: Colors.grey[600])),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Already have an account? Sign In',
            style: TextStyle(color: Colors.blue[600]),
          ),
        ),
      ],
    );
  }
}