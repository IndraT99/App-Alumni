class User {
  final int id;
  final String email;
  final String password;
  final String role;  // alumni or petugas

  User({required this.id, required this.email, required this.password, required this.role});

  // Mengubah data JSON menjadi objek User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }
}
