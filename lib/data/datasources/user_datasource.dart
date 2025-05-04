import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/data/models/user_model.dart';

/// Abstract class for user data source
abstract class UserDataSource {
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
  
  /// Updates the user profile
  Future<UserModel> updateProfile({
    String? name,
    String? phoneNumber,
    String? photoUrl,
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

/// Implementation of UserDataSource using Firebase
class FirebaseUserDataSource implements UserDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseUserDataSource({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser == null) {
        throw AuthException(message: 'No user logged in');
      }
      
      // Get additional user data from Firestore if needed
      final userDoc = await firestore.collection('users').doc(currentUser.uid).get();
      
      if (userDoc.exists) {
        final userData = userDoc.data();
        return UserModel(
          id: currentUser.uid,
          name: userData?['name'] ?? currentUser.displayName ?? '',
          email: userData?['email'] ?? currentUser.email ?? '',
          phoneNumber: userData?['phoneNumber'] ?? currentUser.phoneNumber,
          photoUrl: userData?['photoUrl'] ?? currentUser.photoURL,
          isEmailVerified: currentUser.emailVerified,
          createdAt: userData?['createdAt'] != null
              ? DateTime.parse(userData?['createdAt'])
              : currentUser.metadata.creationTime,
        );
      } else {
        // If user document doesn't exist in Firestore, return basic data from Firebase Auth
        return UserModel(
          id: currentUser.uid,
          name: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          phoneNumber: currentUser.phoneNumber,
          photoUrl: currentUser.photoURL,
          isEmailVerified: currentUser.emailVerified,
          createdAt: currentUser.metadata.creationTime,
        );
      }
    } catch (e) {
      throw AuthException(message: 'Failed to get current user: $e');
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return await getCurrentUser();
    } catch (e) {
      throw AuthException(message: 'Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
      // Create user document in Firestore
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });
      
      return await getCurrentUser();
    } catch (e) {
      throw AuthException(message: 'Failed to create account: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: 'Failed to sign out: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthException(message: 'Failed to send password reset email: $e');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser == null) {
        throw AuthException(message: 'No user logged in');
      }
      
      // Update display name if provided
      if (name != null) {
        await currentUser.updateDisplayName(name);
      }
      
      // Update user document in Firestore
      final userRef = firestore.collection('users').doc(currentUser.uid);
      final updates = <String, dynamic>{};
      
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      
      if (updates.isNotEmpty) {
        await userRef.update(updates);
      }
      
      return await getCurrentUser();
    } catch (e) {
      throw AuthException(message: 'Failed to update profile: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser == null) {
        throw AuthException(message: 'No user logged in');
      }
      
      // Re-authenticate user first
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );
      
      await currentUser.reauthenticateWithCredential(credential);
      
      // Then change password
      await currentUser.updatePassword(newPassword);
    } catch (e) {
      throw AuthException(message: 'Failed to change password: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser == null) {
        throw AuthException(message: 'No user logged in');
      }
      
      // Re-authenticate user first
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );
      
      await currentUser.reauthenticateWithCredential(credential);
      
      // Delete user document from Firestore
      await firestore.collection('users').doc(currentUser.uid).delete();
      
      // Delete the user account
      await currentUser.delete();
    } catch (e) {
      throw AuthException(message: 'Failed to delete account: $e');
    }
  }
  
  @override
  Future<void> sendEmailVerification() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser == null) {
        throw AuthException(message: 'No user logged in');
      }
      
      await currentUser.sendEmailVerification();
    } catch (e) {
      throw AuthException(message: 'Failed to send email verification: $e');
    }
  }
  
  @override
  Future<bool> isEmailVerified() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser == null) {
        throw AuthException(message: 'No user logged in');
      }
      
      // Reload user to get the most recent data
      await currentUser.reload();
      
      return currentUser.emailVerified;
    } catch (e) {
      throw AuthException(message: 'Failed to check email verification: $e');
    }
  }
} 