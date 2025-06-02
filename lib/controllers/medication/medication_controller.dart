import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:demo/models/medication.dart';
import 'package:demo/services/stored_service.dart';

class MedicationController extends GetxController {
  final RxList<Medication> medications = <Medication>[].obs;
  final RxList<Medication> cartItems = <Medication>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString nextCursor = ''.obs;
  final RxBool hasMore = true.obs;
  late final int pharmacyId;
  final StorageService storage = Get.find<StorageService>();

  @override
  void onInit() {
    pharmacyId = Get.arguments as int;
    loadMedications();
    super.onInit();
  }

  Future<void> loadMedications({bool loadMore = false}) async {
    if ((loadMore && !hasMore.value) || isLoading.value) return;

    loadMore ? isLoadingMore(true) : isLoading(true);

    try {
      final token = storage.getToken();
      final url =
          loadMore
              ? 'http://192.168.100.4:8000/api/pharmacies/$pharmacyId?cursor=$nextCursor'
              : 'http://192.168.100.4:8000/api/pharmacies/$pharmacyId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!loadMore) medications.clear();

        List<dynamic> meds = data['medications'];

        for (var med in meds) {
          debugPrint('Adding medication: ${med['imageUrl']}');
          medications.add(Medication.fromJson(med));
          print("=========${medications.first.imageUrl!}");
        }

        nextCursor.value = data['meta']['next_cursor'] ?? '';
        hasMore.value = data['meta']['has_more'];
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  void addToCart(Medication medication) async {
    final existingIndex = cartItems.indexWhere(
      (item) => item.id == medication.id,
    );
    //check availability of medication
    if (existingIndex >= 0 &&
        (cartItems[existingIndex].quantity ?? 0) >=
            (medication.quantity ?? 0)) {
      Get.snackbar('Out of Stock', 'This medication is out of stock.');
      medications.removeAt(medication.id!);
      await loadMedications();
      return;
    }

    if (existingIndex >= 0) {
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: (cartItems[existingIndex].quantity ?? 0) + 1,
      );
    } else {
      cartItems.add(medication.copyWith(quantity: 1));
    }

    cartItems.refresh();
  }

  double get totalCartValue {
    return cartItems.fold(
      0,
      (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 0)),
    );
  }

  Future<void> confirmOrder() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add items to your cart before ordering.',
      );
      return;
    }
    Position? position = await getCurrentLocationApp();
    if (position == null) {
      Get.snackbar(
        'Location Error',
        'Unable to retrieve your current location. Please enable location services.',
      );
      return;
    }

    final token = storage.getToken();
    final url = 'http://192.168.100.4:8000/api/orders';
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'medications': cartItems,
        'pharmacy_id': pharmacyId,
        'total': totalCartValue,
        'latitude': position.latitude,
        'longitude': position.longitude,
      }),
    );
    Get.back();
    debugPrint('Status Code========: ${response.statusCode}');
    debugPrint('Response=========: ${response.body}');

    if (response.statusCode == 200) {
      Get.snackbar('Order Placed', 'Your order has been placed successfully.');
      cartItems.clear();
      await loadMedications();
    } else {
      Get.snackbar(
        'Error',
        json.decode(response.body)['message'] ?? 'Failed to place order.',
      );
    }
  }

  Future<Position?> getCurrentLocationApp() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // Location services are disabled, handle accordingly
        Get.snackbar(
          "Error",
          "Location services are disabled please enable them",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );

        return null;
      }

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, handle accordingly
          throw LocationServiceDisabledException();
        }
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        debugPrint("Permission granted");
        debugPrint(
          "Current Position: ${position.latitude}, ${position.longitude}",
        );
        return position;
      }
      return null;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  @override
  void onClose() {
    medications.clear();

    super.onClose();
  }
}
