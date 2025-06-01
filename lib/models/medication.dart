import 'package:demo/models/category.dart';

class Medication {
  final int? id;
  final String? name;
  final Category? category;
  final String? dosageForm;
  final String? strength;
  // final String imageUrl ;
  final int? price;
  final int? quantity;
  final int? pivotQuantity;
  final int? totalPrice;
  Medication({
    required this.id,
    required this.name,
    required this.category,
    // required this.imageUrl,
    required this.dosageForm,
    required this.strength,
    required this.price,
    required this.quantity,
    this.pivotQuantity,
    this.totalPrice,
  });

  Medication copyWith({
    int? id,
    String? name,

    int? price,
    // String? imageUrl,
    int? quantity,
  }) {
    return Medication(
      id: id ?? this.id,
      category: category,
      dosageForm: dosageForm,
      strength: strength,
      name: name ?? this.name,
      price: price ?? this.price,
      // imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category?.toJson(),
    'dosageForm': dosageForm,
    'price': price,
    'quantity': quantity,
  };
  Medication.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      name = json['name'] ?? 'Unknown Medication',
      category = Category.fromJson(json['category '] ?? {}),
      // imageUrl = json['imageUrl'] ?? 'https://via.placeholder.com/150',
      dosageForm = json['dosageForm'] ?? 'Unknown Dosage Form',
      strength = json['strength'] ?? 'Unknown Strength',
      price = json['price'] ?? 0,
      pivotQuantity=0,
      totalPrice = 0,
      quantity = json['quantity'] ?? 0;

  Medication.fromJsonBasic(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      name = json['name'] ?? 'Unknown Medication',
      category = null,
      // imageUrl = json['imageUrl'] ?? 'https://via.placeholder.com/150',
      dosageForm = json['dosage_form'] ?? 'Unknown Dosage Form',
      strength = null,
      price = json['price'] ?? 0,
      pivotQuantity = json['pivot_quantity'] ?? 0,
      totalPrice = json['total_price'] ?? 0,
      quantity = 0;
}
