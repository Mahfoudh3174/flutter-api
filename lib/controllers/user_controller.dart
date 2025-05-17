import 'dart:convert';
import 'package:demo/models/user.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  final users = <User>[].obs;
  final isLoading = true.obs;
  final StorageService storage = Get.find<StorageService>();
  

  @override
  void onInit() async {
    super.onInit();
    
    await fetchUsers();
  }

  Future<void> fetchUsers() async {
    final token=storage.getToken();
    if(token==null){
      return;
    }
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('http://192.168.100.13:8000/api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> usersData = data['users'];
      
      users.value = usersData.map((user) => User.fromJson(user)).toList();
    } else {
      Get.snackbar('Error', 'faild to load data ${response.statusCode}');
    }
    isLoading.value = false;
  }


Future<void> deleteUser({required int id}) async {
  final response = await http.delete(
    Uri.parse('http://192.168.100.13:8000/api/users/$id'),
    headers: {
      'Authorization': 'Bearer ${storage.getToken()}',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    users.removeWhere((user) => user.id == id);
    Get.snackbar('User Deleted', 'User with id $id deleted');
  } else {
    final data = json.decode(response.body);
    print(data['message']);
    Get.snackbar('Error', 'deletion faild ${response.statusCode} wher $id');
  }
}

















}
