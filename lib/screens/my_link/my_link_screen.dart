import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/business_provider.dart';

class MyLinkScreen extends ConsumerWidget {
  const MyLinkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(currentBusinessProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0D1120),
        title: Text(
          'My Link',
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

          final bookingUrl = 'https://slotpe.in/${business.bookingSlug}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // URL Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1120),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6B7280).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Booking Link',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF05080F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                bookingUrl,
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  color: const Color(0xFF6366F1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Link copied!'),
                                    backgroundColor:
                                        const Color(0xFF34D399),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.copy,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Share Buttons
                Text(
                  'Share Link',
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF0EDE8),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _shareOnWhatsApp(
                        context,
                        business.name,
                        bookingUrl,
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(
                      'Share on WhatsApp',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF6366F1),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Share.share(
                        'Book an appointment with ${business.name} here: $bookingUrl',
                        subject: 'Book an appointment',
                      );
                    },
                    icon: const Icon(Icons.share_outlined),
                    label: Text(
                      'Share Link',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // QR Code Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1120),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6B7280).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2,
                        size: 80,
                        color: const Color(0xFF6B7280).withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'QR Code — Coming Soon',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tips Section
                Text(
                  'How to Use Your Link',
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF0EDE8),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTip(
                  1,
                  'Copy and share',
                  'Share your link on social media, WhatsApp, or email',
                ),
                const SizedBox(height: 12),
                _buildTip(
                  2,
                  'Customers can book',
                  'Customers can view your services and book directly',
                ),
                const SizedBox(height: 12),
                _buildTip(
                  3,
                  'Auto notifications',
                  'You and customers get instant booking confirmations',
                ),
                const SizedBox(height: 12),
                _buildTip(
                  4,
                  'No sign-up required',
                  'Customers can book without creating an account',
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Error loading business',
            style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(int number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF6366F1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: GoogleFonts.syne(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: const Color(0xFFF0EDE8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _shareOnWhatsApp(
    BuildContext context,
    String businessName,
    String url,
  ) async {
    final message = 'Hey! Book an appointment with $businessName: $url';
    final whatsappUrl =
        'https://wa.me/?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('WhatsApp not installed'),
          backgroundColor: const Color(0xFFF87171),
        ),
      );
    }
  }
}