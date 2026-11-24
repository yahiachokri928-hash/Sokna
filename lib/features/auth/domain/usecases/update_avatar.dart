import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateAvatarUseCase {
  final UserRepository repository;

  UpdateAvatarUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(File imageFile) async {
    return await repository.updateAvatar(imageFile);
  }
}
