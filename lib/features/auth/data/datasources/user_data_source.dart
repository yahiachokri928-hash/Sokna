import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/auth_service.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<void> registerUser(UserModel user);
  Future<void> signInUser(UserModel user);
  Future<void> signOutUser();
  Future<void> updateUserName(String name);
  Future<UserModel?> getCurrentUserProfile();
  Future<void> updateUser(UserModel user);
}

class UserDataSourceImpl implements UserDataSource {
  final AuthService authService;
  final FirestoreService firestoreService;

  UserDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  @override
  Future<void> registerUser(UserModel user) async {
    final credential = await authService.registerUser(
      email: user.email ?? '',
      password: user.password ?? '',
    );

    final uid = credential.user?.uid ?? user.uid ?? '';

    if (user.name != null && user.name!.isNotEmpty) {
      await authService.updateUserName(user.name!);
    }

    if (uid.isNotEmpty) {
      await firestoreService.usersCollection.doc(uid).set({
        'uid': uid,
        'name': user.name ?? '',
        'email': user.email ?? '',
        'profilURL': user.profilURL,
        'phone': user.phone,
        'role': user.role,
        'createdAt': FieldValue.serverTimestamp(),
        'savedListingIds': <String>[],
      });
    }
  }

  @override
  Future<void> signInUser(UserModel user) async {
    final credential = await authService.signInUser(
      email: user.email ?? '',
      password: user.password ?? '',
    );

    final firebaseUser = credential.user ?? authService.currentUser;
    if (firebaseUser != null) {
      final docRef = firestoreService.usersCollection.doc(firebaseUser.uid);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        await docRef.set({
          'uid': firebaseUser.uid,
          'name': firebaseUser.displayName ?? user.name ?? '',
          'email': firebaseUser.email ?? user.email ?? '',
          'profilURL': firebaseUser.photoURL ?? user.profilURL,
          'phone': firebaseUser.phoneNumber ?? user.phone,
          'role': user.role,
          'createdAt': FieldValue.serverTimestamp(),
          'savedListingIds': <String>[],
        });
      }
    }
  }

  @override
  Future<UserModel?> getCurrentUserProfile() async {
    final currentUser = authService.currentUser;
    if (currentUser == null) return null;

    final doc =
        await firestoreService.usersCollection.doc(currentUser.uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromFirestore(doc);
    }

    return UserModel.fromFirebaseAuth(currentUser);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final currentUser = authService.currentUser;
    final uid = user.uid ?? currentUser?.uid;

    if (user.name != null && user.name!.isNotEmpty) {
      await authService.updateUserName(user.name!);
    }

    if (uid != null && uid.isNotEmpty) {
      final Map<String, dynamic> updateData = {
        'role': user.role,
      };
      if (user.name != null) updateData['name'] = user.name;
      if (user.phone != null) updateData['phone'] = user.phone;
      if (user.profilURL != null) updateData['profilURL'] = user.profilURL;

      await firestoreService.usersCollection.doc(uid).set(
        updateData,
        SetOptions(merge: true),
      );
    }
  }

  @override
  Future<void> signOutUser() async {
    await authService.signOutUser();
  }

  @override
  Future<void> updateUserName(String name) async {
    await authService.updateUserName(name);
    final currentUser = authService.currentUser;
    if (currentUser != null) {
      await firestoreService.usersCollection.doc(currentUser.uid).set(
        {'name': name},
        SetOptions(merge: true),
      );
    }
  }
}
