import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class RegisterUserUseCase {
  final UserRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await repository.registerUser(user);
  }
}
