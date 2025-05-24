
import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/controllers/register_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Authcontroller(), permanent: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
    
  }
}