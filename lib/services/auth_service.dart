import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Replace with your PC IP address
  static const String baseUrl = "http://192.168.0.102:5000/api/auth";

  /* ======================
       LOGIN (ADMIN + USER)
  ======================= */
  static Future<Map<String, dynamic>> login(
      String phone, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "password": password}),
    );

    final data = jsonDecode(response.body);

    return {
      "status": response.statusCode,
      "message": data["message"],
      "token": data["token"],
      "user": data["user"],
      "role": data["user"]?["role"], // 👈 IMPORTANT for admin redirect
    };
  }

  /* ======================
       REGISTER
  ======================= */
  static Future<Map<String, dynamic>> register(
      String name, String phone, String password) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "phone": phone,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }
}
