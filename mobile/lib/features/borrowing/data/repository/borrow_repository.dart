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

  Future<void> requestReturn(String id) async {
    final token = await _storage.getToken();
    await _api.post('/peminjaman/$id/request-return', const {}, bearerToken: token);
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
      {'damage_description': description, 'damage_photos': photoUrls},
      bearerToken: token,
    );
  }

  // --- admin actions ---------------------------------------------------

  /// Admin confirms the borrower's submitted deposit proof.
  Future<void> confirmDeposit(String id) async {
    final token = await _storage.getToken();
    await _api.post('/peminjaman/$id/confirm-deposit', const {}, bearerToken: token);
  }

  /// Admin rejects the borrower's submitted deposit proof.
  Future<void> rejectDeposit(String id) async {
    final token = await _storage.getToken();
    await _api.post('/peminjaman/$id/reject-deposit', const {}, bearerToken: token);
  }

  /// Admin returns the deposit to the borrower for a cleanly-returned book.
  Future<void> returnDeposit(String id,
      {String? proofUrl, String? note}) async {
    final token = await _storage.getToken();
    await _api.post(
      '/peminjaman/$id/return-deposit',
      {
        if (proofUrl != null && proofUrl.isNotEmpty) 'deposit_proof_url': proofUrl,
        if (note != null && note.isNotEmpty) 'resolution_note': note,
      },
      bearerToken: token,
    );
  }

  /// Admin settles a damage dispute, sending the deposit to [resolution]
  /// ('borrower' or 'owner').
  Future<void> resolveDamage(
    String id, {
    required String resolution,
    required String note,
    String? proofUrl,
  }) async {
    final token = await _storage.getToken();
    await _api.post(
      '/peminjaman/$id/resolve-damage',
      {
        'resolution': resolution,
        'resolution_note': note,
        if (proofUrl != null && proofUrl.isNotEmpty) 'deposit_proof_url': proofUrl,
      },
      bearerToken: token,
    );
  }
}
