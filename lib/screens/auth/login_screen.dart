import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Slotpe',
                style: GoogleFonts.syne(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Appointments. Simplified.',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 48),
              _GoogleSignInButton(
                onPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  final userCredential = await authService.signInWithGoogle();
                  if (userCredential != null && context.mounted) {
                    final business =
                        await ref.read(businessServiceProvider).getBusinessByOwnerId(
                              userCredential.user!.uid,
                            );

                    if (context.mounted) {
                      if (business != null) {
                        context.go('/dashboard');
                      } else {
                        context.go('/setup');
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _GoogleSignInButton({required this.onPressed});

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : () async {
        setState(() => isLoading = true);
        widget.onPressed();
        if (mounted) setState(() => isLoading = false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.login),
      label: Text(
        isLoading ? 'Signing in...' : 'Sign in with Google',
        style: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
