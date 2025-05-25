import 'package:demo/models/medication.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/medication/medication_controller.dart';

class MedicationListView extends StatelessWidget {
  final MedicationController medicationController = Get.find();

  MedicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.toNamed(RouteClass.getCardRoute());
                },
              ),
              Obx(
                () =>
                    medicationController.cartItems.isNotEmpty
                        ? Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                medicationController.cartItems.length
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (medicationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: medicationController.medications.length,
          itemBuilder: (context, index) {
            final medication = medicationController.medications[index];
            return MedicationCard(
              medication: medication,
              onAddToCart: () => medicationController.addToCart(medication),
            );
          },
        );
      }),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onAddToCart;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Icon(
                Icons.medical_services, // Placeholder icon
                size: 80,
                color: Colors.blue[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  medication.category!.name,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '\$${medication.price!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: onAddToCart,
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
