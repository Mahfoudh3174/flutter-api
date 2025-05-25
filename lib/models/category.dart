
class Category {

  final int id;
  final String name;


  Category({
    required this.id,
    required this.name,
    
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        
      };
  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
  
}