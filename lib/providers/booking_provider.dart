import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import 'business_provider.dart';

final bookingServiceProvider = Provider((ref) {
  return BookingService();
});

final todayBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final business = await ref.watch(currentBusinessProvider.future);
  if (business == null) {
    return [];
  }

  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return ref
      .read(bookingServiceProvider)
      .getBookingsForBusiness(business.id, today);
});

final upcomingBookingsProvider =
    FutureProvider<List<BookingModel>>((ref) async {
  final business = await ref.watch(currentBusinessProvider.future);
  if (business == null) {
    return [];
  }

  return ref.read(bookingServiceProvider).getUpcomingBookings(business.id);
});

final availableSlotsProvider =
    FutureProvider.family<List<String>, String>((ref, date) async {
  final business = await ref.watch(currentBusinessProvider.future);
  if (business == null) {
    return [];
  }

  final bookings = await ref
      .read(bookingServiceProvider)
      .getBookingsForBusiness(business.id, date);

  return ref
      .read(bookingServiceProvider)
      .generateAvailableSlots(business, date, bookings);
});
