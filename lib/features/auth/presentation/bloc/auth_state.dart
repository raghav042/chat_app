import 'package:chat_app/features/profile/domain/entities/profile_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class Authenticated extends AuthState {
  final ProfileEntity user;
  Authenticated({required this.user});
}

class Unauthenticated extends AuthState {}
