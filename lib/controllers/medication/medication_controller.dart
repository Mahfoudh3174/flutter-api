import 'dart:convert';

import 'package:demo/functions/handle_validation.dart';

import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

import 'package:demo/models/medication.dart';
import 'package:http/http.dart' as http;

class MedicationController extends GetxController {
  var medications = <Medication>[].obs;
  var cartItems = <Medication>[].obs;
  var isLoading = false.obs;
  late int id;
  final StorageService storage = Get.find<StorageService>();

  @override
  void onInit() {
    id = Get.arguments as int;
    print("Medication ID: $id");
    loadDemoMedications(1);

    super.onInit();
  }

  void loadDemoMedications(int page) async {
    medications.clear();
    isLoading(true);
    try {
      final token = storage.getToken();

      final response = await http.get(
        Uri.parse('http://192.168.100.4:8000/api/pharmacies/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      print("=============Response status code: ${response.statusCode}");
      print("=============Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        medications.value =
            data.map((item) => Medication.fromJson(item)).toList();
      } else {
        print("=============Error: ${response.body}");
        // UsefulFunctions.handleValidationErrors(response);
      }
    } catch (e) {
      print("=============Exception: $e");
      // UsefulFunctions.showToast(e.toString(), "error");
    } finally {
      isLoading(false);
    }
  }

  void addToCart(Medication medication) {
    final existingIndex = cartItems.indexWhere(
      (item) => item.id == medication.id,
    );

    if (existingIndex >= 0) {
      // If already in cart, increase quantity
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: cartItems[existingIndex].quantity! + 1,
      );
    } else {
      // If not in cart, add with quantity 1
      cartItems.add(medication.copyWith(quantity: 1));
    }

    Get.snackbar(
      'Added to Cart',
      '${medication.name} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
    );

    cartItems.refresh(); // Force UI update
  }

  double get totalCartValue {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.price! * item.quantity!),
    );
  }
}
