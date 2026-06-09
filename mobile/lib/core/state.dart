import 'package:flutter/material.dart';
import 'services/book_service.dart';
import 'services/borrow_service.dart';
import 'services/auth_service.dart';

enum UserRole { borrower, lender, admin }

enum BookStatus { private, publicPending, publicApproved, publicRejected }

enum BorrowStatus {
  requested,
  waitingDeposit,
  depositUploaded,
  depositVerified,
  bookReceived,
  returnedGood,
  returnedDamaged,
  completed,
  cancelled
}

class BookModel {
  final String id;
  final String isbn;
  final String title;
  final String author;
  final String description;
  final bool isPublic;
  BookStatus statusVerifikasi;
  final String ownerId;
  final String ownerName;
  final String imageUrl;
  final String distance;
  String condition;

  BookModel({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    required this.description,
    required this.isPublic,
    required this.statusVerifikasi,
    required this.ownerId,
    required this.ownerName,
    required this.imageUrl,
    required this.distance,
    required this.condition,
  });

  BookModel copyWith({
    BookStatus? statusVerifikasi,
    String? condition,
  }) {
    return BookModel(
      id: id,
      isbn: isbn,
      title: title,
      author: author,
      description: description,
      isPublic: isPublic,
      statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
      ownerId: ownerId,
      ownerName: ownerName,
      imageUrl: imageUrl,
      distance: distance,
      condition: condition ?? this.condition,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    BookStatus parseStatus(String status) {
      if (status == 'private') return BookStatus.private;
      if (status == 'need_verification') return BookStatus.publicPending;
      if (status == 'approved') return BookStatus.publicApproved;
      if (status == 'rejected') return BookStatus.publicRejected;
      return BookStatus.private;
    }
    
    // Safety check for users array
    bool isPublic = false;
    String ownerId = '';
    String ownerName = 'Unknown';
    if (json['users'] != null && json['users'] is List && json['users'].isNotEmpty) {
      final user = json['users'][0];
      ownerId = user['id']?.toString() ?? '';
      ownerName = user['name'] ?? 'Unknown';
      if (user['pivot'] != null) {
        isPublic = user['pivot']['isPublic'] == 1 || user['pivot']['isPublic'] == true;
      }
    }

    return BookModel(
      id: json['id']?.toString() ?? '',
      isbn: json['isbn'] ?? '',
      title: json['title'] ?? 'Unknown',
      author: json['author'] ?? 'Unknown',
      description: json['description'] ?? '',
      isPublic: isPublic,
      statusVerifikasi: parseStatus(json['statusVerifikasi'] ?? ''),
      ownerId: ownerId,
      ownerName: ownerName,
      imageUrl: json['coverImageUrl'] ?? 'https://picsum.photos/200/300', // Placeholder if null
      distance: '0 km away',
      condition: 'Good',
    );
  }
}

class DamageReportModel {
  final String description;
  final String photoUrl;
  double deductionAmount;
  String adminDecision;

  DamageReportModel({
    required this.description,
    required this.photoUrl,
    this.deductionAmount = 0.0,
    this.adminDecision = '',
  });
}

class BorrowModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookImageUrl;
  final String borrowerId;
  final String borrowerName;
  final DateTime startDate;
  final DateTime endDate;
  BorrowStatus status;
  final double depositAmount;
  String? paymentProofUrl;
  DamageReportModel? damageReport;
  final DateTime createdAt;

  BorrowModel({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookImageUrl,
    required this.borrowerId,
    required this.borrowerName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.depositAmount,
    this.paymentProofUrl,
    this.damageReport,
    required this.createdAt,
  });

  factory BorrowModel.fromJson(Map<String, dynamic> json) {
    BorrowStatus parseStatus(String st) {
      switch (st) {
        case 'menunggu_konfirmasi': return BorrowStatus.requested;
        case 'menunggu_deposit': return BorrowStatus.waitingDeposit;
        case 'deposit_dibayar': return BorrowStatus.depositUploaded;
        case 'deposit_diverifikasi': return BorrowStatus.depositVerified;
        case 'buku_diterima': return BorrowStatus.bookReceived;
        case 'dikembalikan_baik': return BorrowStatus.returnedGood;
        case 'dikembalikan_rusak': return BorrowStatus.returnedDamaged;
        case 'selesai': return BorrowStatus.completed;
        case 'ditolak': return BorrowStatus.cancelled;
        case 'dibatalkan': return BorrowStatus.cancelled;
        default: return BorrowStatus.requested;
      }
    }

    final book = json['buku'] ?? {};

    return BorrowModel(
      id: json['id']?.toString() ?? '',
      bookId: json['buku_id']?.toString() ?? '',
      bookTitle: book['title'] ?? 'Unknown',
      bookAuthor: book['author'] ?? 'Unknown',
      bookImageUrl: book['coverImageUrl'] ?? 'https://picsum.photos/200/300',
      borrowerId: json['user_id']?.toString() ?? '',
      borrowerName: json['user']?['name'] ?? 'Unknown',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      status: parseStatus(json['status'] ?? ''),
      depositAmount: double.tryParse(json['deposit_amount']?.toString() ?? '50000') ?? 50000.0,
      paymentProofUrl: json['bukti_deposit'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

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

  UserRole _currentRole = UserRole.borrower;
  List<BookModel> _books = [];
  List<BorrowModel> _borrowings = [];
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  RuangBukuState._() {
    _seedMockNotifications();
  }

  UserRole get currentRole => _currentRole;
  List<BookModel> get books => _books;
  List<BorrowModel> get borrowings => _borrowings;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

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
      final userId = await AuthService.getUserId();
      final isAdmin = _currentRole == UserRole.admin;
      
      List<dynamic> data;
      if (isAdmin) {
        data = await BookService.getBooks(statusVerifikasi: 'need_verification', isPublic: true);
      } else {
        // As a borrower/lender, we want to see public books and our own books.
        // For simplicity right now we'll just fetch all books or filter by user if lender.
        data = await BookService.getBooks();
      }
      
      _books = data.map((e) => BookModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching books: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBorrowings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await BorrowService.getBorrowings(asOwner: _currentRole == UserRole.lender);
      _borrowings = data.map((e) => BorrowModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching borrowings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // F-01: Book Registration
  Future<void> addBook(String isbn, String title, String author, String description, String condition, bool isPublic) async {
    try {
      await BookService.addBook({
        'isbn': isbn,
        'title': title,
        'author': author,
        'description': description,
        'isPublic': isPublic,
        'condition': condition,
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
      await BorrowService.requestBorrow(bookId, start.toIso8601String().split('T')[0], end.toIso8601String().split('T')[0]);
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
        await BorrowService.approveBorrow(borrowId);
      } else {
        await BorrowService.rejectBorrow(borrowId);
      }
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error responding to borrow: $e');
      rethrow;
    }
  }

  // Borrower uploads payment proof
  Future<void> uploadProofOfDeposit(String borrowId) async {
    try {
      // Hardcode a mock proof URL for now since real file upload isn't hooked to UI
      await BorrowService.uploadDepositProof(borrowId, 'https://picsum.photos/seed/receipt/400/600');
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error uploading deposit proof: $e');
      rethrow;
    }
  }

  // Admin verifies payment
  void verifyDepositPayment(String borrowId, bool isValid) {
    // Requires backend implementation
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      borrowing.status = isValid ? BorrowStatus.depositVerified : BorrowStatus.waitingDeposit;
      notifyListeners();
    }
  }

  // Borrower confirms book received
  Future<void> confirmBookReceived(String borrowId) async {
    try {
      await BorrowService.confirmHandOver(borrowId);
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
        await BorrowService.confirmReturn(borrowId);
      } else {
        await BorrowService.reportDamage(
          borrowId, 
          damageDescription ?? 'Rusak', 
          [damagePhotoUrl ?? 'https://picsum.photos/seed/damage/400/300']
        );
      }
      await fetchBorrowings();
    } catch (e) {
      debugPrint('Error returning book: $e');
      rethrow;
    }
  }

  // Admin resolves refund or dispute
  void resolveRefundOrDispute(String borrowId, {double deduction = 0.0, String note = ''}) {
    // Requires backend implementation
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      borrowing.status = BorrowStatus.completed;
      notifyListeners();
    }
  }

  // Delete book from owner catalog
  void deleteBook(String bookId) {
    // Requires backend implementation
    _books.removeWhere((b) => b.id == bookId);
    notifyListeners();
  }

  // Update book conditions
  void updateBookCondition(String bookId, String condition, bool isPublic) {
    // Requires backend implementation
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
}
