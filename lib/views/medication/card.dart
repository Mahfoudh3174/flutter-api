import 'package:demo/controllers/medication/medication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPage extends GetView<MedicationController> {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cart')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to checkout or payment page
          Get.defaultDialog(
            cancel: TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            title: 'Cofirm Operation',
            content: Text('Do you want to sent this order?'),
            onConfirm: () {
              // Handle order confirmation logic here
              controller.cartItems.clear();
              Get.back();
            },
          );
        },
        child: Icon(Icons.payment),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(child: Text('Your cart is empty'));
        }
        return ListView.builder(
          itemCount: controller.cartItems.length,
          itemBuilder: (context, index) {
            final medication = controller.cartItems[index];
            return ListTile(
              title: Text(medication.name!),
              subtitle: Text('${medication.quantity} x \$${medication.price}'),
              trailing: IconButton(
                icon: Icon(Icons.remove_shopping_cart),
                onPressed: () {
                  controller.cartItems.removeAt(index);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
