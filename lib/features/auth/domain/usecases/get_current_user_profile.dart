import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserProfileUseCase {
  final UserRepository repository;

  GetCurrentUserProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUserProfile();
  }
}
