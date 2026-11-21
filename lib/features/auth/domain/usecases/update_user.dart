import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}
