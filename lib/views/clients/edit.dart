import 'package:demo/controllers/client_controller.dart';
import 'package:demo/models/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EditClientPage extends StatefulWidget {
  final Map<String, dynamic> client;

  const EditClientPage({Key? key, required this.client}) : super(key: key);

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final Clientscontroller clientController = Get.find();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client['name']);
    _phoneController = TextEditingController(text: widget.client['phone']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Client'),centerTitle: true,backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a phone number' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await clientController.updateClient(
                      id: widget.client['id'],
                      name: _nameController.text,
                      phone: _phoneController.text,
                    );
                    Get.back();
                  }
                },
                child: const Text('Update Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


