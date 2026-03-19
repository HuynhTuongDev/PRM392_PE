import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';
import '../theme/app_theme.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header (as per favourite.html)
            _buildHeader(context, ref),
            // Category Tabs
            _buildCategoryTabs(),
            // Favorites Content
            Expanded(
              child: favorites.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) => _FavoriteItemCard(product: favorites[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            'Favorites',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          GestureDetector(
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 0,
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12))),
      child: Row(
        children: [
          _buildTab('All', true),
          _buildTab('Clothing', false),
          _buildTab('Accessories', false),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 32),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: active ? AppTheme.primary : Colors.transparent, width: 2)),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: active ? FontWeight.bold : FontWeight.w500,
          color: active ? AppTheme.primary : Colors.white54,
        ),
      ),
    );
  }

  Widget _buildEmptyState() => const Center(child: Text('No favorites yet.', style: TextStyle(color: Colors.white54)));
}

class _FavoriteItemCard extends ConsumerWidget {
  final Product product;
  const _FavoriteItemCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1832),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(imageUrl: product.thumbnail, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.stock > 20 ? 'BEST SELLER' : 'NEW ARRIVAL',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary, letterSpacing: 1),
                  ),
                  Text(
                    product.title,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.formattedPrice, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                          Text('Original quality', style: GoogleFonts.inter(fontSize: 12, color: Colors.white38)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => ref.read(favoritesProvider.notifier).removeFavorite(product),
                        icon: const Icon(Icons.delete_outline, size: 16, color: Colors.white),
                        label: const Text('Remove', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.slate800,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
