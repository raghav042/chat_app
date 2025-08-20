// lib/features/auth/presentation/bloc/auth_event.dart

abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class RegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterSubmitted(
      {required this.name,
      required this.confirmPassword,
      required this.email,
      required this.password});
}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
