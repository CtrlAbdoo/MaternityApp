import 'package:flutter/material.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/usecases/user/get_user_profile.dart';
import 'package:maternity_app/domain/usecases/user/update_user_profile.dart';

/// View model for user profile
class UserViewModel extends ChangeNotifier {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  
  // State
  bool _isLoading = false;
  User? _user;
  String _errorMessage = '';
  
  // Getters
  bool get isLoading => _isLoading;
  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  
  UserViewModel({
    required this.getUserProfile,
    required this.updateUserProfile,
  });
  
  /// Load user profile
  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    final result = await getUserProfile(UserParams(userId: userId));
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (user) {
        _user = user;
      },
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Update user profile
  Future<bool> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    final result = await updateUserProfile(
      UpdateUserParams(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
      ),
    );
    
    bool success = false;
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (updatedUser) {
        _user = updatedUser;
        success = true;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return success;
  }
  
  /// Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
} 