import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/failures/failures.dart';
import 'package:sokna/features/auth/domain/entities/user_entity.dart';
import 'package:sokna/features/auth/domain/repositories/user_repository.dart';
import 'package:sokna/features/auth/domain/usecases/update_avatar.dart';

class MockUserRepository implements UserRepository {
  UserEntity? userToReturn;

  @override
  Future<Either<Failure, UserEntity>> updateAvatar(File imageFile) async {
    if (userToReturn != null) {
      return Right(userToReturn!);
    }
    return const Right(UserEntity(uid: 'uid_test', profilURL: 'data:image/jpeg;base64,...'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('UpdateAvatarUseCase calls repository.updateAvatar and returns updated UserEntity', () async {
    final mockRepo = MockUserRepository();
    const expectedUser = UserEntity(
      uid: 'user_123',
      name: 'Salma',
      email: 'salma@sokna.tn',
      profilURL: 'data:image/jpeg;base64,testdata',
    );
    mockRepo.userToReturn = expectedUser;

    final useCase = UpdateAvatarUseCase(mockRepo);
    final result = await useCase(File('dummy_path.jpg'));

    expect(result, isA<Right>());
    result.fold(
      (_) => fail('Should succeed'),
      (user) {
        expect(user.uid, 'user_123');
        expect(user.profilURL, 'data:image/jpeg;base64,testdata');
      },
    );
  });
}
