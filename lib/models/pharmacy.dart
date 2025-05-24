

import 'package:demo/models/medication.dart';
import 'package:demo/models/category.dart';

class Pharmacy {
  final int id;
  final String name;
  final String address;
  final List<Medication>? medications;
  final List<Category>? categories;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    this.medications ,
    this.categories,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'medications': medications?.map((med) => med.toJson()).toList(),
        'categories': categories?.map((cat) => cat.toJson()).toList(),
      };
  Pharmacy.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        medications = (json['medications'] as List)
            .map((med) => Medication.fromJson(med))
            .toList(),
        address = json['address'],
        categories = (json['categories'] as List)
            .map((cat) => Category.fromJson(cat))
            .toList();
}
