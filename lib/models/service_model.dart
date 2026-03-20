class ServiceModel {
  final String id;
  final String name;
  final int durationMinutes;
  final double price;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.price,
    this.isActive = true,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 30,
      price: (map['price'] ?? 0.0).toDouble(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'durationMinutes': durationMinutes,
      'price': price,
      'isActive': isActive,
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    int? durationMinutes,
    double? price,
    bool? isActive,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
    );
  }
}
