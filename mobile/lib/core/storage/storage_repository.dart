import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import '../api/api_client.dart';
import 'secure_storage.dart';

/// Handles direct-to-MinIO uploads via the backend presigned-URL endpoint.
///
/// Flow: ask the backend for a presigned PUT URL, upload the file bytes to
/// MinIO with that URL, then hand the returned public `url` back to the caller
/// to persist on the related record (e.g. a borrow's deposit proof).
class StorageRepository {
  StorageRepository._();
  static final StorageRepository instance = StorageRepository._();

  final _api = ApiClient.instance;
  final _storage = SecureStorage.instance;

  /// Picks a sensible image content type from a file extension.
  String _contentTypeFor(String filename) {
    switch (p.extension(filename).toLowerCase()) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      case '.jpg':
      case '.jpeg':
      default:
        return 'image/jpeg';
    }
  }

  /// Uploads [file] to MinIO under [folder] and returns the public URL of the
  /// stored object, or throws on failure.
  Future<String> uploadFile(File file, {String folder = 'uploads'}) async {
    final token = await _storage.getToken();
    final filename = p.basename(file.path);
    final contentType = _contentTypeFor(filename);

    // 1) Ask backend for a presigned PUT URL.
    final res = await _api.post(
      '/storage/presigned-url',
      {
        'filename': filename,
        'content_type': contentType,
        'folder': folder,
      },
      bearerToken: token,
    );

    final data = res['data'] as Map<String, dynamic>?;
    final uploadUrl = data?['upload_url'] as String?;
    final publicUrl = data?['url'] as String?;
    if (uploadUrl == null || publicUrl == null) {
      throw const ApiException('Gagal mendapatkan URL unggah.');
    }

    // 2) PUT the raw bytes straight to MinIO.
    final bytes = await file.readAsBytes();
    final putRes = await http
        .put(
          Uri.parse(uploadUrl),
          headers: {'Content-Type': contentType},
          body: bytes,
        )
        .timeout(const Duration(seconds: 60));

    if (putRes.statusCode < 200 || putRes.statusCode >= 300) {
      debugPrint('StorageRepository: upload failed ${putRes.statusCode} ${putRes.body}');
      throw ApiException('Unggah berkas gagal (${putRes.statusCode}).');
    }

    // 3) Return the public URL to persist on the record.
    return publicUrl;
  }
}
