import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api-ruangbuku.kevin-andreas.com/api/v1';
  
  // This should be set after the user logs in
  static String? bearerToken; 

  /// Fetches public approved books from the backend.
  /// Returns a list of JSON objects or null if it fails (e.g., offline or unauthorized).
  static Future<List<Map<String, dynamic>>?> fetchPublicBooks() async {
    try {
      final headers = {
        'Accept': 'application/json',
      };
      
      if (bearerToken != null && bearerToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      // Query specifically for public and approved books
      final response = await http.get(
        Uri.parse('$baseUrl/buku?is_public=true&status_verifikasi=approved'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      } else {
        print('Error fetching books API: \${response.statusCode} - \${response.body}');
        // Provide hint to user if unauthorized
        if (response.statusCode == 401) {
          print('Unauthorized: Please make sure ApiService.bearerToken is set before calling API.');
        }
      }
    } catch (e) {
      print('Exception fetching books API: $e');
    }
    return null;
  }

  /// Check ISBN and fetch metadata from backend (falls back to Google Books API via backend)
  static Future<Map<String, dynamic>?> checkIsbn(String isbn) async {
    try {
      final headers = {
        'Accept': 'application/json',
      };
      if (bearerToken != null && bearerToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/isbn-check/$isbn'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return Map<String, dynamic>.from(data['data']);
        }
      } else {
        print('Error checking ISBN API: \${response.statusCode} - \${response.body}');
      }
    } catch (e) {
      print('Exception checking ISBN API: $e');
    }
  /// Create a new book on the backend
  static Future<Map<String, dynamic>?> createBook(Map<String, dynamic> payload) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      if (bearerToken != null && bearerToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      final response = await http.post(
        Uri.parse('$baseUrl/buku'),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return Map<String, dynamic>.from(data['data']);
        }
      } else {
        print('Error creating book: \${response.statusCode} - \${response.body}');
      }
    } catch (e) {
      print('Exception creating book: $e');
    }
    return null;
  }

  /// Update an existing book's condition/visibility on the backend
  static Future<Map<String, dynamic>?> updateBook(String id, Map<String, dynamic> payload) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      if (bearerToken != null && bearerToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      final response = await http.put(
        Uri.parse('$baseUrl/buku/$id'),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return Map<String, dynamic>.from(data['data']);
        }
      } else {
        print('Error updating book: \${response.statusCode} - \${response.body}');
      }
    } catch (e) {
      print('Exception updating book: $e');
    }
    return null;
  }

  /// Delete a book from the backend
  static Future<bool> deleteBook(String id) async {
    try {
      final headers = {
        'Accept': 'application/json',
      };
      if (bearerToken != null && bearerToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/buku/$id'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Error deleting book: \${response.statusCode} - \${response.body}');
      }
    } catch (e) {
      print('Exception deleting book: $e');
    }
    return false;
  }
}
