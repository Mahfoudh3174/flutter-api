// order_model.dart
import 'product.dart';
import 'package:get/get.dart';
import 'client.dart';
import 'dart:convert';

class Order {
  final String id;
  final String reference;
  final String status;
  final double totalAmount;
  final dynamic payment; // Could be null or another model
  final List<Product> products;
  final Client client;
  final int items;
  final String createdAt;
  final String updatedAt;

  Order({
    required this.id,
    required this.reference,
    required this.status,
    required this.totalAmount,
    this.payment,
    required this.products,
    required this.client,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      reference: json['reference'],
      status: json['status'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      payment: json['payment'],
      client: Client.fromJson(json['client']),
      products:
          (json['products'] as List)
              .map((product) => Product.fromJson(product))
              .toList(),
      items: json['items'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'status': status,
      'total_amount': totalAmount,
      'payment': payment,
      'products': products.map((product) => product.toJson()).toList(),
      'items': items,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
