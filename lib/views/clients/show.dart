import 'package:demo/models/order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/client_controller.dart';

class ClientDetailsPage extends StatelessWidget {
  final Clientscontroller controller = Get.find();
  // Sample static data - in a real app this would come from API/controller
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Details'),
      ),
      body:controller.orders.isEmpty?Center(child: Text('No orders found'),): Obx (()=>SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Information Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.orders.first.client.name,
                      
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow(Icons.phone, controller.orders.first.client.phone),
                  
                    
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Orders Section Header
            Text(
              'Order History',
              
            ),
            SizedBox(height: 8),
            
            // Orders List
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              
              itemCount: controller.orders.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return _buildOrderCard(order, context);
              },
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.reference}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    order.status,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(order.status),
                ),
                SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
            onPressed: () async{
              await controller.exportPdf(id: order.id);
            },
            tooltip: 'Export as PDF',
          ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${order.createdAt}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 12),
            
            // Products List
            ...order.products.map<Widget>((product) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${product.pivot.quantity} x ${product.name}'),
                  Text('\$${product.price.toStringAsFixed(2)}'),
                ],
              ),
            )).toList(),
            
            Divider(height: 24),
            
            // Order Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                order.status == 'paid' ? Icon(Icons.check_circle, color: Colors.green) : 
                ElevatedButton(
                  onPressed: () async {
                    await controller.markAsPaid(id: order.id);
                    
                  },
                  child: Text('Mark as Paid'),
                ),
                
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}