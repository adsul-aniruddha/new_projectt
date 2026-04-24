import 'dart:convert';
import 'package:http/http.dart' as http;

class WebsiteApi {
  static const String baseUrl = 'http://127.0.0.1:8090/api/v1/websites';
  
  // List all websites
  static Future<List<Map<String, dynamic>>> getWebsites() async {
    final res = await http.get(Uri.parse(baseUrl));
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
  
  // Create new website
  static Future<Map<String, dynamic>> createWebsite({
    required String name,
    String template = 'modern',
    String description = '',
  }) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'template': template,
        'description': description,
      }),
    );
    return jsonDecode(res.body);
  }
  
  // Get website preview
  static Future<String> getPreview(String siteId) async {
    final res = await http.get(Uri.parse('$baseUrl/site/$siteId'));
    return jsonDecode(res.body)['html'];
  }
  
  // Submit contact
  static Future submitContact(String siteId, Map<String, String> data) async {
    await http.post(
      Uri.parse('$baseUrl/contact/$siteId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }
}