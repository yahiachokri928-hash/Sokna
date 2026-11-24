import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures/auth_failures.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/utils/image_encoding_helper.dart';
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
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? SERVER_FAILURE_MESSAGE));
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
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? SERVER_FAILURE_MESSAGE));
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
      final userModel = UserModel.fromEntity(user);
      await remoteDataSource.updateUser(userModel);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? SERVER_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUserProfile() async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure(OFFLINE_FAILURE_MESSAGE));
    }

    try {
      final profile = await remoteDataSource.getCurrentUserProfile();
      return Right(profile);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? SERVER_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateAvatar(File imageFile) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure(OFFLINE_FAILURE_MESSAGE));
    }

    try {
      final currentUser = await remoteDataSource.getCurrentUserProfile();
      if (currentUser == null || currentUser.uid == null || currentUser.uid!.isEmpty) {
        return const Left(AuthUserNotFoundFailure(AUTH_USER_NOT_FOUND_MESSAGE));
      }

      final bytes = await imageFile.readAsBytes();
      final avatarDataUrl = ImageEncodingHelper.bytesToDataUri(bytes);

      final updatedUser = await remoteDataSource.updateUserAvatar(
        currentUser.uid!,
        avatarDataUrl,
      );
      return Right(updatedUser);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? SERVER_FAILURE_MESSAGE));
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
