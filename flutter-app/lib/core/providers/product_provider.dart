import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategory;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
      _filteredProducts = _products;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _products = [];
      _filteredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == 'All') {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) => product.category == category)
          .toList();
    }
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

