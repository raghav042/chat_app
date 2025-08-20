import 'package:chat_app/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({required super.uid, required super.email});

  /// Field uid and email are already defined in the parent class AuthUserEntity
  /// so it is redundant to declare them again as fields.
}
