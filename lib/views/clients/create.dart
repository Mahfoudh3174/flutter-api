import 'package:demo/controllers/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateClient extends StatelessWidget {
   CreateClient({super.key});
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final Clientscontroller clientsController = Get.put(Clientscontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create Client'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child:Column(children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Name',
                ), 
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }  
                  if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                ),
                
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    clientsController.createClient(
                      name: nameController.text,
                      phone: phoneController.text,
                    );
                  }
                },
                child: const Text('Create Client'),
              ),
            ]) )
            ],
        ),
      ),
    );
  }
}