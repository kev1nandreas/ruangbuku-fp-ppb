import 'package:shared_preferences/shared_preferences.dart';
import '../api_client.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.post('/login', {
        'email': email,
        'password': password,
      });
      
      if (response['status'] == true && response['data'] != null) {
        final token = response['data']['token'];
        final userId = response['data']['user']['id'];
        final userName = response['data']['user']['name'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);
        await prefs.setString('user_name', userName);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<void> logout() async {
    try {
      await ApiClient.post('/logout', {});
    } catch (_) {}
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }
  
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
  
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }
}
