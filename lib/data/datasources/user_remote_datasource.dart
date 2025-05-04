import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/data/datasources/user_datasource.dart';
import 'package:maternity_app/data/models/user_model.dart';

/// UserRemoteDataSource interface for user operations
abstract class UserRemoteDataSource {
  /// Get user profile data
  Future<UserModel> getUserProfile({required String userId});
  
  /// Update user profile
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  });
  
  /// Delete user profile
  Future<void> deleteUserProfile({required String userId});

  /// Gets the current authenticated user
  Future<UserModel> getCurrentUser();
  
  /// Signs in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  /// Creates a new account with email and password
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  
  /// Signs out the current user
  Future<void> signOut();
  
  /// Sends a password reset email
  Future<void> sendPasswordResetEmail({
    required String email,
  });
  
  /// Changes the user's password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// Checks if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Deletes the user account
  Future<void> deleteAccount({
    required String password,
  });
  
  /// Verifies the user's email
  Future<void> sendEmailVerification();
  
  /// Checks if email is verified
  Future<bool> isEmailVerified();
}

/// Firebase implementation of UserRemoteDataSource
class FirebaseUserDataSource implements UserRemoteDataSource {
  final UserDataSource userDataSource;
  final FirebaseFirestore firestore;
  
  FirebaseUserDataSource({
    required this.userDataSource,
    required this.firestore,
  });
  
  @override
  Future<UserModel> getUserProfile({required String userId}) async {
    try {
      final documentSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .get();
      
      if (!documentSnapshot.exists) {
        throw ServerException(message: 'User profile not found');
      }
      
      final data = documentSnapshot.data();
      if (data == null) {
        throw ServerException(message: 'User data is null');
      }
      
      return UserModel.fromJson({
        'id': userId,
        ...data,
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      
      throw ServerException(
        message: 'Failed to get user profile: ${e.toString()}',
        code: 'get-user-profile-failed',
      );
    }
  }
  
  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (updateData.isNotEmpty) {
        updateData['updatedAt'] = FieldValue.serverTimestamp();
      }
      
      if (updateData.isNotEmpty) {
        await firestore
            .collection('users')
            .doc(userId)
            .update(updateData);
      }
      
      return await getUserProfile(userId: userId);
    } catch (e) {
      throw ServerException(
        message: 'Failed to update user profile: ${e.toString()}',
        code: 'update-user-profile-failed',
      );
    }
  }
  
  @override
  Future<void> deleteUserProfile({required String userId}) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .delete();
    } catch (e) {
      throw ServerException(
        message: 'Failed to delete user profile: ${e.toString()}',
        code: 'delete-user-profile-failed',
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() {
    return userDataSource.getCurrentUser();
  }
  
  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return userDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  @override
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return userDataSource.createUserWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }
  
  @override
  Future<void> signOut() {
    return userDataSource.signOut();
  }
  
  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return userDataSource.sendPasswordResetEmail(email: email);
  }
  
  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return userDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
  
  @override
  Future<bool> isAuthenticated() {
    return userDataSource.isAuthenticated();
  }
  
  @override
  Future<void> deleteAccount({required String password}) {
    return userDataSource.deleteAccount(password: password);
  }
  
  @override
  Future<void> sendEmailVerification() {
    return userDataSource.sendEmailVerification();
  }
  
  @override
  Future<bool> isEmailVerified() {
    return userDataSource.isEmailVerified();
  }
} 