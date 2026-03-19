import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/product_api_service.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products.dart';

// --- Data Layer Providers ---
final productApiServiceProvider = Provider<ProductApiService>((ref) {
  return ProductApiService();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    apiService: ref.watch(productApiServiceProvider),
  );
});

// --- Use Case Providers ---
final getProductsUseCaseProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.watch(productRepositoryProvider));
});

final getProductByIdUseCaseProvider = Provider<GetProductById>((ref) {
  return GetProductById(ref.watch(productRepositoryProvider));
});

final searchProductsUseCaseProvider = Provider<SearchProducts>((ref) {
  return SearchProducts(ref.watch(productRepositoryProvider));
});

final getCategoriesUseCaseProvider = Provider<GetCategories>((ref) {
  return GetCategories(ref.watch(productRepositoryProvider));
});

final getProductsByCategoryUseCaseProvider =
    Provider<GetProductsByCategory>((ref) {
  return GetProductsByCategory(ref.watch(productRepositoryProvider));
});

// --- State Providers ---

// Product list state
final productsProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductsNotifier(ref);
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;

  ProductsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await ref.read(getProductsUseCaseProvider).call();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      loadProducts();
      return;
    }
    state = const AsyncValue.loading();
    try {
      final products = await ref.read(searchProductsUseCaseProvider).call(query);
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadByCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final products =
          await ref.read(getProductsByCategoryUseCaseProvider).call(category);
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Categories state
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(getCategoriesUseCaseProvider).call();
});

// Selected category
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final navigationIndexProvider = StateProvider<int>((ref) => 0);

// Favorites state
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Product>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<Product>> {
  FavoritesNotifier() : super([]);

  void toggleFavorite(Product product) {
    if (state.any((p) => p.id == product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFavorite(Product product) {
    return state.any((p) => p.id == product.id);
  }

  void removeFavorite(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }
}

// Cart state
final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final existingIndex =
        state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      final existing = state[existingIndex];
      final updated = existing.copyWith(quantity: existing.quantity + 1);
      state = [
        ...state.sublist(0, existingIndex),
        updated,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void increaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final existing = state[index];
      final updated = existing.copyWith(quantity: existing.quantity + 1);
      state = [
        ...state.sublist(0, index),
        updated,
        ...state.sublist(index + 1),
      ];
    }
  }

  void decreaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final existing = state[index];
      if (existing.quantity > 1) {
        final updated = existing.copyWith(quantity: existing.quantity - 1);
        state = [
          ...state.sublist(0, index),
          updated,
          ...state.sublist(index + 1),
        ];
      } else {
        removeFromCart(product);
      }
    }
  }

  double get totalPrice {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

// Cart total provider for reactivity
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});

// AI recommendation provider with Advanced Scoring System
final aiRecommendationsProvider =
    Provider.family<List<Product>, Product>((ref, currentProduct) {
  final productsAsync = ref.watch(productsProvider);
  return productsAsync.when(
    data: (products) {
      // Advanced AI: Calculate Similarity Score for every item
      final candidates = products
          .where((p) => p.id != currentProduct.id)
          .map((p) {
            double score = 0.0;
            
            // 1. Category Correlation (50%)
            if (p.category == currentProduct.category) score += 0.50;
            
            // 2. Price Segment Proximity (30%)
            double priceDiff = (p.price - currentProduct.price).abs();
            double priceScore = (1.0 - (priceDiff / (currentProduct.price.clamp(1, double.infinity) * 0.5))).clamp(0.0, 1.0);
            score += priceScore * 0.30;
            
            // 3. Rating Density (20%)
            score += (p.rating / 5.0) * 0.20;

            return MapEntry(p, (score * 100).round());
          })
          .where((e) => e.value > 65) // Only high confidence matches
          .toList();

      // Rank by AI confidence
      candidates.sort((a, b) => b.value.compareTo(a.value));
      
      return candidates.map((e) => e.key).take(5).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provides the individual match score for the UI
final aiMatchScoreProvider = Provider.family<int, (Product, Product)>((ref, pair) {
  final current = pair.$1;
  final other = pair.$2;
  
  double score = 0.0;
  if (other.category == current.category) score += 0.50;
  double priceDiff = (other.price - current.price).abs();
  double priceScore = (1.0 - (priceDiff / (current.price.clamp(1, double.infinity) * 0.5))).clamp(0.0, 1.0);
  score += priceScore * 0.30;
  score += (other.rating / 5.0) * 0.20;
  
  return (score * 100).round();
});
