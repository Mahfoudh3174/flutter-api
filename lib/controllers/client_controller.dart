import 'dart:convert';

import 'package:demo/models/Client.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Clientscontroller extends GetxController {
  var clients = <Client>[].obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    fetchClients();
    super.onInit();
  }

  Future<void> fetchClients() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/clients'),
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        clients.value = data.map((client) => Client.fromJson(client)).toList();
      } else {
        Get.snackbar('Error', 'faild to load data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteClient({required String id}) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/clients/$id'),
    );
    if (response.statusCode == 200) {
      clients.removeWhere((client) => client.id == id);
    } else {
      Get.snackbar('Error', 'deletion faild');
    }
  }
}
