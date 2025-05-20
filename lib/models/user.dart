import 'role.dart';

class User {
  final String? email;
  final Role? role; // Make nullable if role might be null
  final String? id;
  final String? phone;
  final String? name;

  User({required this.email, required this.role, required this.id, required this.phone, required this.name});

    Map<String, dynamic> toJson() => {'name': name, 'email': email, 'phone': phone, 'role': role, 'id': id};


  User.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      role = json['role'] != null ? Role.fromJson(json['role']) : null,
      id = json['id'],
      phone = json['number'] ,
      name = json['name'];
}