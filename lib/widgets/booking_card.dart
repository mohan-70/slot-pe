import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingCard extends StatefulWidget {
  final BookingModel booking;
  final VoidCallback onStatusChanged;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  late BookingService _bookingService;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService();
  }

  Color _getStatusColor() {
    switch (widget.booking.status) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'confirmed':
        return const Color(0xFF34D399);
      case 'cancelled':
        return const Color(0xFFF87171);
      case 'completed':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0D1120),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.booking.customerName,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF0EDE8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.booking.customerPhone,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.booking.status.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.booking.serviceName,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.booking.date} at ${widget.booking.timeSlot}',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.booking.status == 'pending' ||
                widget.booking.status == 'confirmed')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    if (widget.booking.status == 'pending')
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Confirm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF34D399),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() => isLoading = true);
                                  await _bookingService.updateBookingStatus(
                                    widget.booking.id,
                                    'confirmed',
                                  );
                                  setState(() => isLoading = false);
                                  widget.onStatusChanged();
                                },
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF87171),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                await _bookingService.updateBookingStatus(
                                  widget.booking.id,
                                  'cancelled',
                                );
                                setState(() => isLoading = false);
                                widget.onStatusChanged();
                              },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}