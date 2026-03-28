import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "http://localhost:8081";

  static Future login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email.trim(),
        "password": password.trim(),
      }),
    );

    return jsonDecode(res.body);
  }

  static Future createRequest(String token, Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/request/create"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }
}