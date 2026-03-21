import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/business_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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

  String? fullPhoneNumber;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              )
            : null,
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
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Business Name',
              hintText: 'e.g., John\'s Salon',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            items: categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) => setState(() => selectedCategory = val),
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
            dropdownColor: AppTheme.surface,
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: cityController,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'e.g., New York',
            ),
          ),
          const SizedBox(height: 16),
            IntlPhoneField(
            decoration: InputDecoration(
              labelText: 'Phone',
              hintText: 'Enter phone number',
              filled: true,
              fillColor: AppTheme.surface.withOpacity(0.5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            initialCountryCode: 'IN',

            onChanged: (phoneNumber) => setState(() => fullPhoneNumber = phoneNumber.completeNumber),
            validator: (value) {
              if (value == null || value.number.isEmpty) return 'Please enter a valid phone number';
              return null;
            },
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your booking link:',
                    style: GoogleFonts.dmSans(
                        color: AppTheme.textMuted, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  generatedSlug != null
                      ? 'slotpe.in/$generatedSlug'
                      : 'slotpe.in/your-business',
                  style: GoogleFonts.syne(
                      color: AppTheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (businessNameController.text.isEmpty ||
                    selectedCategory == null ||
                    cityController.text.isEmpty ||
                    fullPhoneNumber == null || fullPhoneNumber!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all business details',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      backgroundColor: AppTheme.error,
                    ),
                  );
                  return;
                }
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
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
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.surface,
                      labelStyle: TextStyle(
                          color: selectedDays.contains(day)
                              ? Colors.white
                              : AppTheme.textPrimary),
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
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Text(
                          openTime?.format(context) ?? '09:00',
                          style: GoogleFonts.dmSans(
                              color: AppTheme.textPrimary, fontSize: 16),
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
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Text(
                          closeTime?.format(context) ?? '18:00',
                          style: GoogleFonts.dmSans(
                              color: AppTheme.textPrimary, fontSize: 16),
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
            initialValue: selectedDuration,
            items: [15, 30, 45, 60]
                .map((dur) =>
                    DropdownMenuItem(value: dur, child: Text('$dur mins')))
                .toList(),
            onChanged: (val) => setState(() => selectedDuration = val ?? 30),
            decoration: const InputDecoration(),
            dropdownColor: AppTheme.surface,
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final user = ref.read(currentUserProvider);
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please sign in first'),
                      backgroundColor: AppTheme.error,
                    ),
                  );
                  return;
                }

                if (businessNameController.text.isEmpty ||
                    selectedCategory == null ||
                    cityController.text.isEmpty ||
                    fullPhoneNumber == null || fullPhoneNumber!.isEmpty ||
                    selectedDays.isEmpty ||
                    openTime == null ||
                    closeTime == null ||
                    generatedSlug == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all business details and hours',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      backgroundColor: AppTheme.error,
                    ),
                  );
                  return;
                }

                final business = BusinessModel(
                    id: '',
                    ownerId: user.uid,
                    name: businessNameController.text,
                    category: selectedCategory!,
                    phone: fullPhoneNumber!,
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

                  final messenger = ScaffoldMessenger.of(context);
                  final goRouter = GoRouter.of(context);

                  try {
                    await ref
                        .read(businessServiceProvider)
                        .createBusiness(business);
                    if (mounted) {
                      goRouter.go('/services-setup');
                    }
                  } catch (e) {
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error: $e',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
