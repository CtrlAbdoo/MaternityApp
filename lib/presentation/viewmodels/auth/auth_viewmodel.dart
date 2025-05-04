import 'package:flutter/material.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/usecases/auth/get_current_user.dart';
import 'package:maternity_app/domain/usecases/auth/sign_in_with_email.dart';
import 'package:maternity_app/domain/usecases/auth/sign_out.dart';
import 'package:maternity_app/domain/usecases/auth/sign_up_with_email.dart';

/// Authentication states
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// View model for authentication
class AuthViewModel extends ChangeNotifier {
  final GetCurrentUser getCurrentUser;
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOut;

  // State
  AuthState _state = AuthState.initial;
  User _user = User.empty;
  String _errorMessage = '';

  // Getters
  AuthState get state => _state;
  User get user => _user;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  AuthViewModel({
    required this.getCurrentUser,
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signOut,
  });

  /// Initialize the view model by checking if the user is already logged in
  Future<void> init() async {
    _state = AuthState.loading;
    notifyListeners();

    final result = await getCurrentUser();
    result.fold(
      (failure) {
        if (failure is AuthFailure) {
          _state = AuthState.unauthenticated;
        } else {
          _state = AuthState.error;
          _errorMessage = failure.message;
        }
      },
      (user) {
        _user = user;
        _state = AuthState.authenticated;
      },
    );

    notifyListeners();
  }

  /// Sign in with email and password
  Future<void> login({required String email, required String password}) async {
    _state = AuthState.loading;
    notifyListeners();

    final result = await signInWithEmail(
      SignInParams(email: email, password: password),
    );
    
    result.fold(
      (failure) {
        _state = AuthState.error;
        _errorMessage = failure.message;
      },
      (user) {
        _user = user;
        _state = AuthState.authenticated;
      },
    );

    notifyListeners();
  }

  /// Sign up with email and password
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _state = AuthState.loading;
    notifyListeners();

    final result = await signUpWithEmail(
      SignUpParams(
        name: name,
        email: email,
        password: password,
      ),
    );
    
    result.fold(
      (failure) {
        _state = AuthState.error;
        _errorMessage = failure.message;
      },
      (user) {
        _user = user;
        _state = AuthState.authenticated;
      },
    );

    notifyListeners();
  }

  /// Sign out
  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();
    
    final result = await signOut();
    result.fold(
      (failure) {
        _state = AuthState.error;
        _errorMessage = failure.message;
      },
      (_) {
        _user = User.empty;
        _state = AuthState.unauthenticated;
      },
    );
    
    notifyListeners();
  }

  /// Reset error state
  void resetError() {
    if (_state == AuthState.error) {
      _state = AuthState.unauthenticated;
      _errorMessage = '';
      notifyListeners();
    }
  }
} 