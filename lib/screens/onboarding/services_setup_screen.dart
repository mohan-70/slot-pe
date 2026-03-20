import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../models/service_model.dart';

class ServicesSetupScreen extends ConsumerStatefulWidget {
  const ServicesSetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ServicesSetupScreen> createState() =>
      _ServicesSetupScreenState();
}

class _ServicesSetupScreenState extends ConsumerState<ServicesSetupScreen> {
  List<ServiceModel> services = [];

  void _showServiceBottomSheet() {
    final serviceNameController = TextEditingController();
    final priceController = TextEditingController();
    int selectedDuration = 30;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Service',
                style: GoogleFonts.syne(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: serviceNameController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Service Name',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: selectedDuration,
              items: [15, 30, 45, 60, 90, 120]
                  .map((dur) => DropdownMenuItem(
                      value: dur, child: Text('$dur mins')))
                  .toList(),
              onChanged: (val) => selectedDuration = val ?? 30,
              decoration: const InputDecoration(
                labelText: 'Duration',
              ),
              dropdownColor: AppTheme.surface,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              style: const TextStyle(color: AppTheme.textPrimary),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                labelText: 'Price',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (serviceNameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty) {
                    setState(() {
                      services.add(ServiceModel(
                        id: const Uuid().v4(),
                        name: serviceNameController.text,
                        durationMinutes: selectedDuration,
                        price: double.parse(priceController.text),
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Service'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add Services',
            style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: services.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_outlined,
                            size: 64, color: AppTheme.textMuted),
                        const SizedBox(height: 16),
                        Text('No services added yet',
                            style: GoogleFonts.dmSans()),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(service.name,
                                        style: GoogleFonts.dmSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${service.durationMinutes} mins • ₹${service.price.toStringAsFixed(0)}',
                                      style: GoogleFonts.dmSans(
                                          color: AppTheme.textMuted,
                                          fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppTheme.error),
                                onPressed: () {
                                  setState(() => services.removeAt(index));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showServiceBottomSheet,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Service'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: services.isEmpty
                        ? null
                        : () async {
                            context.go('/dashboard');
                          },
                    child: const Text('Continue to Dashboard'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}