import 'package:demo/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserPage extends GetView<UserController> {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: const Center(
        child: Text('Users'),
      ),
    );
  }
}