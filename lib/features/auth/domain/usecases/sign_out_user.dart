import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/user_repository.dart';

class SignOutUserUseCase {
  final UserRepository repository;

  SignOutUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.signOut();
  }
}
