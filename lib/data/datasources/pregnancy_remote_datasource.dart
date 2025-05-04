import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/data/models/pregnancy_model.dart';

/// Interface for pregnancy-related remote data operations
abstract class PregnancyRemoteDataSource {
  /// Get current pregnancy information for a user
  Future<PregnancyModel?> getCurrentPregnancy({required String userId});
  
  /// Create a new pregnancy record
  Future<PregnancyModel> createPregnancy({
    required String userId,
    required DateTime dueDate,
    DateTime? startDate,
  });
  
  /// Update pregnancy information
  Future<PregnancyModel> updatePregnancy({
    required String pregnancyId,
    required String userId,
    DateTime? dueDate,
    DateTime? startDate,
    int? babyCount,
  });
  
  /// Add a note to the pregnancy record
  Future<PregnancyModel> addPregnancyNote({
    required String pregnancyId,
    required String userId,
    required String note,
  });
}

/// Firebase implementation of the PregnancyRemoteDataSource
class FirebasePregnancyDataSource implements PregnancyRemoteDataSource {
  final FirebaseFirestore firestore;
  
  FirebasePregnancyDataSource({required this.firestore});
  
  @override
  Future<PregnancyModel?> getCurrentPregnancy({required String userId}) async {
    try {
      final querySnapshot = await firestore
          .collection('pregnancies')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      
      return PregnancyModel.fromJson({
        'id': doc.id,
        ...data,
      });
    } catch (e) {
      throw ServerException(
        message: 'Failed to get current pregnancy: ${e.toString()}',
        code: 'get-pregnancy-failed',
      );
    }
  }
  
  @override
  Future<PregnancyModel> createPregnancy({
    required String userId,
    required DateTime dueDate,
    DateTime? startDate,
  }) async {
    try {
      // Check if there's already an active pregnancy
      final currentPregnancy = await getCurrentPregnancy(userId: userId);
      if (currentPregnancy != null) {
        throw ServerException(
          message: 'User already has an active pregnancy',
          code: 'pregnancy-already-exists',
        );
      }
      
      final pregnancyData = {
        'userId': userId,
        'dueDate': Timestamp.fromDate(dueDate),
        'startDate': startDate != null ? Timestamp.fromDate(startDate) : Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 280 - 40 * 7))
        ),
        'babyCount': 1,
        'isActive': true,
        'notes': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      final docRef = await firestore.collection('pregnancies').add(pregnancyData);
      final newDoc = await docRef.get();
      
      return PregnancyModel.fromJson({
        'id': docRef.id,
        ...newDoc.data() ?? {},
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      
      throw ServerException(
        message: 'Failed to create pregnancy: ${e.toString()}',
        code: 'create-pregnancy-failed',
      );
    }
  }
  
  @override
  Future<PregnancyModel> updatePregnancy({
    required String pregnancyId,
    required String userId,
    DateTime? dueDate,
    DateTime? startDate,
    int? babyCount,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (dueDate != null) updateData['dueDate'] = Timestamp.fromDate(dueDate);
      if (startDate != null) updateData['startDate'] = Timestamp.fromDate(startDate);
      if (babyCount != null) updateData['babyCount'] = babyCount;
      
      if (updateData.isNotEmpty) {
        updateData['updatedAt'] = FieldValue.serverTimestamp();
        
        await firestore
            .collection('pregnancies')
            .doc(pregnancyId)
            .update(updateData);
      }
      
      final docSnapshot = await firestore
          .collection('pregnancies')
          .doc(pregnancyId)
          .get();
      
      if (!docSnapshot.exists) {
        throw ServerException(
          message: 'Pregnancy not found',
          code: 'pregnancy-not-found',
        );
      }
      
      return PregnancyModel.fromJson({
        'id': pregnancyId,
        ...docSnapshot.data() ?? {},
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      
      throw ServerException(
        message: 'Failed to update pregnancy: ${e.toString()}',
        code: 'update-pregnancy-failed',
      );
    }
  }
  
  @override
  Future<PregnancyModel> addPregnancyNote({
    required String pregnancyId,
    required String userId,
    required String note,
  }) async {
    try {
      final noteData = {
        'text': note,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      await firestore
          .collection('pregnancies')
          .doc(pregnancyId)
          .update({
        'notes': FieldValue.arrayUnion([noteData]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final docSnapshot = await firestore
          .collection('pregnancies')
          .doc(pregnancyId)
          .get();
      
      if (!docSnapshot.exists) {
        throw ServerException(
          message: 'Pregnancy not found',
          code: 'pregnancy-not-found',
        );
      }
      
      return PregnancyModel.fromJson({
        'id': pregnancyId,
        ...docSnapshot.data() ?? {},
      });
    } catch (e) {
      throw ServerException(
        message: 'Failed to add pregnancy note: ${e.toString()}',
        code: 'add-pregnancy-note-failed',
      );
    }
  }
} 