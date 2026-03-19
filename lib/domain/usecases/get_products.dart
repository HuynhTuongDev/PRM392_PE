import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call({int limit = 30, int skip = 0}) {
    return repository.getProducts(limit: limit, skip: skip);
  }
}

class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  Future<Product> call(int id) {
    return repository.getProductById(id);
  }
}

class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  Future<List<Product>> call(String query) {
    return repository.searchProducts(query);
  }
}

class GetCategories {
  final ProductRepository repository;

  GetCategories(this.repository);

  Future<List<String>> call() {
    return repository.getCategories();
  }
}

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  Future<List<Product>> call(String category) {
    return repository.getProductsByCategory(category);
  }
}
