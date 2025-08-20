import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/app_exception.dart';
import '../models/auth_user_model.dart';

abstract class AuthDataSource {
  Future<AuthUserModel> register({
    required String email,
    required String password,
  });

  Future<AuthUserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

abstract class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({required this.auth, required this.firestore});
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  @override
  Future<AuthUserModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return AuthUserModel(uid: userCredential.user!.uid, email: email);
      } else {
        throw const AppException('Registration failed.');
      }
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return AuthUserModel(uid: userCredential.user!.uid, email: email);
      } else {
        throw const AppException('Login failed.');
      }
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'An unknown error occurred');
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
