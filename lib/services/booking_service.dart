import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_constants.dart';
import '../models/booking_model.dart';
import '../models/business_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createBooking(BookingModel booking) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.bookingsCollection)
          .add(booking.copyWith(id: '').toMap());

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookingModel>> getBookingsForBusiness(
    String businessId,
    String date,
  ) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('businessId', isEqualTo: businessId)
          .where('date', isEqualTo: date)
          .get();

      return doc.docs
          .map((e) => BookingModel.fromMap({
                'id': e.id,
                ...e.data(),
              }))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<BookingModel>> getUpcomingBookings(
    String businessId,
  ) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('businessId', isEqualTo: businessId)
          .where('date', isGreaterThanOrEqualTo: today)
          .orderBy('date')
          .orderBy('timeSlot')
          .get();

      return doc.docs
          .map((e) => BookingModel.fromMap({
                'id': e.id,
                ...e.data(),
              }))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({'status': status});
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getMonthlyBookingCount(String businessId) async {
    try {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0);

      final startDate = DateFormat('yyyy-MM-dd').format(firstDay);
      final endDate = DateFormat('yyyy-MM-dd').format(lastDay);

      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('businessId', isEqualTo: businessId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      return doc.docs.length;
    } catch (e) {
      return 0;
    }
  }

  List<String> generateAvailableSlots(
    BusinessModel business,
    String date,
    List<BookingModel> existingBookings,
  ) {
    final slots = <String>[];

    // Parse open and close times
    final openParts = business.openTime.split(':');
    final closeParts = business.closeTime.split(':');

    final openHour = int.parse(openParts[0]);
    final openMinute = int.parse(openParts[1]);
    final closeHour = int.parse(closeParts[0]);
    final closeMinute = int.parse(closeParts[1]);

    var currentTime = DateTime(0, 0, 0, openHour, openMinute);
    final closeTime = DateTime(0, 0, 0, closeHour, closeMinute);

    // Get booked time slots (excluding cancelled)
    final bookedSlots = existingBookings
        .where((b) => b.status != 'cancelled')
        .map((b) => b.timeSlot)
        .toSet();

    while (currentTime.isBefore(closeTime) || currentTime == closeTime) {
      final slotStr =
          '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';

      if (!bookedSlots.contains(slotStr)) {
        slots.add(slotStr);
      }

      currentTime = currentTime.add(Duration(minutes: business.slotDurationMinutes));
    }

    return slots;
  }
}
