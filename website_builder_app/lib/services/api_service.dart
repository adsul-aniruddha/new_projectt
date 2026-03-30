import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "http://127.0.0.1:8081"; // 🔥 localhost fix

  // 🔥 LOGIN
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

  // 🔥 CREATE WEBSITE (UPDATED)
  static Future createWebsite(String token, Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/website/create"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

  // 🔥 GET MY WEBSITES
  static Future getMyWebsites(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/website/my"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    return jsonDecode(res.body);
  }

  // 🔥 UPDATE WEBSITE
  static Future updateWebsite(String token, int id, Map data) async {
    final res = await http.put(
      Uri.parse("$baseUrl/website/update/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }
}