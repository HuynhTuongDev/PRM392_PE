import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/main_navigation.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ECommerceApp(),
    ),
  );
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce UI Implementation App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Switched to dark theme by default
      home: const MainNavigation(),
    );
  }
}
