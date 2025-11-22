import 'dart:convert';
import 'package:http/http.dart' as http;

class MLService {
  static const String baseUrl = "http://192.168.0.102:5000/api/ml";

  static Future<Map<String, dynamic>> getPrediction() async {
    final response = await http.get(Uri.parse("$baseUrl/predict"));
    return jsonDecode(response.body);
  }
}
