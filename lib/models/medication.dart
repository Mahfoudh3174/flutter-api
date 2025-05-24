


import 'package:demo/models/category.dart';

class Medication {
    final int id;
  final String name;
  final Category category;
  final String dosageForm;
  final String strength;

  final int price;
  final int quantity;

  Medication({
    required this.id,
    required this.name,
    required this.category,
    required this.dosageForm,
    required this.strength,
    required this.price,
    required this.quantity,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.toJson(),
        'dosageForm': dosageForm,
        'strength': strength,
        'price': price,
        'quantity': quantity,
      };
  Medication.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = Category.fromJson(json['category']),
        dosageForm = json['dosageForm'],
        strength = json['strength'],
        price = json['price'],
        quantity = json['quantity'];

}