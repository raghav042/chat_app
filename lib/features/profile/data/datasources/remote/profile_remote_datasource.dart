import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/app_exception.dart';
import '../../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<void> createProfile(ProfileModel profile);
  Future<void> updateProfile(ProfileModel profile);
  Future<ProfileModel?> getProfile(String uid);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> createProfile(ProfileModel profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toMap());
    } on FirebaseException catch (e) {
      throw AppException('Failed to create profile: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .update(profile.toMap());
    } on FirebaseException catch (e) {
      throw AppException('Failed to update profile: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<ProfileModel?> getProfile(String uid) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      return snapshot.exists ? ProfileModel.fromMap(snapshot.data()!) : null;
    } on FirebaseException catch (e) {
      throw AppException('Failed to get profile: ${e.message}');
    } catch (e) {
      if (e is AppException) rethrow;
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
