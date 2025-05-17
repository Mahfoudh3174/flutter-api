import 'package:demo/models/noification.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:demo/routes/web.dart';

class NotificationController extends GetxController {
  static const String _baseUrl = 'http://192.168.100.13:8000/api';
  final storage = Get.find<StorageService>();
  
  final notifications = <Notificatione>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    fetchNotifications();
    
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final String? token =storage.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        notifications.assignAll(
          (data['notifications'] as List)
              .map((json) => Notificatione.fromJson(json))
              .toList(),
        );
        unreadCount.value = data['unreadCount'] ?? 0;
      
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      isLoading.value = true;
      final String? token =storage.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/$notificationId/mark-as-read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Update the local notification state
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = notifications[index].copyWith(readAt: DateTime.now().toString());
          unreadCount.value = unreadCount.value - 1;
        }
      
      } else {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }

    isLoading.value = false;
  }

  Future<void> markAllAsRead() async {
    try {
      isLoading.value = true;
      final String? token =storage.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/mark-all-as-read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Update all notifications to read
        notifications.value = notifications.map((notificatione) {
          return notificatione.copyWith(readAt: DateTime.now().toString());
        }).toList();
        unreadCount.value = 0;
      
      } else {
        throw Exception('Failed to mark all notifications as read');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }

    isLoading.value = false;
  }

Future <void> deleteNotification(String notificationId) async {
  try {
    isLoading.value = true;
    final String? token =storage.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/notifications/$notificationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Update the local notification state
      notifications.removeWhere((n) => n.id == notificationId);
      unreadCount.value = unreadCount.value - 1;
    } else {
      throw Exception('Failed to delete notification');
    }
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }

  isLoading.value = false;
}

}