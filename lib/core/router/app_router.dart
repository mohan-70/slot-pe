import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/booking_page/customer_booking_screen.dart';
import '../../screens/bookings/bookings_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/my_link/my_link_screen.dart';
import '../../screens/onboarding/business_setup_screen.dart';
import '../../screens/onboarding/services_setup_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/splash_screen.dart';
import '../../widgets/bottom_nav.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    redirect: (context, state) async {
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      return authState.when(
        data: (user) {

          if (user == null) {
            return isLoggingIn || isSplash ? null : '/login';
          }

          // Check if business is set up
          final businessAsync = ref.watch(currentBusinessProvider);
          return businessAsync.when(
            data: (business) {
              if (business == null) {
                return state.matchedLocation == '/setup'
                    ? null
                    : '/setup';
              }
              if (isLoggingIn) {
                return '/dashboard';
              }
              return null;
            },
            loading: () => isSplash ? null : '/splash',
            error: (_, __) => '/login',
          );
        },
        loading: () => isSplash ? null : '/splash',
        error: (_, __) => '/login',
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const BusinessSetupScreen(),
      ),
      GoRoute(
        path: '/services-setup',
        builder: (context, state) => const ServicesSetupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomNavigationBar: const BottomNav(),
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const BookingsScreen(),
          ),
          GoRoute(
            path: '/my-link',
            builder: (context, state) => const MyLinkScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/book/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug'];
          return CustomerBookingScreen(slug: slug ?? '');
        },
      ),
    ],
  );
});
