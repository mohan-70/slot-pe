import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/business_provider.dart';
import '../../widgets/booking_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsync = ref.watch(currentBusinessProvider);
    final todayBookingsAsync = ref.watch(todayBookingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: businessAsync.when(
          data: (business) => _buildAppBar(business?.name ?? 'Good morning'),
          loading: () => _buildAppBar('Good morning'),
          error: (_, __) => _buildAppBar('Good morning'),
        ),
      ),
      body: businessAsync.when(
        data: (business) {
          if (business == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Setup your business first',
                    style: GoogleFonts.syne(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF0EDE8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/setup'),
                    child: const Text('Go to Setup'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Cards
                _buildStatsCards(ref, business.id),
                const SizedBox(height: 24),

                // Today's Appointments Section
                Text(
                  "Today's Appointments",
                  style: GoogleFonts.syne(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF0EDE8),
                  ),
                ),
                const SizedBox(height: 12),

                // Bookings List or Empty State
                todayBookingsAsync.when(
                  data: (bookings) => bookings.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bookings.length,
                          itemBuilder: (context, index) => BookingCard(
                            booking: bookings[index],
                            onStatusChanged: () {
                              ref.refresh(todayBookingsProvider);
                            },
                          ),
                        ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => _buildEmptyState(),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Error loading dashboard',
            style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(String businessName) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0D1120),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning 👋',
            style: GoogleFonts.syne(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
          Text(
            businessName,
            style: GoogleFonts.syne(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF0EDE8),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: const Color(0xFFF0EDE8),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStatsCards(WidgetRef ref, String businessId) {
    final todayBookings = ref.watch(todayBookingsProvider);
    final upcomingBookings = ref.watch(upcomingBookingsProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          todayBookings.when(
            data: (bookings) =>
                _buildStatCard('Today', '${bookings.length}', Icons.calendar_today),
            loading: () => _buildStatCard('Today', '...', Icons.calendar_today),
            error: (_, __) => _buildStatCard('Today', '0', Icons.calendar_today),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 160,
            child: _buildStatCard(
              'This Month',
              upcomingBookings.when(
                data: (bookings) {
                  final now = DateTime.now();
                  final thisMonth = bookings
                      .where((b) {
                        final date = DateTime.parse(b.date);
                        return date.month == now.month &&
                            date.year == now.year;
                      })
                      .toList();
                  return '${thisMonth.length}';
                },
                loading: () => '...',
                error: (_, __) => '0',
              ),
              Icons.calendar_month,
            ),
          ),
          const SizedBox(width: 12),
          upcomingBookings.when(
            data: (bookings) {
              final pending =
                  bookings.where((b) => b.status == 'pending').toList();
              return _buildStatCard(
                'Pending',
                '${pending.length}',
                Icons.hourglass_empty,
              );
            },
            loading: () => _buildStatCard('Pending', '...', Icons.hourglass_empty),
            error: (_, __) =>
                _buildStatCard('Pending', '0', Icons.hourglass_empty),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
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
          Icon(icon, color: const Color(0xFF6366F1), size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.syne(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF0EDE8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 64,
              color: const Color(0xFF6B7280).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings today',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => context.go('/my-link'),
            child: Text(
              'Share My Link',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFF6366F1),
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _showAddBookingSheet(context),
            child: Text(
              'Add Booking',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6366F1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1120),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Booking',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF0EDE8),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
              decoration: InputDecoration(
                labelText: 'Customer Name',
                labelStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Create Booking'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}