import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../history/history_screen.dart';
import '../scan/scan_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const ScanScreen(),
          HistoryScreen(active: _index == 1),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.photo_camera_outlined),
            selectedIcon: Icon(Icons.photo_camera_rounded),
            label: 'Quét',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Lịch sử',
          ),
        ],
        backgroundColor: Colors.white,
        indicatorColor: AppColors.forest.withValues(alpha: 0.12),
      ),
    );
  }
}
