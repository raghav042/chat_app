// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RegisterUserUseCase registerUserUseCase;
  final LoginUserUseCase loginUserUseCase;

  AuthBloc({
    required this.registerUserUseCase,
    required this.loginUserUseCase,
    FirebaseAuth? firebaseAuth,
  }) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    final isLoggedIn = await isUserLoggedIn();

    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isLoggedIn', true);
  }

  Future<void> setUserLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    emit(Unauthenticated()); // so UI knows user is logged out
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final email = event.email.trim();
    final password = event.password.trim();
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(email)) {
      emit(AuthFailure(AppStrings.pleaseEnterAValidEmailAddress));
      return;
    }

    if (password.length < 6) {
      emit(AuthFailure(AppStrings.passwordMustBeAtLeastSixCharactersLong));
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      if (userId == null) {
        emit(AuthFailure("User data not found."));
      }

      emit(Authenticated());
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.userNotFound) {
        emit(AuthFailure(AppStrings.userNotRegistered));
      } else if (e.code == AppStrings.wrongPassword) {
        emit(AuthFailure(AppStrings.incorrectPassword));
      } else {
        emit(AuthFailure(e.message ?? AppStrings.loginFailed));
      }
    } catch (e) {
      emit(AuthFailure(AppStrings.somethingWentWrongPleaseTryAgain));
    }
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final name = event.name.trim();
    final email = event.email.trim();
    final password = event.password.trim();
    final confirmPassword = event.confirmPassword.trim();

    if (name.isEmpty) {
      emit(AuthFailure(AppStrings.nameCannotBeEmpty));
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      emit(AuthFailure(AppStrings.pleaseEnterAValidEmailAddress));
      return;
    }

    if (password.length < 6) {
      emit(AuthFailure(AppStrings.passwordMustBeAtLeastSixCharactersLong));
      return;
    }

    if (password != confirmPassword) {
      emit(AuthFailure(AppStrings.passwordsDoNotMatch));
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        emit(AuthFailure(AppStrings.userCreationFailed));
        return;
      }

      emit(Authenticated(user: user));
    } on FirebaseAuthException catch (e) {
      if (e.code == AppStrings.emailAlreadyInUse) {
        emit(AuthFailure(
            AppStrings.theEmailAddressIsAlreadyInUseByAnotherAccount));
        return;
      }
      emit(AuthFailure('${AppStrings.registrationFailed} ${e.message}'));
      return;
    } catch (e) {
      emit(AuthFailure(AppStrings.somethingWentWrongPleaseTryAgain));
    }
  }
}
