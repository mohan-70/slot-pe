import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../models/service_model.dart';
import '../../providers/business_provider.dart';

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
      builder: (context) => Container(
        color: const Color(0xFF0D1120),
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
              style: const TextStyle(color: Color(0xFFF0EDE8)),
              decoration: InputDecoration(
                labelText: 'Service Name',
                filled: true,
                fillColor: const Color(0xFF05080F),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedDuration,
              items: [15, 30, 45, 60, 90, 120]
                  .map((dur) => DropdownMenuItem(
                      value: dur, child: Text('$dur mins')))
                  .toList(),
              onChanged: (val) => selectedDuration = val ?? 30,
              decoration: InputDecoration(
                labelText: 'Duration',
                filled: true,
                fillColor: const Color(0xFF05080F),
              ),
              dropdownColor: const Color(0xFF0D1120),
              style: const TextStyle(color: Color(0xFFF0EDE8)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              style: const TextStyle(color: Color(0xFFF0EDE8)),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                labelText: 'Price',
                filled: true,
                fillColor: const Color(0xFF05080F),
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
      backgroundColor: const Color(0xFF05080F),
      appBar: AppBar(
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
                        Icon(Icons.shopping_bag_outlined,
                            size: 64, color: const Color(0xFF6B7280)),
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
                        color: const Color(0xFF0D1120),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(service.name,
                                        style: GoogleFonts.dmSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${service.durationMinutes} mins • ₹${service.price.toStringAsFixed(0)}',
                                      style: GoogleFonts.dmSans(
                                          color: const Color(0xFF6B7280),
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Color(0xFFF87171)),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: services.isEmpty
                          ? const Color(0xFF6B7280)
                          : const Color(0xFF6366F1),
                    ),
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