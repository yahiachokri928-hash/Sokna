import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sokna/features/auth/domain/entities/user_entity.dart';
import 'package:sokna/features/auth/domain/usecases/register_user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase registerUserUseCase;

  RegisterBloc({required this.registerUserUseCase}) : super(RegisterInitialState()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterPendingState());

    final failureOrUnit = await registerUserUseCase(event.user);

    failureOrUnit.fold(
      (failure) => emit(RegisterUserFailState(message: failure.message)),
      (_) => emit(RegisterUserSuccessState()),
    );
  }
}
