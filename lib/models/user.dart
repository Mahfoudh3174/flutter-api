class User {
  String email;
  String name;


  User({required this.name, required this.email});
  Map<String, dynamic> toJson() => {'name': name, 'email': email};
  User.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      name = json['name'];
}
