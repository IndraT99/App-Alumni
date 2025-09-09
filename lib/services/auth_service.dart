import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alumni.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // NOTE: kalau pakai Android emulator, ganti 127.0.0.1 -> 10.0.2.2
  static const String api = "http://127.0.0.1:8000/api";

  Map<String, String> get _headers => const {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

  /// Login (mengembalikan: { message, user, token })
  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse("$api/user/login");
    final res = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _decode(res);
  }

  /// Register alumni
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final uri = Uri.parse("$api/user/register");
    final res = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(data),
    );
    return _decode(res);
  }

  /// Get a list of alumni
  Future<List<Alumni>> getAlumni() async {
    final uri = Uri.parse("$api/user/users");
    final res = await http.get(uri, headers: _headers);
    final data = _decode(res);

    if (data is List) {
      return data
          .where((e) => e['role'] == 'alumni') // Filter users by role
          .map<Alumni>((e) => Alumni.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Format respons tidak sesuai (bukan List).");
    }
  }

    Future<Alumni> getAlumniById(int id, String token) async {
  final uri = Uri.parse("$api/user/users/$id"); // endpoint GET detail user
  final res = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      ..._headers,
    },
  );

  // gunakan _decode agar konsisten dengan error handling kamu
    final data = _decode(res);
    // jika backend mengembalikan object user langsung
    if (data is Map<String, dynamic>) {
      return Alumni.fromJson(data);
    }
    throw Exception("Format respons detail user tidak sesuai.");
  }

  /// Get user profile using token
  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final uri = Uri.parse("$api/user/profile");
    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ..._headers,
      },
    );
    return _decode(res);
  }

  

  /// Update user data
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> data, String token) async {
    final uri = Uri.parse("$api/user/update/$id");
    final res = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ..._headers,
      },
      body: jsonEncode(data),
    );
    return _decode(res);
  }

  /// Delete user by ID
  Future<Map<String, dynamic>> deleteUser(int id, String token) async {
    final uri = Uri.parse("$api/user/delete/$id");
    final res = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ..._headers,
      },
    );
    return _decode(res);
  }

  /// Decode response helper
  dynamic _decode(http.Response res) {
    dynamic data;
    try {
      data = jsonDecode(res.body);
    } catch (_) {
      throw Exception("Respons bukan JSON: ${res.statusCode}");
    }
    if (res.statusCode >= 200 && res.statusCode < 300) return data;

    final msg = (data is Map && data['message'] != null)
        ? data['message']
        : 'Request gagal (${res.statusCode})';
    throw Exception(msg.toString());
  }

  /// Save the token after login
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  /// Retrieve token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    await prefs.remove('user_id');
  }
    Map<String, String> get headers => const {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
}
