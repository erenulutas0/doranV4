import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../models/rating_summary_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('API request timeout. Check if API Gateway is running on http://localhost:8080');
        },
      );

      // Response body kontrolü
      final responseBody = response.body.trim();
      
      // HTML response kontrolü
      if (responseBody.startsWith('<') || responseBody.startsWith('<!DOCTYPE')) {
        throw Exception('API returned HTML instead of JSON. This usually means:\n1. API Gateway is not accessible\n2. CORS issue\n3. Network error\n\nResponse preview: ${responseBody.substring(0, 200)}');
      }

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = json.decode(responseBody);
          return data.map((json) => Product.fromJson(json)).toList();
        } catch (e) {
          throw Exception('Failed to parse JSON response: $e\nResponse body: ${responseBody.substring(0, 500)}');
        }
      } else {
        throw Exception('Failed to load products: HTTP ${response.statusCode}\nResponse: ${responseBody.substring(0, responseBody.length > 500 ? 500 : responseBody.length)}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to API Gateway at $baseUrl\n\nPlease check:\n1. API Gateway is running (docker-compose ps)\n2. API Gateway is accessible at http://localhost:8080\n3. No firewall blocking the connection\n\nError: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid JSON response from API.\n\nThis usually means:\n1. API Gateway returned HTML error page\n2. API Gateway is not properly configured\n3. Service is down\n\nError: $e');
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Response body'nin JSON olup olmadığını kontrol et
        if (response.body.trim().startsWith('<')) {
          throw Exception('API returned HTML instead of JSON. Check API Gateway configuration.');
        }
        final Map<String, dynamic> data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode} - ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid JSON response from API. Check API Gateway and service status.');
      }
      throw Exception('Error fetching product: $e');
    }
  }

  Future<List<Review>> getReviewsByProductId(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews/product/$productId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Response body'nin JSON olup olmadığını kontrol et
        if (response.body.trim().startsWith('<')) {
          throw Exception('API returned HTML instead of JSON. Check API Gateway configuration.');
        }
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode} - ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid JSON response from API. Check API Gateway and service status.');
      }
      throw Exception('Error fetching reviews: $e');
    }
  }

  Future<RatingSummary> getRatingSummary(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews/product/$productId/summary'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Response body'nin JSON olup olmadığını kontrol et
        if (response.body.trim().startsWith('<')) {
          throw Exception('API returned HTML instead of JSON. Check API Gateway configuration.');
        }
        final Map<String, dynamic> data = json.decode(response.body);
        return RatingSummary.fromJson(data);
      } else {
        throw Exception('Failed to load rating summary: ${response.statusCode} - ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid JSON response from API. Check API Gateway and service status.');
      }
      throw Exception('Error fetching rating summary: $e');
    }
  }
}

