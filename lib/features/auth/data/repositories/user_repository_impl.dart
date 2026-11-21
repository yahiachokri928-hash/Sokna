import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures/auth_failures.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> registerUser(UserEntity user) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure(OFFLINE_FAILURE_MESSAGE));
    }

    try {
      final userModel = UserModel.fromEntity(user);
      await remoteDataSource.registerUser(userModel);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, Unit>> signIn(UserEntity user) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure(OFFLINE_FAILURE_MESSAGE));
    }

    try {
      final userModel = UserModel.fromEntity(user);
      await remoteDataSource.signInUser(userModel);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOutUser();
      return const Right(unit);
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUser(UserEntity user) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure(OFFLINE_FAILURE_MESSAGE));
    }

    try {
      if (user.name != null) {
        await remoteDataSource.updateUserName(user.name!);
      }
      return const Right(unit);
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  Failure _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return const RegisterUserWeakPwdFailure();
      case 'email-already-in-use':
        return const RegisterUserUsedEmailFailure();
      case 'user-not-found':
      case 'invalid-credential':
        return const SignInUserNotFoundFailure();
      case 'wrong-password':
        return const SignInWrongPwdFailure();
      case 'invalid-email':
        return const AuthInvalidEmailFailure();
      case 'network-request-failed':
        return const AuthNetworkRequestFailedFailure();
      default:
        return AuthUnknownFailure(e.message ?? UNEXPECTED_FAILURE_MESSAGE);
    }
  }
}
