import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'serviceHomeScreen.dart';
import 'myRfqsScreen.dart';
import 'myOrdersScreen.dart';
import 'nearbyScreen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ServiceHomeScreen(),
    const MyRfqsScreen(),
    const MyOrdersScreen(),
    NearbyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(color: AppColors.primaryColor),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(index: 0, icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
              _buildNavItem(index: 1, icon: Icons.request_quote_outlined, activeIcon: Icons.request_quote, label: 'My RFQs'),
              _buildNavItem(index: 2, icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'Orders'),
              _buildNavItem(index: 3, icon: Icons.location_on_outlined, activeIcon: Icons.location_on, label: 'Nearby'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon, required IconData activeIcon, required String label}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: Colors.white, size: 22),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
