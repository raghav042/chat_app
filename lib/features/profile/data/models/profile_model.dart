import 'package:hive_ce/hive.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String createdAt;

  @HiveField(4)
  final bool isOnline;

  @HiveField(5)
  final String bio;

  ProfileModel({
    required this.uid,
    required this.email,
    this.name = "",
    this.createdAt = "",
    this.isOnline = false,
    this.bio = "",
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      createdAt: map['createdAt'],
      isOnline: map['isOnline'],
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'bio': bio,
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      uid: uid,
      email: email,
      name: name,
      createdAt: createdAt,
      isOnline: isOnline,
      bio: bio,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      createdAt: entity.createdAt,
      isOnline: entity.isOnline,
      bio: entity.bio,
    );
  }
}
