import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maternity_app/domain/entities/pregnancy.dart';

/// Data model for Pregnancy entity
class PregnancyModel extends Pregnancy {
  const PregnancyModel({
    required super.id,
    required super.userId,
    required super.dueDate,
    required super.startDate,
    required super.babyCount,
    required super.isActive,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  /// Factory constructor to create a PregnancyModel from a JSON map
  factory PregnancyModel.fromJson(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> notesList = [];
    
    if (json['notes'] != null) {
      for (final note in json['notes'] as List<dynamic>) {
        final noteMap = note as Map<String, dynamic>;
        
        // Convert Timestamp to DateTime if needed
        DateTime? createdAt;
        if (noteMap['createdAt'] is Timestamp) {
          createdAt = (noteMap['createdAt'] as Timestamp).toDate();
        } else if (noteMap['createdAt'] is String) {
          createdAt = DateTime.parse(noteMap['createdAt'] as String);
        }
        
        notesList.add({
          'text': noteMap['text'] as String,
          'createdAt': createdAt?.toIso8601String(),
        });
      }
    }
    
    DateTime? dueDate;
    if (json['dueDate'] is Timestamp) {
      dueDate = (json['dueDate'] as Timestamp).toDate();
    } else if (json['dueDate'] is String) {
      dueDate = DateTime.parse(json['dueDate'] as String);
    }
    
    DateTime? startDate;
    if (json['startDate'] is Timestamp) {
      startDate = (json['startDate'] as Timestamp).toDate();
    } else if (json['startDate'] is String) {
      startDate = DateTime.parse(json['startDate'] as String);
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
    
    return PregnancyModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      dueDate: dueDate ?? DateTime.now().add(const Duration(days: 280)),
      startDate: startDate ?? DateTime.now().subtract(const Duration(days: 1)),
      babyCount: json['babyCount'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      notes: notesList,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert PregnancyModel to a JSON map
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> notesList = [];
    
    if (notes != null) {
      for (final note in notes!) {
        notesList.add({
          'text': note['text'],
          'createdAt': note['createdAt'],
        });
      }
    }
    
    return {
      'id': id,
      'userId': userId,
      'dueDate': dueDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
      'babyCount': babyCount,
      'isActive': isActive,
      'notes': notesList,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of this PregnancyModel with some modified fields
  PregnancyModel copyWithModel({
    String? id,
    String? userId,
    DateTime? dueDate,
    DateTime? startDate,
    int? babyCount,
    bool? isActive,
    List<Map<String, dynamic>>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PregnancyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      babyCount: babyCount ?? this.babyCount,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 