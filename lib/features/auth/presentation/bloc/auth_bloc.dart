import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      emit(Unauthenticated());
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Delegate logout logic to the use case.
      await logoutUseCase.execute();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(AppStrings.somethingWentWrongPleaseTryAgain));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await loginUseCase.execute(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(Authenticated(user: user));
      }
    } on Exception catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.execute(
        email: event.email,
        password: event.password,
      );

      emit(Authenticated(user: user));
    } on Exception catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
