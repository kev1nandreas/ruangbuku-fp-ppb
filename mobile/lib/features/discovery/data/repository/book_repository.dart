import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/secure_storage.dart';

class BookRepository {
  BookRepository._();
  static final BookRepository instance = BookRepository._();

  final _api = ApiClient.instance;
  final _storage = SecureStorage.instance;

  Future<List<Map<String, dynamic>>?> fetchPublicBooks() async {
    try {
      final token = await _storage.getToken();
      final data = await _api.get(
        '/buku?is_public=true&status_verifikasi=approved',
        bearerToken: token,
      );
      if (data['data'] != null && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BookRepository: fetchPublicBooks failed: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> fetchBooks({
    String? userId,
    String? statusVerifikasi,
    bool? isPublic,
  }) async {
    try {
      final token = await _storage.getToken();
      final params = <String>[];
      if (userId != null) params.add('user_id=$userId');
      if (statusVerifikasi != null) params.add('status_verifikasi=$statusVerifikasi');
      if (isPublic != null) params.add('is_public=$isPublic');
      final query = params.isNotEmpty ? '?${params.join('&')}' : '';
      final data = await _api.get('/buku$query', bearerToken: token);
      if (data['data'] != null && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BookRepository: fetchBooks failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchBookDetail(String id) async {
    try {
      final token = await _storage.getToken();
      final data = await _api.get('/buku/$id', bearerToken: token);
      if (data['data'] != null) {
        return Map<String, dynamic>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BookRepository: fetchBookDetail failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> checkIsbn(String isbn) async {
    try {
      final token = await _storage.getToken();
      final data = await _api.get('/isbn-check/$isbn', bearerToken: token);
      if (data['data'] != null) {
        return Map<String, dynamic>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BookRepository: checkIsbn failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> createBook(Map<String, dynamic> payload) async {
    try {
      final token = await _storage.getToken();
      final data = await _api.post('/buku', payload, bearerToken: token);
      if (data['data'] != null) {
        return Map<String, dynamic>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BookRepository: createBook failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateBook(String id, Map<String, dynamic> payload) async {
    try {
      final token = await _storage.getToken();
      final data = await _api.put('/buku/$id', payload, bearerToken: token);
      if (data['data'] != null) {
        return Map<String, dynamic>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BookRepository: updateBook failed: $e');
    }
    return null;
  }

  Future<bool> deleteBook(String id) async {
    try {
      final token = await _storage.getToken();
      await _api.delete('/buku/$id', bearerToken: token);
      return true;
    } catch (e) {
      debugPrint('BookRepository: deleteBook failed: $e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>?> fetchGenres() async {
    try {
      final token = await _storage.getToken();
      final data = await _api.get('/genres', bearerToken: token);
      if (data['data'] != null && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BookRepository: fetchGenres failed: $e');
    }
    return null;
  }
}
