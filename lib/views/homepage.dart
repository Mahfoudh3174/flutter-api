import 'package:demo/controllers/pharmacy/pharmacy_controller.dart';
import 'package:demo/models/pharmacy.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/routes/web.dart';

class HomePage extends GetView<PharmacyController> {
  final storage = Get.find<StorageService>();
  final authController = Get.find<Authcontroller>();

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
        drawer: _buildDrawer(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                Theme.of(context).colorScheme.background,
              ],
            ),
          ),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              storage.getUser()?.name ?? 'Unknown',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(storage.getUser()?.email ?? 'Unknown'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('orders'),
                  onTap: () {
                    Get.toNamed(RouteClass.getOrdersRoute());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Feedback'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Logout', style: TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            await authController.logout();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      // Minimal rebuild scope - only watches isLoading
      final isLoading = controller.isLoading.value;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      // Pharmacy list is built separately and doesn't rebuild when isLoading changes
      return _buildPharmacyList(context);
    });
  }

  Widget _buildPharmacyList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchPharmacies,
      color: Colors.blue,
      child: Obx(() {
        // Separate Obx for the list to minimize rebuilds
        final pharmacies = controller.pharmacies;
        return ListView.builder(
          itemCount: pharmacies.length,
          itemBuilder: (context, index) {
            final pharmacy = pharmacies[index];
            return PharmacyCard(pharmacy: pharmacy);
          },
        );
      }),
    );
  }
}

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;
  final _icon = const Icon(Icons.local_pharmacy, size: 40, color: Colors.blue);

  const PharmacyCard({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(8), // Changed to rounded corners
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ), // Better spacing
      child: ListTile(
        leading: _icon, // Using cached icon
        title: Text(
          pharmacy.name ?? 'Unknown Pharmacy',
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          pharmacy.address ?? 'No address provided',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Get.offAllNamed(
            RouteClass.getMedictionRoute(),
            arguments: pharmacy.id,
          );
        },
      ),
    );
  }
}
