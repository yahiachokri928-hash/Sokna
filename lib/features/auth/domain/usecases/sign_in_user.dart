import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class SignInUserUseCase {
  final UserRepository repository;

  SignInUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await repository.signIn(user);
  }
}
