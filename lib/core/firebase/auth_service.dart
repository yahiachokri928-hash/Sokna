import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth? _injectedAuth;

  AuthService({FirebaseAuth? firebaseAuth}) : _injectedAuth = firebaseAuth;

  FirebaseAuth get _auth {
    return _injectedAuth ?? FirebaseAuth.instance;
  }

  Stream<User?> get userStream {
    try {
      return _auth.authStateChanges();
    } catch (_) {
      // Offline / uninitialized fallback stream
      return const Stream<User?>.empty();
    }
  }

  Stream<User?> get authStateChanges => userStream;

  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<UserCredential> registerUser({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInUser({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
    } catch (_) {}
  }

  Future<void> updateUserName(String name) async {
    try {
      await currentUser?.updateDisplayName(name);
    } catch (_) {}
  }

  // Backwards compatibility methods
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      signInUser(email: email, password: password);

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      registerUser(email: email, password: password);

  Future<void> signOut() => signOutUser();
}

typedef FirebaseAuthService = AuthService;
