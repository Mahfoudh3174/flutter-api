import 'package:demo/models/medication.dart';
import 'package:demo/models/pharmacy.dart';

class Order {
  final int id;
  final String status;
  final String createdAt;
  final int? totalBill;

  final List<Medication> medications;
  final Pharmacy pharmacy;

  Order({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.medications,
    required this.pharmacy,
    this.totalBill,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'createdAt': createdAt,
    'medications': medications.map((med) => med.toJson()).toList(),
    'pharmacy': pharmacy.toJson(),
  };

  Order.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      status = json['status'] ?? 'Unknown Status',
      createdAt = json['created_at'] ?? 'Unknown Date',
      totalBill = json['total_bill'],
      medications =
          (json['medications'] as List)
              .map((med) => Medication.fromJsonBasic(med))
              .toList(),
      pharmacy = Pharmacy.fromJsonBasic(json['pharmacy'] ?? {});
}
