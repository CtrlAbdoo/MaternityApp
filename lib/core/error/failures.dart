import 'package:equatable/equatable.dart';

/// Base failure class for domain layer
abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message = 'An unexpected error occurred'});
  
  @override
  List<Object?> get props => [message];
}

/// Server failures (API, Firebase, etc.)
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred'});
}

/// Cache failures (local storage)
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

/// Network failures (internet connectivity)
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network connection failed'});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed'});
}

/// Input validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation error'});
}

/// Access permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission denied'});
} 