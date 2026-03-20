class BusinessModel {
  final String id;
  final String ownerId;
  final String name;
  final String category;
  final String phone;
  final String city;
  final String bookingSlug;
  final List<String> workingDays;
  final String openTime;
  final String closeTime;
  final int slotDurationMinutes;
  final bool isActive;
  final DateTime createdAt;
  final String planType;

  BusinessModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.category,
    required this.phone,
    required this.city,
    required this.bookingSlug,
    required this.workingDays,
    required this.openTime,
    required this.closeTime,
    this.slotDurationMinutes = 30,
    this.isActive = true,
    required this.createdAt,
    this.planType = 'free',
  });

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      bookingSlug: map['bookingSlug'] ?? '',
      workingDays: List<String>.from(map['workingDays'] ?? []),
      openTime: map['openTime'] ?? '09:00',
      closeTime: map['closeTime'] ?? '18:00',
      slotDurationMinutes: map['slotDurationMinutes'] ?? 30,
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      planType: map['planType'] ?? 'free',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'category': category,
      'phone': phone,
      'city': city,
      'bookingSlug': bookingSlug,
      'workingDays': workingDays,
      'openTime': openTime,
      'closeTime': closeTime,
      'slotDurationMinutes': slotDurationMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'planType': planType,
    };
  }

  BusinessModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? category,
    String? phone,
    String? city,
    String? bookingSlug,
    List<String>? workingDays,
    String? openTime,
    String? closeTime,
    int? slotDurationMinutes,
    bool? isActive,
    DateTime? createdAt,
    String? planType,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      bookingSlug: bookingSlug ?? this.bookingSlug,
      workingDays: workingDays ?? this.workingDays,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      planType: planType ?? this.planType,
    );
  }
}
