import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final businessAsync = ref.watch(currentBusinessProvider);
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0D1120),
        title: Text(
          'Settings',
          style: GoogleFonts.syne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF0EDE8),
          ),
        ),
      ),
      body: businessAsync.when(
        data: (business) {
          if (business == null) {
            return Center(
              child: Text(
                'Business not found',
                style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Business Profile Section
                _buildSectionTitle('Business Profile'),
                const SizedBox(height: 12),
                _buildSettingField('Business Name', business.name),
                const SizedBox(height: 12),
                _buildSettingField('Phone', business.phone),
                const SizedBox(height: 12),
                _buildSettingField('City', business.city),
                const SizedBox(height: 12),
                _buildSettingField(
                  'Working Hours',
                  '${business.openTime} - ${business.closeTime}',
                ),
                const SizedBox(height: 24),

                // Services Section
                _buildSectionTitle('Services'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1120),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6B7280).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Manage your services',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: const Color(0xFFF0EDE8),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/services-setup'),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add, edit, or remove your services',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Plan Section
                _buildSectionTitle('Plan'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1120),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6B7280).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Plan',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            business.planType.toUpperCase(),
                            style: GoogleFonts.syne(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF0EDE8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getPlanColor(business.planType)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getPlanColor(business.planType),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          business.planType == 'free'
                              ? 'Free'
                              : business.planType == 'basic'
                                  ? 'Basic'
                                  : 'Pro',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getPlanColor(business.planType),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Account Section
                _buildSectionTitle('Account'),
                const SizedBox(height: 12),
                userAsync.when(
                  data: (user) => _buildSettingField(
                    'Email',
                    user?.email ?? 'No email',
                  ),
                  loading: () => _buildSettingField('Email', 'Loading...'),
                  error: (_, __) => _buildSettingField('Email', 'Error'),
                ),
                const SizedBox(height: 24),

                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFF87171),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showSignOutDialog(context),
                    child: Text(
                      'Sign Out',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFFF87171),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Error loading settings',
            style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.syne(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF0EDE8),
        ),
      ),
    );
  }

  Widget _buildSettingField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1120),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6B7280).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: const Color(0xFFF0EDE8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPlanColor(String planType) {
    switch (planType.toLowerCase()) {
      case 'pro':
        return const Color(0xFFFFD700);
      case 'basic':
        return const Color(0xFF34D399);
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1120),
        title: Text(
          'Sign Out',
          style: GoogleFonts.syne(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF0EDE8),
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.dmSans(
            color: const Color(0xFFF0EDE8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(
                color: const Color(0xFF6366F1),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await AuthService().signOut();
              if (mounted) {
                context.go('/login');
              }
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.dmSans(
                color: const Color(0xFFF87171),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}