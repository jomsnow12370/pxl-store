import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For web browser, use localhost
  // For Android emulator, use 10.0.2.2 instead of localhost
  // For iOS simulator, use localhost
  // For physical device, use your computer's local IP (e.g., 192.168.x.x)
  static const String baseUrl = 'http://localhost:3000/api';
  
  static String getBaseUrl() {
    // You can add platform-specific logic here if needed
    // import 'dart:io' and check Platform.isAndroid
    return baseUrl;
  }

  static Future<Map<String, dynamic>> createProduct({
    required String name,
    required double cost,
    double? price,
    String? photoUrl,
    required List<Map<String, dynamic>> variations,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'cost': cost,
          'price': price,
          'photo_url': photoUrl,
          'variations': variations,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create product');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] as List;
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

