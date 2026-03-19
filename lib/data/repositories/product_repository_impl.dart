import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService apiService;

  ProductRepositoryImpl({required this.apiService});

  @override
  Future<List<Product>> getProducts({int limit = 30, int skip = 0}) async {
    final models = await apiService.getProducts(limit: limit, skip: skip);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final model = await apiService.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final models = await apiService.searchProducts(query);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    return apiService.getCategories();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final models = await apiService.getProductsByCategory(category);
    return models.map((model) => model.toEntity()).toList();
  }
}
