import '../api_client.dart';

class BorrowService {
  static Future<List<dynamic>> getBorrowings({bool asOwner = false}) async {
    final endpoint = asOwner ? '/peminjaman?as=owner' : '/peminjaman';
    final response = await ApiClient.get(endpoint);
    return response['data'] ?? [];
  }

  static Future<dynamic> requestBorrow(String bookId, String startDate, String endDate) async {
    final response = await ApiClient.post('/peminjaman', {
      'buku_id': bookId,
      'start_date': startDate,
      'end_date': endDate,
    });
    return response['data'];
  }

  static Future<dynamic> getBorrowDetail(String id) async {
    final response = await ApiClient.get('/peminjaman/$id');
    return response['data'];
  }
  
  static Future<void> approveBorrow(String id) async {
    await ApiClient.post('/peminjaman/$id/approve', {});
  }
  
  static Future<void> rejectBorrow(String id) async {
    await ApiClient.post('/peminjaman/$id/reject', {});
  }

  static Future<void> uploadDepositProof(String id, String proofUrl) async {
    // In real app, upload file to S3 first, then send URL to backend.
    await ApiClient.post('/peminjaman/$id/deposit', {
       'buktiDeposit': proofUrl
    });
  }
  
  static Future<void> confirmHandOver(String id) async {
    await ApiClient.post('/peminjaman/$id/hand-over', {});
  }
  
  static Future<void> confirmReturn(String id) async {
    await ApiClient.post('/peminjaman/$id/confirm-return', {});
  }
  
  static Future<void> reportDamage(String id, String description, List<String> photoUrls) async {
    await ApiClient.post('/peminjaman/$id/report-damage', {
      'description': description,
      'photos': photoUrls,
    });
  }
}
