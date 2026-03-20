import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayBookings = ref.watch(todayBookingsProvider);
    final upcomingBookings = ref.watch(upcomingBookingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.surface,
        title: Text(
          'Bookings',
          style: GoogleFonts.syne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textMuted,
          labelStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Today Tab
          todayBookings.when(
            data: (bookings) => bookings.isEmpty
                ? _buildEmptyState('Today')
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) => BookingCard(
                      booking: bookings[index],
                      onStatusChanged: () {
                        ref.invalidate(todayBookingsProvider);
                      },
                    ),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildEmptyState('Today'),
          ),

          // Upcoming Tab
          upcomingBookings.when(
            data: (bookings) {
              final upcoming = bookings
                  .where(
                    (b) => DateTime.parse(b.date).isAfter(DateTime.now()),
                  )
                  .toList();
              return upcoming.isEmpty
                  ? _buildEmptyState('Upcoming')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: upcoming.length,
                      itemBuilder: (context, index) => BookingCard(
                        booking: upcoming[index],
                        onStatusChanged: () {
                          ref.invalidate(upcomingBookingsProvider);
                        },
                      ),
                    );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildEmptyState('Upcoming'),
          ),

          // All Tab
          upcomingBookings.when(
            data: (bookings) => bookings.isEmpty
                ? _buildEmptyState('All')
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) => BookingCard(
                      booking: bookings[index],
                      onStatusChanged: () {
                        ref.invalidate(upcomingBookingsProvider);
                      },
                    ),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildEmptyState('All'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No bookings in $tabName',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
