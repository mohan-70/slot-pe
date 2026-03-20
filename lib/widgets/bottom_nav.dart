import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          backgroundColor: AppTheme.surface,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textMuted,
          type: BottomNavigationBarType.fixed,
          currentIndex: _getSelectedIndex(currentLocation),
          onTap: (index) => _onNavTapped(context, index),
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                Icons.home_outlined,
                Icons.home_filled,
                currentLocation.contains('/dashboard'),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                Icons.calendar_month_outlined,
                Icons.calendar_month,
                currentLocation.contains('/bookings'),
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                Icons.link_outlined,
                Icons.link,
                currentLocation.contains('/my-link'),
              ),
              label: 'My Link',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(
                Icons.settings_outlined,
                Icons.settings,
                currentLocation.contains('/settings'),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData outlinedIcon, IconData filledIcon, bool isActive) {
    return Icon(isActive ? filledIcon : outlinedIcon);
  }

  int _getSelectedIndex(String location) {
    if (location.contains('/dashboard')) return 0;
    if (location.contains('/bookings')) return 1;
    if (location.contains('/my-link')) return 2;
    if (location.contains('/settings')) return 3;
    return 0;
  }

  void _onNavTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/bookings');
        break;
      case 2:
        context.go('/my-link');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }
}
