class Supporter {
  String? id;
  String name;
  String role;
  String phoneNumber;

  Supporter({
    this.id,
    required this.name,
    required this.role,
    required this.phoneNumber,
  });

  factory Supporter.fromMap(String id, Map<dynamic, dynamic> map) {
    return Supporter(
      id: id,
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'role': role, 'phoneNumber': phoneNumber};
  }
}
