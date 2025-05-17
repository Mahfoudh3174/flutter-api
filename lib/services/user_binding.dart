import "package:get/get.dart";
import "package:demo/controllers/user_controller.dart";

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
