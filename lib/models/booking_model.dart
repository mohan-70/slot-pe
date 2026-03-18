class BookingModel {
  final String id;
  final String businessId;
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final String customerName;
  final String customerPhone;
  final String date;
  final String timeSlot;
  final String status;
  final DateTime createdAt;
  final String? notes;

  BookingModel({
    required this.id,
    required this.businessId,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.customerName,
    required this.customerPhone,
    required this.date,
    required this.timeSlot,
    this.status = 'pending',
    required this.createdAt,
    this.notes,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      businessId: map['businessId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      servicePrice: (map['servicePrice'] ?? 0.0).toDouble(),
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      date: map['date'] ?? '',
      timeSlot: map['timeSlot'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessId': businessId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'date': date,
      'timeSlot': timeSlot,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }

  BookingModel copyWith({
    String? id,
    String? businessId,
    String? serviceId,
    String? serviceName,
    double? servicePrice,
    String? customerName,
    String? customerPhone,
    String? date,
    String? timeSlot,
    String? status,
    DateTime? createdAt,
    String? notes,
  }) {
    return BookingModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
