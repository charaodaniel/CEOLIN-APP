class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      roles: List<String>.from(json['role'] ?? []),
    );
  }
}
