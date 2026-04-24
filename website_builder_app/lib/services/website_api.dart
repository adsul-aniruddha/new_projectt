import 'dart:convert';
import 'package:http/http.dart' as http;

class WebsiteApi {
  static const String baseUrl = 'https://web-production-021d3.up.railway.app/api/v1/websites';
  
  static Future<List<Map<String, dynamic>>> getWebsites() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      print('Get websites error: $e');
    }
    return [];
  }
  
  static Future<Map<String, dynamic>?> createWebsite({
    required String name,
    String template = 'modern',
    String description = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'template': template,
          'description': description,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        }
      }
    } catch (e) {
      print('Create website error: $e');
    }
    return null;
  }
  
  static Future<String> getPreview(String siteId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/site/$siteId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['html']?.toString() ?? 'Preview loading...';
      }
    } catch (e) {
      print('Preview error: $e');
    }
    return 'Preview unavailable';
  }
}