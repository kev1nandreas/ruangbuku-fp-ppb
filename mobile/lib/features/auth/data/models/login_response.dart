import 'user_model.dart';

class LoginResponse {
  final bool status;
  final String message;
  final String token;
  final UserModel user;

  const LoginResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return LoginResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      token: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}
