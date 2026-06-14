import 'package:flutter/material.dart';
import 'storage/secure_storage.dart';
import '../features/discovery/data/models/book_model.dart';
import '../features/discovery/data/models/genre_model.dart';
import '../features/discovery/domain/book_notifier.dart';
import '../features/borrowing/data/models/borrow_model.dart';
import '../features/borrowing/domain/borrow_notifier.dart';

export '../features/discovery/data/models/book_model.dart';
export '../features/borrowing/data/models/borrow_model.dart';

enum UserRole { borrower, lender, admin }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final UserRole role;
  final IconData icon;
  final Color iconColor;
  final String? borrowId;
  final String? bookId;
  bool isPending;
  String? statusText;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.role,
    required this.icon,
    required this.iconColor,
    this.borrowId,
    this.bookId,
    this.isPending = false,
    this.statusText,
  });
}

class RuangBukuState extends ChangeNotifier {
  static final RuangBukuState instance = RuangBukuState._();

  final _bookNotifier = BookNotifier.instance;
  final _borrowNotifier = BorrowNotifier.instance;
  final _storage = SecureStorage.instance;

  UserRole _currentRole = UserRole.borrower;
  List<BookModel> _books = [];
  List<GenreModel> _genres = [];
  List<BorrowModel> _borrowings = [];
  // Borrows on books this user OWNS (incoming side), fetched independently of
  // the role toggle: any user can own a book and must be able to accept/reject
  // requests on it regardless of which role view is active.
  List<BorrowModel> _ownerBorrowings = [];
  final List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  RuangBukuState._() {
    _seedMockNotifications();
    fetchGenres();
    fetchBooks();
    fetchBorrowings();
  }

  UserRole get currentRole => _currentRole;
  List<BookModel> get books => _books;
  List<GenreModel> get genres => _genres;
  List<BorrowModel> get borrowings => _borrowings;
  List<BorrowModel> get ownerBorrowings => _ownerBorrowings;

  /// Incoming requests awaiting this owner's approval.
  List<BorrowModel> get incomingRequests => _ownerBorrowings
      .where((b) => b.status == BorrowStatus.requested)
      .toList();
  List<NotificationModel> get notifications {
    final dynamicNotifs = <NotificationModel>[];

    // Add pending incoming borrowings as notifications
    if (_currentRole == UserRole.lender) {
      for (final b in _borrowings) {
        if (b.status == BorrowStatus.requested) {
          dynamicNotifs.add(NotificationModel(
            id: 'borrow_${b.id}',
            title: 'Borrow Request',
            message: '${b.borrowerName} requested to borrow "${b.bookTitle}"',
            time: '${b.createdAt.day}/${b.createdAt.month}/${b.createdAt.year}',
            role: UserRole.lender,
            icon: Icons.book,
            iconColor: Colors.blue,
            borrowId: b.id,
            bookId: b.bookId,
            isPending: true,
          ));
        }
      }
    }

    return [..._notifications, ...dynamicNotifs];
  }
  bool get isLoading => _isLoading;
  bool get isLoadingBooks => _bookNotifier.isLoading;

  void changeRole(UserRole newRole) {
    _currentRole = newRole;
    notifyListeners();
    fetchBooks();
    fetchBorrowings();
  }

  void _seedMockNotifications() {
    _notifications.addAll([
      NotificationModel(
        id: 'notif_init_1',
        title: 'System Welcome',
        message: 'Welcome to RuangBuku! Complete your profile to start borrowing and sharing books.',
        time: 'Just now',
        role: UserRole.borrower,
        icon: Icons.celebration,
        iconColor: Colors.purple,
      )
    ]);
  }

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _books = await _bookNotifier.fetchBooks(isAdmin: _currentRole == UserRole.admin);
    } catch (e) {
      debugPrint('Error fetching books: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGenres() async {
    try {
      _genres = await _bookNotifier.fetchGenres();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching genres: $e');
    }
  }

  Future<void> fetchBorrowings() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Borrows where this user is the borrower (or, for admins, all borrows).
      _borrowings = await _borrowNotifier.fetchBorrowings(
        asOwner: _currentRole == UserRole.lender,
      );
      // Always refresh the owner-side list too, independent of the role
      // toggle, so incoming requests on owned books are never hidden.
      // Admins already get every borrow above, so skip the extra call.
      if (_currentRole != UserRole.admin) {
        _ownerBorrowings =
            await _borrowNotifier.fetchBorrowings(asOwner: true);
      } else {
        _ownerBorrowings = _borrowings;
      }
    } catch (e) {
      debugPrint('Error fetching borrowings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // F-01: Book Registration
  Future<void> addBook(String isbn, String title, String author,
      String description, String condition, bool isPublic,
      {String? coverImageUrl}) async {
    try {
      await _bookNotifier.createBook({
        'isbn': isbn,
        'title': title,
        'author': author,
        'description': description,
        'isPublic': isPublic,
        'condition': condition,
        if (coverImageUrl != null && coverImageUrl.isNotEmpty)
          'coverImageUrl': coverImageUrl,
      });
      await fetchBooks();
    } catch (e) {
      debugPrint('Error adding book: $e');
      rethrow;
    }
  }

  // Admin verifies book
  void verifyBook(String bookId, bool isApproved) {
    // Requires backend implementation. Currently, we just mock the local state update.
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final book = _books[index];
      book.statusVerifikasi = isApproved ? BookStatus.publicApproved : BookStatus.publicRejected;
      notifyListeners();
    }
  }

  // F-02: Book Borrowing Request
  Future<String?> requestBorrow(String bookId, DateTime start, DateTime end, String message) async {
    try {
      await _borrowNotifier.requestBorrow(
        bookId,
        start.toIso8601String().split('T')[0],
        end.toIso8601String().split('T')[0],
      );
      await fetchBorrowings();
      return null;
    } catch (e) {
      debugPrint('Error requesting borrow: $e');
      return e.toString();
    }
  }

  // Owner responds to borrow request (approve/reject)
  Future<void> respondToBorrowRequest(String borrowId, bool approve) async {
    try {
      if (approve) {
        await _borrowNotifier.approveBorrow(borrowId);
      } else {
        await _borrowNotifier.rejectBorrow(borrowId);
      }
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error responding to borrow: $e');
      rethrow;
    }
  }

  // Borrower uploads payment proof. [proofUrl] is the public MinIO URL returned
  // by StorageRepository after the image has been uploaded.
  Future<void> uploadProofOfDeposit(String borrowId, String proofUrl) async {
    try {
      await _borrowNotifier.uploadDepositProof(borrowId, proofUrl);
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error uploading deposit proof: $e');
      rethrow;
    }
  }

  // Admin verifies payment (confirm-deposit route, admin only)
  Future<void> verifyDepositPayment(String borrowId, bool isValid) async {
    try {
      // Backend only supports confirming a submitted deposit. Rejecting is a
      // no-op (the borrower can re-submit while status stays waiting_deposit).
      if (isValid) {
        await _borrowNotifier.confirmDeposit(borrowId);
      }
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error confirming deposit: $e');
      rethrow;
    }
  }

  // Borrower confirms book received
  Future<void> confirmBookReceived(String borrowId) async {
    try {
      await _borrowNotifier.confirmHandOver(borrowId);
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error confirming hand over: $e');
      rethrow;
    }
  }

  // F-03: Book Return & Inspection
  Future<void> returnBook(String borrowId, {required bool isGoodCondition, String? damageDescription, String? damagePhotoUrl}) async {
    try {
      if (isGoodCondition) {
        await _borrowNotifier.confirmReturn(borrowId);
      } else {
        await _borrowNotifier.reportDamage(
          borrowId,
          damageDescription ?? 'Rusak',
          [damagePhotoUrl ?? 'https://picsum.photos/seed/damage/400/300'],
        );
      }
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error returning book: $e');
      rethrow;
    }
  }

  // Admin returns deposit to borrower for a cleanly-returned book
  // (return-deposit route, admin only).
  Future<void> returnDeposit(String borrowId, {String? note, String? proofUrl}) async {
    try {
      await _borrowNotifier.returnDeposit(borrowId, note: note, proofUrl: proofUrl);
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error returning deposit: $e');
      rethrow;
    }
  }

  // Admin settles a damage dispute (resolve-damage route, admin only).
  // [toOwner] true => deposit goes to owner, false => back to borrower.
  Future<void> resolveDamage(String borrowId,
      {required bool toOwner, required String note, String? proofUrl}) async {
    try {
      await _borrowNotifier.resolveDamage(
        borrowId,
        resolution: toOwner ? 'owner' : 'borrower',
        note: note,
        proofUrl: proofUrl,
      );
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error resolving damage: $e');
      rethrow;
    }
  }

  // Delete book from owner catalog
  Future<void> deleteBook(String bookId) async {
    if (!bookId.startsWith('book_')) {
      await _bookNotifier.deleteBook(bookId);
    }
    _books.removeWhere((b) => b.id == bookId);
    notifyListeners();
  }

  // Update book conditions
  Future<void> updateBookCondition(String bookId, String condition, bool isPublic) async {
    if (!bookId.startsWith('book_')) {
      await _bookNotifier.updateBook(bookId, {
        'isPublic': isPublic,
      });
    }

    final index = _books.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final oldBook = _books[index];
      final statusVerifikasi = (isPublic && oldBook.statusVerifikasi == BookStatus.private)
          ? BookStatus.publicPending
          : oldBook.statusVerifikasi;

      _books[index] = oldBook.copyWith(
        statusVerifikasi: statusVerifikasi,
        condition: condition,
      );
      notifyListeners();
    }
  }

  /// Returns the persisted current user id, or null when not logged in.
  Future<String?> currentUserId() => _storage.getUserId();
}
