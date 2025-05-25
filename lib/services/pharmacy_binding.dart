
import 'package:demo/controllers/medication/medication_controller.dart';
import 'package:demo/controllers/pharmacy/pharmacy_controller.dart';
import 'package:get/get.dart';

class PharmacyBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PharmacyController(), fenix: true);
    Get.lazyPut(() => MedicationController(), fenix: true);
  }
}