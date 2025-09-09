import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';  // Import halaman register
import 'screens/alumni_home.dart';  // Import halaman register
import 'screens/petugas_dashboard.dart';  // Import halaman register

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Alumni',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => AlumniHome(),
        '/petugas_dashboard': (context) => PetugasDashboard(),
      },
    );
  }
}

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
