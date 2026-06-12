import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/secure_storage.dart';

class BorrowRepository {
  BorrowRepository._();
  static final BorrowRepository instance = BorrowRepository._();

  final _api = ApiClient.instance;
  final _storage = SecureStorage.instance;

  Future<List<Map<String, dynamic>>?> fetchBorrowings({bool asOwner = false}) async {
    try {
      final token = await _storage.getToken();
      final endpoint = asOwner ? '/peminjaman?as=owner' : '/peminjaman';
      final data = await _api.get(endpoint, bearerToken: token);
      if (data['data'] != null && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BorrowRepository: fetchBorrowings failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchBorrowDetail(String id) async {
    try {
      final token = await _storage.getToken();
      final data = await _api.get('/peminjaman/$id', bearerToken: token);
      if (data['data'] != null) {
        return Map<String, dynamic>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BorrowRepository: fetchBorrowDetail failed: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> requestBorrow(
      String bookId, String startDate, String endDate) async {
    try {
      final token = await _storage.getToken();
      final data = await _api.post(
        '/peminjaman',
        {
          'buku_id': bookId,
          'start_date': startDate,
          'end_date': endDate,
        },
        bearerToken: token,
      );
      if (data['data'] != null) {
        return Map<String, dynamic>.from(data['data']);
      }
    } catch (e) {
      debugPrint('BorrowRepository: requestBorrow failed: $e');
      rethrow;
    }
    return null;
  }

  Future<void> approveBorrow(String id) async {
    final token = await _storage.getToken();
    await _api.post('/peminjaman/$id/approve', const {}, bearerToken: token);
  }

  Future<void> rejectBorrow(String id) async {
    final token = await _storage.getToken();
    await _api.post('/peminjaman/$id/reject', const {}, bearerToken: token);
  }

  Future<void> uploadDepositProof(String id, String proofUrl) async {
    final token = await _storage.getToken();
    await _api.post(
      '/peminjaman/$id/deposit',
      {'buktiDeposit': proofUrl},
      bearerToken: token,
    );
  }

  Future<void> confirmHandOver(String id) async {
    final token = await _storage.getToken();
    await _api.post('/peminjaman/$id/hand-over', const {}, bearerToken: token);
  }

  Future<void> confirmReturn(String id) async {
    final token = await _storage.getToken();
    await _api.post('/peminjaman/$id/confirm-return', const {}, bearerToken: token);
  }

  Future<void> reportDamage(
      String id, String description, List<String> photoUrls) async {
    final token = await _storage.getToken();
    await _api.post(
      '/peminjaman/$id/report-damage',
      {'description': description, 'photos': photoUrls},
      bearerToken: token,
    );
  }
}
