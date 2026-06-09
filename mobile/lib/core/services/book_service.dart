import '../api_client.dart';

class BookService {
  static Future<List<dynamic>> getBooks({String? userId, String? statusVerifikasi, bool? isPublic}) async {
    String query = '';
    final params = <String>[];
    
    if (userId != null) params.add('user_id=$userId');
    if (statusVerifikasi != null) params.add('status_verifikasi=$statusVerifikasi');
    if (isPublic != null) params.add('is_public=$isPublic');
    
    if (params.isNotEmpty) {
      query = '?${params.join('&')}';
    }
    
    final response = await ApiClient.get('/buku$query');
    return response['data'] ?? [];
  }

  static Future<dynamic> checkIsbn(String isbn) async {
    final response = await ApiClient.get('/isbn-check/$isbn');
    return response['data'];
  }

  static Future<dynamic> addBook(Map<String, dynamic> data) async {
    final response = await ApiClient.post('/buku', data);
    return response['data'];
  }

  static Future<dynamic> getBookDetail(String id) async {
    final response = await ApiClient.get('/buku/$id');
    return response['data'];
  }
}
