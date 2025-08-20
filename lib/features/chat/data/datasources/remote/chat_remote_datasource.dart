import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/app_exception.dart';
import '../../../../profile/data/models/profile_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ProfileModel>> getAllUsers(String userId);
  Future<List<Map<String, dynamic>>> getAllChatData(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<ProfileModel>> getAllUsers(String userId) async {
    try {
      final querySnapshot = await _firestore.collection('users').get();

      return querySnapshot.docs
          .map((doc) => ProfileModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw AppException('Failed to get all users: ${e.message}');
    } catch (e) {
      throw AppException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllChatData(String userId) async {
    try {
      final snapshots = await _firestore
          .collection('chats')
          .where("chatId", arrayContains: userId)
          .get();

      return snapshots.docs.map((e) => e.data()).toList();
    } on FirebaseException catch (e) {
      throw AppException('Failed to get chat users: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
