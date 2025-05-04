import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/data/models/medication_model.dart';

/// Interface for medication-related remote data operations
abstract class MedicationRemoteDataSource {
  /// Get medications for a user
  Future<List<MedicationModel>> getMedications({required String userId});
  
  /// Add a new medication
  Future<MedicationModel> addMedication({
    required String userId,
    required String name,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  });
  
  /// Update a medication
  Future<MedicationModel> updateMedication({
    required String medicationId,
    required String userId,
    String? name,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isActive,
  });
  
  /// Delete a medication
  Future<void> deleteMedication({
    required String medicationId,
    required String userId,
  });
}

/// Firebase implementation of the MedicationRemoteDataSource
class FirebaseMedicationDataSource implements MedicationRemoteDataSource {
  final FirebaseFirestore firestore;
  
  FirebaseMedicationDataSource({required this.firestore});
  
  @override
  Future<List<MedicationModel>> getMedications({required String userId}) async {
    try {
      final querySnapshot = await firestore
          .collection('medications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs.map((doc) {
        return MedicationModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    } catch (e) {
      throw ServerException(
        message: 'Failed to get medications: ${e.toString()}',
        code: 'get-medications-failed',
      );
    }
  }
  
  @override
  Future<MedicationModel> addMedication({
    required String userId,
    required String name,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    try {
      final medicationData = {
        'userId': userId,
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
        'notes': notes,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      final docRef = await firestore.collection('medications').add(medicationData);
      final newDoc = await docRef.get();
      
      return MedicationModel.fromJson({
        'id': docRef.id,
        ...newDoc.data() ?? {},
      });
    } catch (e) {
      throw ServerException(
        message: 'Failed to add medication: ${e.toString()}',
        code: 'add-medication-failed',
      );
    }
  }
  
  @override
  Future<MedicationModel> updateMedication({
    required String medicationId,
    required String userId,
    String? name,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isActive,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (name != null) updateData['name'] = name;
      if (dosage != null) updateData['dosage'] = dosage;
      if (frequency != null) updateData['frequency'] = frequency;
      if (startDate != null) updateData['startDate'] = Timestamp.fromDate(startDate);
      if (endDate != null) updateData['endDate'] = Timestamp.fromDate(endDate);
      if (notes != null) updateData['notes'] = notes;
      if (isActive != null) updateData['isActive'] = isActive;
      
      if (updateData.isNotEmpty) {
        updateData['updatedAt'] = FieldValue.serverTimestamp();
        
        await firestore
            .collection('medications')
            .doc(medicationId)
            .update(updateData);
      }
      
      final docSnapshot = await firestore
          .collection('medications')
          .doc(medicationId)
          .get();
      
      if (!docSnapshot.exists) {
        throw ServerException(
          message: 'Medication not found',
          code: 'medication-not-found',
        );
      }
      
      return MedicationModel.fromJson({
        'id': medicationId,
        ...docSnapshot.data() ?? {},
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      
      throw ServerException(
        message: 'Failed to update medication: ${e.toString()}',
        code: 'update-medication-failed',
      );
    }
  }
  
  @override
  Future<void> deleteMedication({
    required String medicationId,
    required String userId,
  }) async {
    try {
      // First, get the medication to verify ownership
      final docSnapshot = await firestore
          .collection('medications')
          .doc(medicationId)
          .get();
      
      if (!docSnapshot.exists) {
        throw ServerException(
          message: 'Medication not found',
          code: 'medication-not-found',
        );
      }
      
      final data = docSnapshot.data();
      if (data == null || data['userId'] != userId) {
        throw ServerException(
          message: 'Unauthorized to delete this medication',
          code: 'unauthorized-delete-medication',
        );
      }
      
      await firestore
          .collection('medications')
          .doc(medicationId)
          .delete();
    } catch (e) {
      if (e is ServerException) rethrow;
      
      throw ServerException(
        message: 'Failed to delete medication: ${e.toString()}',
        code: 'delete-medication-failed',
      );
    }
  }
}