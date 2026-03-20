import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
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
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Appointments. Simplified.',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 48),
              _GoogleSignInButton(
                onPressed: () async {
                  try {
                    final authService = ref.read(authServiceProvider);
                    final userCredential = await authService.signInWithGoogle();

                    if (userCredential != null && context.mounted) {
                      final business = await ref
                          .read(businessServiceProvider)
                          .getBusinessByOwnerId(
                            userCredential.user!.uid,
                          );

                      if (context.mounted) {
                        if (business != null) {
                          context.go('/dashboard');
                        } else {
                          context.go('/setup');
                        }
                      }
                    } else if (context.mounted) {
                      // Only show snackbar if user didn't cancel (userCredential == null)
                      // This part depends on if we can distinguish cancels from errors in authService
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error signing in: $e',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          backgroundColor: AppTheme.error,
                        ),
                      );
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
  final Future<void> Function() onPressed;

  const _GoogleSignInButton({required this.onPressed});

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : () async {
              setState(() => isLoading = true);
              try {
                await widget.onPressed();
              } finally {
                if (mounted) setState(() => isLoading = false);
              }
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
