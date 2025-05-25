import 'dart:convert';

import 'package:demo/models/pharmacy.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PharmacyController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Pharmacy> pharmacies = <Pharmacy>[].obs;
  final StorageService storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    fetchPharmacies();
  }

  Future<void> fetchPharmacies() async {
    isLoading.value = true;
    try {
      final token = storage.getToken();

      print("========Token: $token");

      final response = await http.get(
        Uri.parse('http://192.168.100.4:8000/api/pharmacies'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      print("========Response bidy: ${jsonDecode(response.body)}");

      print("========Response status code: ${response.statusCode}");
      print("========Response headers: ${response.headers}");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        pharmacies.value = data.map((item) => Pharmacy.fromJson(item)).toList();
        print("========Pharmacies loaded: ${pharmacies.length}");
      } else {
        print("========Error: ${response.body}");
        Get.snackbar('Error', 'Failed to load pharmacies');
      }
    } catch (e) {
      Get.snackbar('Error', 'attention load pharmacies: ${e.toString()} ');
      print("========Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
