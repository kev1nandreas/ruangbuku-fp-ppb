import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final _client = http.Client();

  Map<String, String> _headers(String? bearerToken) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${bearerToken ?? ApiConstants.appToken}',
      };

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? bearerToken,
  }) {
    return _send(
      () => _client
          .post(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: _headers(bearerToken),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30)),
    );
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    String? bearerToken,
  }) {
    return _send(
      () => _client
          .get(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: _headers(bearerToken),
          )
          .timeout(const Duration(seconds: 30)),
    );
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? bearerToken,
  }) {
    return _send(
      () => _client
          .put(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: _headers(bearerToken),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30)),
    );
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? bearerToken,
  }) {
    return _send(
      () => _client
          .delete(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: _headers(bearerToken),
          )
          .timeout(const Duration(seconds: 30)),
    );
  }

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};
      throw ApiException(
        data['message'] as String? ?? 'Request failed',
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet.');
    } on FormatException {
      throw const ApiException('Respons server tidak valid.');
    } catch (e) {
      throw const ApiException('Terjadi kesalahan. Silakan coba lagi.');
    }
  }
}
