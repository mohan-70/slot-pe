import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/booking_model.dart';
import '../../models/service_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/business_provider.dart';
import '../../services/booking_service.dart';
import '../../widgets/service_card.dart';

class CustomerBookingScreen extends ConsumerStatefulWidget {
  final String slug;

  const CustomerBookingScreen({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  ConsumerState<CustomerBookingScreen> createState() =>
      _CustomerBookingScreenState();
}

class _CustomerBookingScreenState
    extends ConsumerState<CustomerBookingScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;

  ServiceModel? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _notesController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0D1120),
        title: Text(
          'Book an Appointment',
          style: GoogleFonts.syne(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF0EDE8),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Header
            _buildBusinessHeader(),
            const SizedBox(height: 24),

            // Service Selection
            _buildSectionTitle('Select Service'),
            const SizedBox(height: 12),
            _buildServiceSelection(),
            const SizedBox(height: 24),

            // Date Selection
            _buildSectionTitle('Select Date'),
            const SizedBox(height: 12),
            _buildDateSelection(),
            const SizedBox(height: 24),

            // Time Slots
            _buildSectionTitle('Select Time'),
            const SizedBox(height: 12),
            _buildTimeSlots(),
            const SizedBox(height: 24),

            // Customer Details
            _buildSectionTitle('Your Details'),
            const SizedBox(height: 12),
            _buildCustomerDetailsForm(),
            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  disabledBackgroundColor: const Color(0xFF6B7280),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _submitBooking,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Confirm Booking',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHeader() {
    // In a real app, fetch business by slug from Firestore
    return Container(
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
          Text(
            'Business Name',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF0EDE8),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF6366F1),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Service',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'City Name',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.syne(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFF0EDE8),
      ),
    );
  }

  Widget _buildServiceSelection() {
    // Mock services
    final services = [
      ServiceModel(
        id: '1',
        name: 'Haircut',
        durationMinutes: 30,
        price: 500,
      ),
      ServiceModel(
        id: '2',
        name: 'Hair Color',
        durationMinutes: 60,
        price: 1500,
      ),
      ServiceModel(
        id: '3',
        name: 'Massage',
        durationMinutes: 45,
        price: 800,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: services
            .map(
              (service) => ServiceCard(
                service: service,
                isSelected: _selectedService?.id == service.id,
                onTap: () {
                  setState(() {
                    _selectedService = service;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDateSelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          7,
          (index) {
            final date = DateTime.now().add(Duration(days: index));
            final isSelected = _selectedDate?.day == date.day &&
                _selectedDate?.month == date.month &&
                _selectedDate?.year == date.year;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                  _selectedTimeSlot = null;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF0D1120),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF6B7280).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('MMM').format(date),
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${date.day}',
                      style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFF0EDE8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    final timeSlots = [
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        final isSelected = _selectedTimeSlot == slot;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTimeSlot = slot;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF0D1120),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF6B7280).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                slot,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      isSelected ? Colors.white : const Color(0xFFF0EDE8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerDetailsForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            labelStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
            hintStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter 10-digit phone number',
            labelStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
            hintStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorText:
                _phoneController.text.isNotEmpty &&
                        _phoneController.text.length != 10
                    ? 'Enter a valid 10-digit number'
                    : null,
          ),
          maxLength: 10,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          style: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
          decoration: InputDecoration(
            labelText: 'Notes (Optional)',
            hintText: 'Add any special requests...',
            labelStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
            hintStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitBooking() async {
    if (_selectedService == null || _selectedDate == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: const Color(0xFFF87171),
        ),
      );
      return;
    }

    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid customer details'),
          backgroundColor: const Color(0xFFF87171),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, create booking in Firestore
      // For now, just show success message
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFF87171),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1120),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF34D399),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Booking Confirmed!',
              style: GoogleFonts.syne(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF0EDE8),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your appointment has been confirmed',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // In a real app, navigate back or to confirmation screen
                },
                child: Text(
                  'Done',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}