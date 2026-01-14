class SubscriptionModel {
  final String plan; // 'month' or 'year'
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  SubscriptionModel({
    required this.plan,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      plan: json['plan'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  SubscriptionModel copyWith({
    String? plan,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return SubscriptionModel(
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
