import 'package:equatable/equatable.dart';

/// Pregnancy entity representing a user's pregnancy
class Pregnancy extends Equatable {
  /// Unique identifier
  final String id;
  
  /// User ID who owns this pregnancy record
  final String userId;
  
  /// Expected due date
  final DateTime dueDate;
  
  /// Date when pregnancy started (or last period date)
  final DateTime startDate;
  
  /// Number of babies in this pregnancy
  final int babyCount;
  
  /// Whether this pregnancy is active
  final bool isActive;
  
  /// Notes related to this pregnancy
  final List<Map<String, dynamic>>? notes;
  
  /// When this record was created
  final DateTime? createdAt;
  
  /// When this record was last updated
  final DateTime? updatedAt;
  
  /// Constructor
  const Pregnancy({
    required this.id,
    required this.userId,
    required this.dueDate,
    required this.startDate,
    required this.babyCount,
    required this.isActive,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
  
  /// Get the current trimester based on due date
  int get trimester {
    final now = DateTime.now();
    final totalDaysOfPregnancy = 280; // 40 weeks
    final daysRemaining = dueDate.difference(now).inDays;
    final daysPassed = totalDaysOfPregnancy - daysRemaining;
    
    if (daysPassed < 84) { // First 12 weeks
      return 1;
    } else if (daysPassed < 189) { // Next 15 weeks
      return 2;
    } else {
      return 3;
    }
  }
  
  /// Get the current week of pregnancy
  int get currentWeek {
    final now = DateTime.now();
    final daysSinceStart = now.difference(startDate).inDays;
    return (daysSinceStart / 7).ceil();
  }
  
  /// Check if the pregnancy is past the due date
  bool get isPastDue {
    final now = DateTime.now();
    return now.isAfter(dueDate);
  }
  
  /// Calculate days until due date
  int get daysUntilDue {
    final now = DateTime.now();
    return dueDate.difference(now).inDays;
  }
  
  @override
  List<Object?> get props => [
    id,
    userId,
    dueDate,
    startDate,
    babyCount,
    isActive,
    notes,
    createdAt,
    updatedAt,
  ];
}

/// Represents a health check during pregnancy
class HealthCheck extends Equatable {
  final String id;
  final DateTime date;
  final double? weight; // in kg
  final double? bloodPressureSystolic; // in mmHg
  final double? bloodPressureDiastolic; // in mmHg
  final String? notes;
  final String? healthProviderName;
  final String? location;

  const HealthCheck({
    required this.id,
    required this.date,
    this.weight,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.notes,
    this.healthProviderName,
    this.location,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        weight,
        bloodPressureSystolic,
        bloodPressureDiastolic,
        notes,
        healthProviderName,
        location,
      ];

  /// Create a copy of this HealthCheck with some modified fields
  HealthCheck copyWith({
    String? id,
    DateTime? date,
    double? weight,
    double? bloodPressureSystolic,
    double? bloodPressureDiastolic,
    String? notes,
    String? healthProviderName,
    String? location,
  }) {
    return HealthCheck(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      bloodPressureSystolic: bloodPressureSystolic ?? this.bloodPressureSystolic,
      bloodPressureDiastolic: bloodPressureDiastolic ?? this.bloodPressureDiastolic,
      notes: notes ?? this.notes,
      healthProviderName: healthProviderName ?? this.healthProviderName,
      location: location ?? this.location,
    );
  }
}

/// Represents a note during pregnancy
class Note extends Equatable {
  final String id;
  final DateTime date;
  final String content;
  final String? title;

  const Note({
    required this.id,
    required this.date,
    required this.content,
    this.title,
  });

  @override
  List<Object?> get props => [id, date, content, title];

  /// Create a copy of this Note with some modified fields
  Note copyWith({
    String? id,
    DateTime? date,
    String? content,
    String? title,
  }) {
    return Note(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      title: title ?? this.title,
    );
  }
} 