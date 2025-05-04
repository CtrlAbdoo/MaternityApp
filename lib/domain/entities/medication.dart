import 'package:equatable/equatable.dart';

/// Medication entity representing a user's medication
class Medication extends Equatable {
  /// Unique identifier
  final String id;
  
  /// User ID who owns this medication record
  final String userId;
  
  /// Name of the medication
  final String name;
  
  /// Dosage amount (e.g., "10mg")
  final String dosage;
  
  /// Frequency of taking the medication (e.g., "Twice daily")
  final String frequency;
  
  /// Date when medication should start
  final DateTime startDate;
  
  /// Date when medication should end (optional)
  final DateTime? endDate;
  
  /// Additional notes about the medication
  final String? notes;
  
  /// Whether this medication is active
  final bool isActive;
  
  /// When this record was created
  final DateTime? createdAt;
  
  /// When this record was last updated
  final DateTime? updatedAt;
  
  /// Constructor
  const Medication({
    required this.id,
    required this.userId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });
  
  /// Check if the medication is current (started but not ended)
  bool get isCurrent {
    final now = DateTime.now();
    if (!isActive) return false;
    
    final hasStarted = now.isAfter(startDate) || now.isAtSameMomentAs(startDate);
    final hasEnded = endDate != null && now.isAfter(endDate!);
    
    return hasStarted && !hasEnded;
  }
  
  /// Check if the medication is upcoming (not started yet)
  bool get isUpcoming {
    final now = DateTime.now();
    return isActive && now.isBefore(startDate);
  }
  
  /// Check if the medication is ended
  bool get isEnded {
    final now = DateTime.now();
    return !isActive || (endDate != null && now.isAfter(endDate!));
  }
  
  /// Get days until medication is started
  int get daysUntilStart {
    final now = DateTime.now();
    if (now.isAfter(startDate)) return 0;
    return startDate.difference(now).inDays;
  }
  
  /// Get days left of medication
  int? get daysLeft {
    if (endDate == null) return null;
    
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return 0;
    return endDate!.difference(now).inDays;
  }
  
  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    dosage,
    frequency,
    startDate,
    endDate,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];

  /// Create a copy of this Medication with some modified fields
  Medication copyWith({
    String? id,
    String? userId,
    String? name,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Mark medication as inactive
  Medication markAsInactive() {
    return copyWith(
      isActive: false,
      endDate: endDate ?? DateTime.now(),
    );
  }
} 