class User {
  final String name;
  final String email;
  final String username;
  final String gender;
  final String createdAt;
  final String dateOfBirth;

  User({
    required this.name,
    required this.email,
    required this.username,
    required this.gender,
    required this.createdAt,
    required this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Tidak tersedia',
      email: json['email'] ?? 'Tidak tersedia',
      username: json['username'] ?? 'Tidak tersedia',
      gender: json['gender'] ?? 'Tidak tersedia',
      createdAt: json['createdAt'] ?? 'Tidak tersedia',
      dateOfBirth: json['dateOfBirth'] ?? 'Tidak tersedia',
    );
  }
}
