import 'package:equatable/equatable.dart';

/// User role enum
enum UserRole {
  volunteer,
  organization,
  schoolCoordinator,
}

/// Base user entity
class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        role,
        avatarUrl,
        createdAt,
        lastLoginAt,
        isActive,
      ];

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    UserRole? role,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
