import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const _storage = FlutterSecureStorage();
  static String? _token;
  static const String _tokenKey = 'auth_token';

  // Initialize the token from storage
  static Future<void> init() async {
    _token = await _storage.read(key: _tokenKey);
  }

  // Get headers with auth token
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // Login user
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Save token to secure storage
        _token = responseData['token'];
        await _storage.write(key: _tokenKey, value: _token);
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Logout user
  static Future<void> logout() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    await init();
    return _token != null;
  }

  // Get user profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      await init();
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/auth/profile'),
        headers: _headers,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return responseData['user'];
      } else {
        throw Exception(responseData['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Profile error: $e');
    }
  }
  // For web browser, use localhost
  // For Android emulator, use 10.0.2.2 instead of localhost
  // For iOS simulator, use localhost
  // For physical device, use your computer's local IP (e.g., 192.168.x.x)
  static const String baseUrl = 'http://localhost:3000/api';
  
  static String getBaseUrl() {
    // For Android emulator, use 10.0.2.2 instead of localhost
    // For iOS simulator, use localhost
    // For web, use localhost or your server IP
    // For physical device, use your computer's local IP (e.g., 192.168.x.x)
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
        headers: _headers,
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
      await init(); // Ensure token is loaded
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/products'),
        headers: _headers,
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

  static Future<Map<String, dynamic>> updateProduct({
    required int id,
    required String name,
    required double cost,
    double? price,
    String? photoUrl,
    required List<Map<String, dynamic>> variations,
  }) async {
    try {
      await init();
      final response = await http.put(
        Uri.parse('${getBaseUrl()}/products/$id'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'cost': cost,
          'price': price,
          'photo_url': photoUrl,
          'variations': variations,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> deleteProduct(int id) async {
    try {
      await init();
      final response = await http.delete(
        Uri.parse('${getBaseUrl()}/products/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

