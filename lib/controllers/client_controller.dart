import 'dart:convert';

import 'package:demo/models/Client.dart';
import 'package:demo/services/stored_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:demo/routes/web.dart';

class Clientscontroller extends GetxController {
  var clients = <Client>[].obs;
  RxBool isLoading = false.obs;
  final storage = Get.find<StorageService>();
  @override
  void onInit() {
    fetchClients();
    super.onInit();
  }

  Future<void> fetchClients() async {
    try {
      final token = storage.getToken();
      if (token == null) {
        print('token is null client controller');
        return;
      }
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/clients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
      Uri.parse('http://192.168.100.13:8000/api/clients/$id'),
      headers: {
        'Authorization': 'Bearer ${storage.getToken()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      clients.removeWhere((client) => client.id == id);
      Get.snackbar('Client Deleted', 'Client with id $id deleted');
    } else {
      Get.snackbar('Error', 'deletion faild');
    }
  }

  Future<void> createClient({
    required String name,
    required String phone,
  }) async {
    try {
      final token = storage.getToken();

      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.100.13:8000/api/clients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'number': phone}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Client Created', 'Client with name $name created');
        final data = jsonDecode(response.body);
        final client = data['client'];
        // Navigate to the home page
        clients.add(Client.fromJson(client));
        Get.toNamed('/');
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Creation failed');
      }
    } catch (e) {
      Get.snackbar('Exception', 'Something went wrong: $e');
    }
  }

  Future<Client?> getClientById(String id) async {
    try {
      final token = storage.getToken();
      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return null;
      }
      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/clients/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final client = data['client'];
        return Client.fromJson(client);
      } else {
        Get.snackbar('Error', 'Client not found');
        return null;
      }
    } catch (e) {
      Get.snackbar('Exception', 'Something went wrong: $e');
      return null;
    }
  }

  Future updateClient({
    required String id,
    required String name,
    required String phone,
  }) async {
    try {
      final token = storage.getToken();
      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }
      final requestbody = jsonEncode({"id": id, "name": name, "number": phone});

      final response = await http.put(
        Uri.parse('http://192.168.100.13:8000/api/clients/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: requestbody,
      );
      if (response.statusCode == 200) {
        Get.snackbar('Client Updated', 'Client with id $id updated');
        final data = jsonDecode(response.body);
        final client = data['client'];
        fetchClients();
        Get.snackbar('Success', 'Client updated successfully');
        Get.toNamed('/');
      }
    } catch (e) {
      Get.snackbar('Exception', 'Something went wrong: $e');
    }
  }
}
