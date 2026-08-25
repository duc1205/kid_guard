import 'package:flutter/material.dart';

import 'core/di/app_locator.dart';
import 'core/theme/app_theme.dart';
import 'presentation/home/home_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLocator.init();
  runApp(const ScanPriceApp());
}

class ScanPriceApp extends StatelessWidget {
  const ScanPriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan Price',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeShell(),
    );
  }
}
