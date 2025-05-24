

class User {
  final String? email;
  final int? id;
  final String? phone;
  final String? name;

  User({required this.email, required this.id, required this.phone, required this.name});

    Map<String, dynamic> toJson() => {'name': name, 'email': email, 'phone': phone, 'id': id};


  User.fromJson(Map<String, dynamic> json)
    : email = json['email'],
     
      id = json['id'],
      phone = json['number'] ,
      name = json['name'];
}