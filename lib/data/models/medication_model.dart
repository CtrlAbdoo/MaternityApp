import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maternity_app/domain/entities/medication.dart';

/// Data model for Medication entity
class MedicationModel extends Medication {
  const MedicationModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.dosage,
    required super.frequency,
    required super.startDate,
    super.endDate,
    super.notes,
    super.isActive = true,
    super.createdAt,
    super.updatedAt,
  });

  /// Factory constructor to create a MedicationModel from a JSON map
  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    DateTime? startDate;
    if (json['startDate'] is Timestamp) {
      startDate = (json['startDate'] as Timestamp).toDate();
    } else if (json['startDate'] is String) {
      startDate = DateTime.parse(json['startDate'] as String);
    }
    
    DateTime? endDate;
    if (json['endDate'] != null) {
      if (json['endDate'] is Timestamp) {
        endDate = (json['endDate'] as Timestamp).toDate();
      } else if (json['endDate'] is String) {
        endDate = DateTime.parse(json['endDate'] as String);
      }
    }
    
    DateTime? createdAt;
    if (json['createdAt'] is Timestamp) {
      createdAt = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      createdAt = DateTime.parse(json['createdAt'] as String);
    }
    
    DateTime? updatedAt;
    if (json['updatedAt'] is Timestamp) {
      updatedAt = (json['updatedAt'] as Timestamp).toDate();
    } else if (json['updatedAt'] is String) {
      updatedAt = DateTime.parse(json['updatedAt'] as String);
    }
    
    return MedicationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert MedicationModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of this MedicationModel with some modified fields
  MedicationModel copyWithModel({
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
    return MedicationModel(
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
} 