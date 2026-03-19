import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  final http.Client client;

  ProductApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<ProductModel>> getProducts({int limit = 30, int skip = 0}) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = (data['products'] as List<dynamic>)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductModel.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load product: ${response.statusCode}');
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/search?q=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = (data['products'] as List<dynamic>)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return products;
    } else {
      throw Exception('Failed to search products: ${response.statusCode}');
    }
  }

  Future<List<String>> getCategories() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/category-list'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((e) => e as String).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/category/$category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = (data['products'] as List<dynamic>)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return products;
    } else {
      throw Exception(
          'Failed to load products by category: ${response.statusCode}');
    }
  }
}
