import 'dart:convert';
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
          medications.add(Medication.fromJson(med));
        }
        print('Loaded ${medications.length} medications');

        nextCursor.value = data['meta']['next_cursor'] ?? '';
        hasMore.value = data['meta']['has_more'];
        print('Next cursor: ${nextCursor.value}');
        print('Has more: ${hasMore.value}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  void addToCart(Medication medication) {
    final existingIndex = cartItems.indexWhere(
      (item) => item.id == medication.id,
    );

    if (existingIndex >= 0) {
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: (cartItems[existingIndex].quantity ?? 0) + 1,
      );
    } else {
      cartItems.add(medication.copyWith(quantity: 1));
    }

    cartItems.refresh();
    Get.snackbar('Added', '${medication.name} added to cart');
  }

  double get totalCartValue {
    return cartItems.fold(
      0,
      (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 0)),
    );
  }

  @override
  void onClose() {
    medications.clear();

    super.onClose();
  }
}
