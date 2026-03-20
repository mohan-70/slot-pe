import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/business_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Slotpe',
              style: GoogleFonts.syne(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
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