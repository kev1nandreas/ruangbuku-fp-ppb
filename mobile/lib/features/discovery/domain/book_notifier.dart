import 'package:flutter/foundation.dart';
import '../data/models/book_model.dart';
import '../data/models/genre_model.dart';
import '../data/repository/book_repository.dart';
import '../../../db/local_bookDB.dart';

class BookNotifier extends ChangeNotifier {
  BookNotifier._();
  static final BookNotifier instance = BookNotifier._();

  final _repository = BookRepository.instance;
  final _local = LocalBookDB.instance;

  final List<BookModel> _books = [];
  bool isLoading = false;

  List<BookModel> get books => _books;

  Future<void> loadPublicBooks() async {
    isLoading = true;
    notifyListeners();

    final apiBooks = await _repository.fetchPublicBooks();

    if (apiBooks != null) {
      await _local.clearBooks();
      _books.clear();

      for (final b in apiBooks) {
        final owner = (b['users'] != null && (b['users'] as List).isNotEmpty)
            ? b['users'][0] as Map<String, dynamic>
            : null;

        final bookMap = {
          'id': b['id']?.toString() ?? '',
          'isbn': b['isbn']?.toString(),
          'title': b['title']?.toString() ?? 'No Title',
          'author': b['author']?.toString(),
          'description': b['description']?.toString(),
          'isPublic': 1,
          'statusVerifikasi': b['statusVerifikasi']?.toString(),
          'ownerId': owner?['id']?.toString(),
          'ownerName': owner?['name']?.toString() ?? 'Unknown',
          'imageUrl': b['coverImageUrl']?.toString() ??
              'https://picsum.photos/seed/${b['id']}/200/300',
          'distance': '1.0 km away',
          'condition': 'Good',
        };

        await _local.insertBook(bookMap);
        _addFromMap(bookMap);
      }
    } else {
      debugPrint('BookNotifier: API failed, loading from local DB');
      final localBooks = await _local.getAllBooks();
      _books.clear();
      for (final b in localBooks) {
        _addFromMap(b);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void _addFromMap(Map<String, dynamic> b) {
    BookStatus status = BookStatus.private;
    if (b['statusVerifikasi'] == 'approved') {
      status = BookStatus.publicApproved;
    } else if (b['statusVerifikasi'] == 'need_verification') {
      status = BookStatus.publicPending;
    } else if (b['statusVerifikasi'] == 'rejected') {
      status = BookStatus.publicRejected;
    }

    _books.add(BookModel(
      id: b['id']?.toString() ?? '',
      isbn: b['isbn']?.toString() ?? '',
      title: b['title']?.toString() ?? 'No Title',
      author: b['author']?.toString() ?? 'Unknown',
      description: b['description']?.toString() ?? '',
      isPublic: b['isPublic'] == 1 || b['isPublic'] == true,
      statusVerifikasi: status,
      ownerId: b['ownerId']?.toString() ?? 'user_0',
      ownerName: b['ownerName']?.toString() ?? 'Unknown',
      imageUrl: b['imageUrl']?.toString() ?? 'https://picsum.photos/200/300',
      distance: b['distance']?.toString() ?? '1.0 km away',
      condition: b['condition']?.toString() ?? 'Good',
    ));
  }

  /// Fetches books filtered by role and maps them into [BookModel]s.
  /// Admins see pending public books; others see all accessible books.
  Future<List<BookModel>> fetchBooks({required bool isAdmin}) async {
    final data = isAdmin
        ? await _repository.fetchBooks(
            statusVerifikasi: 'need_verification')
        : await _repository.fetchBooks();
    if (data == null) throw Exception('API fetch failed, fallback to local DB');
    return data.map((e) => BookModel.fromJson(e)).toList();
  }

  Future<BookModel?> fetchBookDetail(String id) async {
    final data = await _repository.fetchBookDetail(id);
    if (data == null) return null;
    return BookModel.fromJson(data);
  }

  Future<Map<String, dynamic>?> createBook(Map<String, dynamic> payload) =>
      _repository.createBook(payload);

  Future<bool> deleteBook(String id) => _repository.deleteBook(id);

  Future<Map<String, dynamic>?> verifyBook(String id) => _repository.verifyBook(id);

  Future<Map<String, dynamic>?> updateBook(
          String id, Map<String, dynamic> payload) =>
      _repository.updateBook(id, payload);

  Future<Map<String, dynamic>?> checkIsbn(String isbn) =>
      _repository.checkIsbn(isbn);

  Future<List<GenreModel>> fetchGenres() async {
    final data = await _repository.fetchGenres();
    if (data == null) return [];
    return data.map((e) => GenreModel.fromJson(e)).toList();
  }

  /// Clears the cached book list so a different user signing in next doesn't
  /// see the previous user's books. Called from logout.
  void reset() {
    _books.clear();
    isLoading = false;
    notifyListeners();
  }
}
