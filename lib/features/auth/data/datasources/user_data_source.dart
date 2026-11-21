import '../../../../core/firebase/auth_service.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<void> registerUser(UserModel user);
  Future<void> signInUser(UserModel user);
  Future<void> signOutUser();
  Future<void> updateUserName(String name);
}

class UserDataSourceImpl implements UserDataSource {
  final AuthService authService;

  UserDataSourceImpl({required this.authService});

  @override
  Future<void> registerUser(UserModel user) async {
    await authService.registerUser(
      email: user.email ?? '',
      password: user.password ?? '',
    );

    if (user.name != null && user.name!.isNotEmpty) {
      await authService.updateUserName(user.name!);
    }
  }

  @override
  Future<void> signInUser(UserModel user) async {
    await authService.signInUser(
      email: user.email ?? '',
      password: user.password ?? '',
    );
  }

  @override
  Future<void> signOutUser() async {
    await authService.signOutUser();
  }

  @override
  Future<void> updateUserName(String name) async {
    await authService.updateUserName(name);
  }
}
