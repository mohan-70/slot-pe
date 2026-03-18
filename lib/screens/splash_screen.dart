import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/business_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Map<String, dynamic>?>>(SplashScreenNotifier.provider,
        (previous, next) {
      next.whenData((data) {
        if (data != null) {
          final hasUser = data['hasUser'] as bool;
          final hasBusiness = data['hasBusiness'] as bool;
          final hasServices = data['hasServices'] as bool;

          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!context.mounted) return;
            if (!hasUser) {
              context.go('/login');
            } else if (!hasBusiness) {
              context.go('/setup');
            } else if (!hasServices) {
              context.go('/services-setup');
            } else {
              context.go('/dashboard');
            }
          });
        }
      });
    });

    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Slotpe',
              style: GoogleFonts.syne(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ],
        ),
      ),
    );
  }
}

final splashScreenProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = await ref.watch(authStateProvider.future);
  
  if (authState == null) {
    return {'hasUser': false};
  }

  final business = await ref.watch(currentBusinessProvider.future);

  return {
    'hasUser': true,
    'hasBusiness': business != null,
    'hasServices': true,
  };
});

class SplashScreenNotifier {
  static final provider = splashScreenProvider;
}