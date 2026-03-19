import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/product.dart';
import '../providers/product_providers.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).any((p) => p.id == widget.product.id);
    final recs = ref.watch(aiRecommendationsProvider(widget.product));

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(),
                _buildContentArea(isFav, recs),
              ],
            ),
          ),
          _buildTopNav(context, isFav),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 450,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(imageUrl: widget.product.thumbnail, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppTheme.backgroundDark.withOpacity(1), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(BuildContext context, bool isFav) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(Icons.arrow_back, () => Navigator.pop(context)),
          Row(
            children: [
              _circleIcon(Icons.share, () {}),
              const SizedBox(width: 12),
              _circleIcon(Icons.more_vert, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildContentArea(bool isFav, List<Product> recs) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
        decoration: const BoxDecoration(
          color: AppTheme.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.product.category.toUpperCase(), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primary, letterSpacing: 1)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: const Text('In Stock', style: TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.product.title, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 8),
            Text(widget.product.formattedPrice, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            const Divider(color: Colors.white12),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 22),
                const SizedBox(width: 4),
                Text(widget.product.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 20),
                const Text('|'),
                const SizedBox(width: 20),
                const Text('2.4k Reviews', style: TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Text(widget.product.description, style: const TextStyle(color: Colors.white60, height: 1.6, fontSize: 16)),
            const SizedBox(height: 40),
            const Text('Rating Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            _distRow('5', 0.85, '85%'),
            _distRow('4', 0.10, '10%'),
            _distRow('3', 0.05, '5%'),
            
            if (recs.isNotEmpty) ...[
              const SizedBox(height: 40),
              const Text('AI Recommendation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recs.length,
                  itemBuilder: (context, i) => Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(color: AppTheme.slate800, borderRadius: BorderRadius.circular(16)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(child: CachedNetworkImage(imageUrl: recs[i].thumbnail, fit: BoxFit.cover, width: double.infinity)),
                        Padding(padding: const EdgeInsets.all(8), child: Text(recs[i].title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _distRow(String label, double val, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(label),
          ),
          Expanded(child: LinearProgressIndicator(value: val, backgroundColor: Colors.white12, color: AppTheme.primary, minHeight: 8)),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: const BoxDecoration(
          color: AppTheme.backgroundDark,
          border: Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.favorite, color: AppTheme.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => ref.read(cartProvider.notifier).addToCart(widget.product),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))]),
                  alignment: Alignment.center,
                  child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
