
import 'package:demo/controllers/pharmacy/pharmacy_controller.dart';
import 'package:get/get.dart';

class PharmacyBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PharmacyController(), fenix: true);
  }
}