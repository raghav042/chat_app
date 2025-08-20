import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String createdAt;
  final bool isOnline;
  final String bio;

  const ProfileEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    this.isOnline = false,
    this.bio = '',
  });

  @override
  List<Object?> get props => [uid, email, name, createdAt, isOnline, bio];
}
