import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';  // Add this import for UserRole

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final UserRole role;  // Now this will be recognized

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, password, role];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUpdateUser extends AuthEvent {
  final UserModel user;

  const AuthUpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}