import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sokna/core/firebase/auth_service.dart';
import 'package:sokna/features/auth/domain/entities/user_entity.dart';
import 'package:sokna/features/auth/domain/usecases/get_current_user_profile.dart';
import 'package:sokna/features/auth/domain/usecases/sign_in_user.dart';
import 'package:sokna/features/auth/domain/usecases/sign_out_user.dart';
import 'package:sokna/features/auth/domain/usecases/update_avatar.dart';
import 'package:sokna/features/auth/domain/usecases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUserUseCase signInUserUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final GetCurrentUserProfileUseCase getCurrentUserProfileUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UpdateAvatarUseCase? updateAvatarUseCase;
  final AuthService authService;

  StreamSubscription<User?>? _userSubscription;

  AuthBloc({
    required this.signInUserUseCase,
    required this.signOutUserUseCase,
    required this.getCurrentUserProfileUseCase,
    required this.updateUserUseCase,
    this.updateAvatarUseCase,
    required this.authService,
  }) : super(AuthInitial()) {
    on<AuthUserChangedEvent>(_onAuthUserChanged);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UpdateUserAvatarEvent>(_onUpdateUserAvatar);

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

  UserEntity _fallbackEntityFromFirebase(User user) {
    return UserEntity(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      profilURL: user.photoURL,
      phone: user.phoneNumber,
      role: 'Locataire',
      createdAt: user.metadata.creationTime,
    );
  }

  Future<void> _onAuthUserChanged(
    AuthUserChangedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final firebaseUser = event.user;
    if (firebaseUser != null) {
      final profileResult = await getCurrentUserProfileUseCase();
      final userEntity = profileResult.fold(
        (_) => _fallbackEntityFromFirebase(firebaseUser),
        (user) => user ?? _fallbackEntityFromFirebase(firebaseUser),
      );
      emit(AuthenticatedState(user: userEntity));
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

    await failureOrUnit.fold(
      (failure) async => emit(AuthErrorState(message: failure.message)),
      (_) async {
        final current = authService.currentUser;
        if (current != null) {
          final profileResult = await getCurrentUserProfileUseCase();
          final userEntity = profileResult.fold(
            (_) => _fallbackEntityFromFirebase(current),
            (user) => user ?? _fallbackEntityFromFirebase(current),
          );
          emit(AuthenticatedState(user: userEntity));
        } else {
          emit(AuthenticatedState(
            user: UserEntity(
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

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    final failureOrUnit = await updateUserUseCase(event.updatedUser);
    failureOrUnit.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(AuthenticatedState(user: event.updatedUser)),
    );
  }

  Future<void> _onUpdateUserAvatar(
    UpdateUserAvatarEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (updateAvatarUseCase != null) {
      final failureOrUser = await updateAvatarUseCase!(event.imageFile);
      failureOrUser.fold(
        (failure) => emit(AuthErrorState(message: failure.message)),
        (updatedUser) => emit(AuthenticatedState(user: updatedUser)),
      );
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
