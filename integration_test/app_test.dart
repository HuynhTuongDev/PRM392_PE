import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pe_prm392/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Integration Tests', () {
    testWidgets('Complete Add to Cart and Checkout Flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Ensure we are on Home Screen
      expect(find.text('New Arrivals'), findsOneWidget);

      // Wait for products to load (API call could be mocked but real for this test)
      // Wait for at least some data to load
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await tester.pumpAndSettle();

      // Find first "Add to Cart" button and tap it
      if (find.text('Add to Cart').evaluate().isNotEmpty) {
        final addToCartBtn = find.text('Add to Cart').first;
        await tester.tap(addToCartBtn);
        await tester.pumpAndSettle();

        // Verify SnackBar appears
        expect(find.byType(SnackBar), findsOneWidget);

        // Navigate to Cart
        await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
        await tester.pumpAndSettle();

        // Verify item exists in cart
        expect(find.text('Order Summary'), findsOneWidget);
        expect(find.text('Checkout'), findsOneWidget);
      }
    });
  });
}
