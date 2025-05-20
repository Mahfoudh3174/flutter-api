class Role {
  final String? id;
  final String? name;

  Role({required this.id, required this.name});

Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };


  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}

