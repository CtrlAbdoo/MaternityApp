import 'package:equatable/equatable.dart';

/// Represents a user in the system
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final DateTime? createdAt;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.createdAt,
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        photoUrl,
        createdAt,
        isEmailVerified,
      ];

  /// Create a copy of this User with some modified fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  /// Empty user instance
  static const empty = User(
    id: '',
    name: '',
    email: '',
    isEmailVerified: false,
  );

  /// Checks if the current user instance is empty
  bool get isEmpty => this == User.empty;

  /// Checks if the current user instance is not empty
  bool get isNotEmpty => this != User.empty;
} 