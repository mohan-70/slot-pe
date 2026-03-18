import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/business_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';

class BusinessSetupScreen extends ConsumerStatefulWidget {
  const BusinessSetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BusinessSetupScreen> createState() =>
      _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends ConsumerState<BusinessSetupScreen> {
  late PageController _pageController;
  int currentPage = 0;

  final categories = [
    'Salon',
    'Clinic',
    'Photography',
    'Gym',
    'Tutoring',
    'Other'
  ];
  final daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  late TextEditingController businessNameController;
  late TextEditingController cityController;
  late TextEditingController phoneController;

  String? selectedCategory;
  List<String> selectedDays = [];
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  int selectedDuration = 30;
  String? generatedSlug;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    businessNameController = TextEditingController();
    cityController = TextEditingController();
    phoneController = TextEditingController();

    businessNameController.addListener(_updateSlug);
    cityController.addListener(_updateSlug);
  }

  void _updateSlug() {
    final name = businessNameController.text;
    final city = cityController.text;
    if (name.isNotEmpty && city.isNotEmpty) {
      final business = ref.read(businessServiceProvider);
      setState(() {
        generatedSlug = business.generateSlug(name, city);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    businessNameController.dispose();
    cityController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      appBar: AppBar(
        title: Text('Set Up Your Business',
            style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() => currentPage = page);
        },
        children: [
          _buildStep1(),
          _buildStep2(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Business Details',
              style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: businessNameController,
            style: const TextStyle(color: Color(0xFFF0EDE8)),
            decoration: InputDecoration(
              labelText: 'Business Name',
              hintText: 'e.g., John\'s Salon',
              filled: true,
              fillColor: const Color(0xFF0D1120),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            items: categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) => setState(() => selectedCategory = val),
            decoration: InputDecoration(
              labelText: 'Category',
              filled: true,
              fillColor: const Color(0xFF0D1120),
            ),
            dropdownColor: const Color(0xFF0D1120),
            style: const TextStyle(color: Color(0xFFF0EDE8)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: cityController,
            style: const TextStyle(color: Color(0xFFF0EDE8)),
            decoration: InputDecoration(
              labelText: 'City',
              hintText: 'e.g., New York',
              filled: true,
              fillColor: const Color(0xFF0D1120),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            style: const TextStyle(color: Color(0xFFF0EDE8)),
            decoration: InputDecoration(
              labelText: 'Phone',
              hintText: '+1 (555) 000-0000',
              filled: true,
              fillColor: const Color(0xFF0D1120),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1120),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your booking link:',
                    style: GoogleFonts.dmSans(
                        color: const Color(0xFF6B7280), fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  generatedSlug != null
                      ? 'slotpe.in/$generatedSlug'
                      : 'slotpe.in/your-business',
                  style: GoogleFonts.syne(
                      color: const Color(0xFF6366F1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: currentPage == 0
                  ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                  : null,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Business Hours & Slots',
              style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Text('Working Days',
              style: GoogleFonts.dmSans(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: daysOfWeek
                .map((day) => FilterChip(
                      label: Text(day),
                      selected: selectedDays.contains(day),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: const Color(0xFF0D1120),
                      labelStyle: TextStyle(
                          color: selectedDays.contains(day)
                              ? Colors.white
                              : const Color(0xFFF0EDE8)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Open Time',
                        style: GoogleFonts.dmSans(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: openTime ?? const TimeOfDay(hour: 9, minute: 0),
                        );
                        if (time != null) {
                          setState(() => openTime = time);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1120),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          openTime?.format(context) ?? '09:00',
                          style: GoogleFonts.dmSans(
                              color: const Color(0xFFF0EDE8), fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Close Time',
                        style: GoogleFonts.dmSans(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: closeTime ?? const TimeOfDay(hour: 18, minute: 0),
                        );
                        if (time != null) {
                          setState(() => closeTime = time);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1120),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          closeTime?.format(context) ?? '18:00',
                          style: GoogleFonts.dmSans(
                              color: const Color(0xFFF0EDE8), fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Slot Duration (Minutes)',
              style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: selectedDuration,
            items: [15, 30, 45, 60]
                .map((dur) =>
                    DropdownMenuItem(value: dur, child: Text('$dur mins')))
                .toList(),
            onChanged: (val) => setState(() => selectedDuration = val ?? 30),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0D1120),
            ),
            dropdownColor: const Color(0xFF0D1120),
            style: const TextStyle(color: Color(0xFFF0EDE8)),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final user = ref.read(currentUserProvider);
                if (user != null &&
                    businessNameController.text.isNotEmpty &&
                    selectedCategory != null &&
                    cityController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    selectedDays.isNotEmpty &&
                    openTime != null &&
                    closeTime != null &&
                    generatedSlug != null) {
                  final business = BusinessModel(
                    id: '',
                    ownerId: user.uid,
                    name: businessNameController.text,
                    category: selectedCategory!,
                    phone: phoneController.text,
                    city: cityController.text,
                    bookingSlug: generatedSlug!,
                    workingDays: selectedDays,
                    openTime:
                        '${openTime!.hour.toString().padLeft(2, '0')}:${openTime!.minute.toString().padLeft(2, '0')}',
                    closeTime:
                        '${closeTime!.hour.toString().padLeft(2, '0')}:${closeTime!.minute.toString().padLeft(2, '0')}',
                    slotDurationMinutes: selectedDuration,
                    createdAt: DateTime.now(),
                  );

                  try {
                    await ref
                        .read(businessServiceProvider)
                        .createBusiness(business);
                    if (mounted) {
                      context.go('/services-setup');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Create My Profile'),
            ),
          ),
        ],
      ),
    );
  }
}