// lib/controllers/order_controller.dart
import 'dart:convert';

import 'package:demo/models/order.dart';

import 'package:demo/services/stored_service.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = true.obs;
  StorageService storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading(true);

    try {
      final token = storage.getToken();

      debugPrint('Token: =====$token');

      final response = await http.get(
        Uri.parse('http://192.168.100.4:8000/api/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response status: ${json.decode(response.body).runtimeType}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        debugPrint("Data:==== ${data[0]['id']}");
        orders.value = data.map((item) => Order.fromJson(item)).toList();
        debugPrint('Orders fetched: ${orders.length}');
      } else {
        Get.snackbar('Error', 'Failed to load orders');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e');
      debugPrint('Error fetching orders: $e');
    } finally {
      isLoading(false);
    }
  }
}
