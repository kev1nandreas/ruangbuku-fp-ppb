import 'role_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? roleId;
  final List<RoleModel> roles;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.roleId,
    this.roles = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawRoles = json['roles'] as List<dynamic>?;
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      roleId: json['role_id'] as String?,
      roles: rawRoles
              ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// Primary role name (e.g. "admin"), or null if the user has no role.
  String? get primaryRoleName => roles.isNotEmpty ? roles.first.name : null;
}
