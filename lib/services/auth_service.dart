import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      "http://192.168.0.111:5000/api/auth"; // your backend IP

  static Future<Map<String, dynamic>> login(
      String phone, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      Uri.parse('http://localhost:5000/api/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "password": password}),
    );

    return jsonDecode(response.body);
  }
}
