import 'package:demo/controllers/pharmacy/pharmacy_controller.dart';
import 'package:demo/models/pharmacy.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/auth_controller.dart';

import 'package:demo/wigets/drawer.dart';
import 'package:demo/routes/web.dart';

class HomePage extends GetView<PharmacyController> {
  final storage = Get.find<StorageService>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pharmacy List"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Get.find<Authcontroller>().logout();
                storage.clearToken();
                storage.clearUser();
                Get.offAllNamed(RouteClass.getLoginRoute());
              },
            ),
          ],
        ),
        drawer: MainDrawer(
          userEmail: storage.getUser()?.email,
          userName: storage.getUser()?.name,
        ),
        body: Obx(
          () =>controller.isLoading.value ? const Center(child: CircularProgressIndicator()): RefreshIndicator(
            onRefresh: controller.fetchPharmacies,
            color: Colors.blue,
            child: ListView.builder(
              itemCount: controller.pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = controller.pharmacies[index];
                return PharmacyCard(pharmacy: pharmacy);
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to add pharmacy screen
            // Get.toNamed(RouteClass.getAddPharmacyRoute());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;

  const PharmacyCard({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: ListTile(
        leading: Icon(Icons.hotel_sharp, size: 40, color: Colors.blue),
        title: Text(
          pharmacy.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(pharmacy.address),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to pharmacy details
          // Get.toNamed(RouteClass.getPharmacyDetailsRoute(), arguments: pharmacy.id);
        },
      ),
    );
  }
}
