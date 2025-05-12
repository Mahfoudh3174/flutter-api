class User {
  String email;
  String name;
  String phone;


  User({
    required this.name,
    required this.phone,
    required this.email,
    
  });

  User.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      name = json['name'],
      phone = json['number'];
}
