import 'package:demo/controllers/medication/medication_controller.dart';
import 'package:demo/models/medication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPage extends GetView<MedicationController> {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: _buildBackgroundDecoration(context),
      child: Obx(() {
        // Minimal rebuild scope - only watches cartItems.isEmpty
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart();
        }
        return _buildCartContent();
      }),
    );
  }

  BoxDecoration _buildBackgroundDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          Theme.of(context).colorScheme.background,
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some medications to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        // Cart items list with separate OBX for minimal rebuilds
        Expanded(
          child: Obx(() {
            final items = controller.cartItems;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder:
                  (context, index) => _buildCartItem(items[index], index),
            );
          }),
        ),
        // Total and checkout section
        _buildCheckoutSection(),
      ],
    );
  }

  Widget _buildCartItem(Medication medication, int index) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.medical_services, size: 36, color: Colors.blue[300]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name ?? 'Unknown Medication',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${medication.quantity} x \$${medication.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showRemoveDialog(index),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(int index) {
    Get.defaultDialog(
      title: 'Remove Item',
      content: const Text('Are you sure you want to remove this item?'),
      confirm: TextButton(
        onPressed: () {
          controller.cartItems.removeAt(index);
          Get.back();
        },
        child: const Text('Remove', style: TextStyle(color: Colors.red)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() {
            final total = controller.totalCartValue;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(Get.context!).primaryColor,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    controller.cartItems.isEmpty ? null : _showConfirmDialog,
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() async {
    await Get.defaultDialog(
      title: 'Confirm Order',
      content: const Text('Are you sure you want to confirm this order?'),
      confirm: TextButton(
        onPressed: () {
          controller.confirmOrder();
          Get.back();
        },
        child: const Text('Confirm'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }
}
