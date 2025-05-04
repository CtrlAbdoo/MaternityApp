import 'package:equatable/equatable.dart';

/// Represents a vaccination record
class Vaccination extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime? scheduledDate;
  final DateTime? administeredDate;
  final String? location;
  final String? provider;
  final String? lotNumber;
  final bool isDone;
  final String userId;
  final String? pregnancyId;
  final String? notes;

  const Vaccination({
    required this.id,
    required this.name,
    required this.description,
    this.scheduledDate,
    this.administeredDate,
    this.location,
    this.provider,
    this.lotNumber,
    this.isDone = false,
    required this.userId,
    this.pregnancyId,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    scheduledDate,
    administeredDate,
    location,
    provider,
    lotNumber,
    isDone,
    userId,
    pregnancyId,
    notes,
  ];

  /// Create a copy of this Vaccination with some modified fields
  Vaccination copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? scheduledDate,
    DateTime? administeredDate,
    String? location,
    String? provider,
    String? lotNumber,
    bool? isDone,
    String? userId,
    String? pregnancyId,
    String? notes,
  }) {
    return Vaccination(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      administeredDate: administeredDate ?? this.administeredDate,
      location: location ?? this.location,
      provider: provider ?? this.provider,
      lotNumber: lotNumber ?? this.lotNumber,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      notes: notes ?? this.notes,
    );
  }

  /// Mark vaccination as done
  Vaccination markAsDone({
    required DateTime administeredDate,
    String? location,
    String? provider,
    String? lotNumber,
    String? notes,
  }) {
    return copyWith(
      isDone: true,
      administeredDate: administeredDate,
      location: location ?? this.location,
      provider: provider ?? this.provider,
      lotNumber: lotNumber ?? this.lotNumber,
      notes: notes ?? this.notes,
    );
  }

  /// Checks if vaccination is overdue
  bool get isOverdue {
    if (isDone) return false;
    if (scheduledDate == null) return false;
    
    final now = DateTime.now();
    return scheduledDate!.isBefore(now);
  }

  /// Checks if vaccination is upcoming (within next 30 days)
  bool get isUpcoming {
    if (isDone) return false;
    if (scheduledDate == null) return false;
    
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));
    return scheduledDate!.isAfter(now) && scheduledDate!.isBefore(thirtyDaysFromNow);
  }
} 