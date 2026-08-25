// Add this enum at the top of the file
enum UserRole { student, teacher }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
    }
  }

  String get routeName {
    switch (this) {
      case UserRole.student:
        return '/student';
      case UserRole.teacher:
        return '/teacher';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImageUrl;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
    this.lastLogin,
  });

  // Empty user for initial state
  static final empty = UserModel(
    id: '',
    name: '',
    email: '',
    role: UserRole.student,
  );

  // Copy with method for immutability
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? profileImageUrl,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  // Mock users for development
  factory UserModel.mockTeacher() {
    return UserModel(
      id: '1',
      name: 'John Teacher',
      email: 'teacher@school.com',
      role: UserRole.teacher,
      lastLogin: DateTime.now(),
    );
  }

  factory UserModel.mockStudent() {
    return UserModel(
      id: '2',
      name: 'Jane Student',
      email: 'student@school.com',
      role: UserRole.student,
      lastLogin: DateTime.now(),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString(),
      'profileImageUrl': profileImageUrl,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] == 'UserRole.student'
          ? UserRole.student
          : UserRole.teacher,
      profileImageUrl: json['profileImageUrl'] as String?,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email, role: $role)';
}