import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogRepository {
  static const String _backendBase = 'http://localhost:8081';

  /// Searches real 1688 products via the AhmedBaba Catalog Service
  Future<List<Map<String, dynamic>>> searchProducts(String query, {int page = 1}) async {
    final uri = Uri.parse('$_backendBase/api/v1/catalog/search')
        .replace(queryParameters: {'q': query, 'page': '$page'});

    final resp = await http.get(uri, headers: {'Accept': 'application/json'});

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      // 1688 API response wraps items in a nested structure
      final List items = data['result']?['items']?['webpItemVO'] ?? [];
      return items.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    throw Exception('Search failed: ${resp.statusCode}');
  }

  /// Fetches full product detail from 1688 via RapidAPI
  Future<Map<String, dynamic>> getProductDetail(String itemId) async {
    final uri = Uri.parse('$_backendBase/api/v1/catalog/product/$itemId');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    }
    throw Exception('Product not found: $itemId');
  }
}
