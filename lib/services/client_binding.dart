// home_binding.dart
import 'package:get/get.dart';
import 'package:demo/controllers/client_controller.dart';
class ClientBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Clientscontroller());
  }
}