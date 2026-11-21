import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sokna/core/firebase/auth_service.dart';
import 'package:sokna/features/auth/domain/entities/user_entity.dart';
import 'package:sokna/features/auth/domain/usecases/sign_in_user.dart';
import 'package:sokna/features/auth/domain/usecases/sign_out_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUserUseCase signInUserUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final AuthService authService;

  StreamSubscription<User?>? _userSubscription;

  AuthBloc({
    required this.signInUserUseCase,
    required this.signOutUserUseCase,
    required this.authService,
  }) : super(AuthInitial()) {
    on<AuthUserChangedEvent>(_onAuthUserChanged);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);

    _initUserStream();
  }

  void _initUserStream() {
    try {
      _userSubscription = authService.userStream.listen(
        (user) {
          add(AuthUserChangedEvent(user));
        },
        onError: (_) {
          add(const AuthUserChangedEvent(null));
        },
      );
    } catch (_) {
      // Offline fallback: unauthenticated by default
      add(const AuthUserChangedEvent(null));
    }
  }

  void _onAuthUserChanged(
    AuthUserChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      final userEntity = UserEntity(
        uid: event.user!.uid,
        name: event.user!.displayName ?? '',
        email: event.user!.email ?? '',
        profilURL: event.user!.photoURL,
      );
      emit(AuthenticatedState(userEntity));
    } else {
      emit(UnAuthenticatedState());
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginPendingState());

    final failureOrUnit = await signInUserUseCase(
      UserEntity(
        email: event.email,
        password: event.password,
      ),
    );

    failureOrUnit.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) {
        final current = authService.currentUser;
        if (current != null) {
          emit(AuthenticatedState(
            UserEntity(
              uid: current.uid,
              name: current.displayName ?? '',
              email: current.email ?? '',
              profilURL: current.photoURL,
            ),
          ));
        } else {
          emit(AuthenticatedState(
            UserEntity(
              email: event.email,
            ),
          ));
        }
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutPendingState());
    await signOutUserUseCase();
    emit(UnAuthenticatedState());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
