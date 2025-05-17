import 'dart:convert';
import 'package:demo/models/user.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:demo/wigets/tost.dart';

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
    isLoading.value = true;
    final token=storage.getToken();
    if(token==null){
      return;
    }
    
    final response = await http.get(
      Uri.parse('http://192.168.100.13:8000/api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      showToast("message", "success");
      final data = json.decode(response.body);
      List<dynamic> usersData = data['users'];
      
      users.value = usersData.map((user) => User.fromJson(user)).toList();
    } else {
      Get.snackbar('Error', 'faild to load data ${response.statusCode}');
    }
    isLoading.value = false;
  }


Future<void> deleteUser({required int id}) async {
  isLoading.value = true;
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
  isLoading.value = false;
}

Future<void> createEmployee({
  required String name,
  required String email,
  required String phone,
  required String password,
  required String roleId,
}) async {
  try {
    final token = storage.getToken();
    if (token == null) {
      Get.snackbar('Error', 'Authentication token not found');
      return;
    }
    
    final response = await http.post(
      Uri.parse('http://192.168.100.13:8000/api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'number': phone,
        'password': password,
        'role_id': roleId,
      }),
    );
    

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Employee created successfully');
      Get.toNamed(RouteClass.getUsersRoute());
    } else if(response.statusCode==422) {
      final data = json.decode(response.body);
      final errors = data['errors'] as Map<String, dynamic>;
      String errorMessage = '';
      errors.forEach((key, value) {
        errorMessage += '$key: $value\n';
      });
      Get.snackbar('Error', errorMessage);
    } else {
      Get.snackbar('Error', 'Failed to create employee ${response.statusCode}');
    }
  } catch (e) {
    Get.snackbar('Error ', e.toString());
  }
}















}
