class Notificatione {
  final String? message;
  final String? createdAt;
  final String? readAt;
  final String? id;
  final String? type;

  Notificatione({
    this.message,
    this.createdAt,
    this.readAt,
    this.id,
    this.type,
  });

  factory Notificatione.fromJson(Map<String, dynamic> json) {
    return Notificatione(
      message: json['data']?['message'] ?? json['message'],
      createdAt: json['created_at'],
      readAt: json['read_at'],
      id: json['id']?.toString(),
      type: json['type'],
    );
  }

  bool get isRead => readAt != null;

  Notificatione copyWith({
    String? message,
    String? createdAt,
    String? readAt,
    String? id,
    String? type,
  }) {
    return Notificatione(
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'created_at': createdAt,
      'read_at': readAt,
      'id': id,
      'type': type,
    };
  }
}