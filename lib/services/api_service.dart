import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  static const String baseUrl = 'http://192.168.0.85:3000/api';
  
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
      final requestBody = {
        'name': name,
        'cost': cost,
        'price': price,
        'photo_url': photoUrl,
        'variations': variations,
      };
      
      print('DEBUG: Creating product with body: $requestBody');
      
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/products'),
        headers: _headers,
        body: jsonEncode(requestBody),
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

  // Update variation quantity (reduce stock after sale)
  static Future<Map<String, dynamic>> updateVariationQuantity({
    required int productId,
    required int variationId,
    required int newQuantity,
  }) async {
    try {
      await init();
      final response = await http.put(
        Uri.parse('${getBaseUrl()}/products/$productId/variations/$variationId'),
        headers: _headers,
        body: jsonEncode({
          'quantity': newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update variation quantity');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create a sale/transaction record
  static Future<Map<String, dynamic>> createSale({
    required double total,
    required String paymentMethod,
    required double cashReceived,
    required double change,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      await init();
      final response = await http.post(
        Uri.parse('${getBaseUrl()}/sales'),
        headers: _headers,
        body: jsonEncode({
          'total': total,
          'payment_method': paymentMethod,
          'cash_received': cashReceived,
          'change': change,
          'items': items,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create sale');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get all sales
  static Future<List<dynamic>> getSales() async {
    try {
      await init();
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/sales'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] as List;
      } else {
        throw Exception('Failed to fetch sales');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Upload product photo from File (mobile/desktop)
  static Future<Map<String, dynamic>> uploadPhoto(File imageFile) async {
    try {
      await init(); // Ensure token is loaded
      
      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${getBaseUrl()}/products/upload'),
      );
      
      // Add authorization header
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      
      // Add image file
      final imageBytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'photo',
        imageBytes,
        filename: imageFile.path.split('/').last,
      );
      request.files.add(multipartFile);
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to upload photo');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  // Upload product photo from XFile (works on all platforms including web)
  static Future<Map<String, dynamic>> uploadPhotoFromXFile(XFile imageFile) async {
    try {
      await init(); // Ensure token is loaded
      
      print('DEBUG: Token loaded: ${_token != null ? "Yes" : "No"}');
      print('DEBUG: Upload URL: ${getBaseUrl()}/products/upload');
      
      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${getBaseUrl()}/products/upload'),
      );
      
      // Add authorization header
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
        print('DEBUG: Authorization header added');
      } else {
        print('DEBUG: WARNING - No token available for upload!');
      }
      
      // Add image file
      final imageBytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'photo',
        imageBytes,
        filename: imageFile.name,
      );
      request.files.add(multipartFile);
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('DEBUG: Upload response status: ${response.statusCode}');
      print('DEBUG: Upload response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('DEBUG: Upload failed with status ${response.statusCode}');
        print('DEBUG: Response body: ${response.body}');
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Failed to upload photo');
        } catch (e) {
          final bodyPreview = response.body.length > 200 
              ? response.body.substring(0, 200) 
              : response.body;
          throw Exception('Failed to upload photo. Status: ${response.statusCode}, Body: $bodyPreview');
        }
      }
    } catch (e) {
      print('DEBUG: Upload exception: $e');
      throw Exception('Upload error: $e');
    }
  }
}

