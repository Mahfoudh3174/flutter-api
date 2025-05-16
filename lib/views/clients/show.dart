import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/client_controller.dart';

class ClientDetailsPage extends StatelessWidget {
  final Clientscontroller controller = Get.find();
  // Sample static data - in a real app this would come from API/controller
  final Map client = {
    'name': 'John Doe',
    'phone': '+1 234 567 890',
    'email': 'john.doe@example.com',
    'address': '123 Main St, New York, USA',
    'orders': [
      {
        'reference': 'ORD-2023-001',
        'products': [
          {'name': 'Product A', 'quantity': 2, 'price': 25.99},
          {'name': 'Product B', 'quantity': 1, 'price': 15.50},
        ],
        'total': 67.48,
        'status': 'Delivered',
        'date': '2023-05-15',
      },
      {
        'reference': 'ORD-2023-002',
        'products': [
          {'name': 'Product C', 'quantity': 3, 'price': 12.75},
        ],
        'total': 38.25,
        'status': 'Processing',
        'date': '2023-06-20',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Details'),
      ),
      body: SingleChildScrollView(
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
                      client['name'],
                      
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow(Icons.phone, client['phone']),
                    _buildInfoRow(Icons.email, client['email']),
                    _buildInfoRow(Icons.location_on, client['address']),
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
              
              itemCount: client['orders'].length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = client['orders'][index];
                return _buildOrderCard(order, context);
              },
            ),
          ],
        ),
      ),
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

  Widget _buildOrderCard(Map<String, dynamic> order, BuildContext context) {
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
                  'Order #${order['reference']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    order['status'],
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(order['status']),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${order['date']}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 12),
            
            // Products List
            ...order['products'].map<Widget>((product) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${product['quantity']} x ${product['name']}'),
                  Text('\$${product['price'].toStringAsFixed(2)}'),
                ],
              ),
            )).toList(),
            
            Divider(height: 24),
            
            // Order Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final orders=controller.orders;
                    print(orders.first.reference);
                    
                  },
                  child: Text('View Order'),
                ),
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${order['total'].toStringAsFixed(2)}',
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