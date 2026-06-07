import 'package:flutter/material.dart';
import 'api_service.dart';
import 'database_helper.dart';

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
  final List<BookModel> _books = [];
  final List<BorrowModel> _borrowings = [];
  final List<NotificationModel> _notifications = [];

  bool isLoadingBooks = false;

  RuangBukuState._() {
    _seedMockData();
    loadDiscoveryBooks();
  }

  Future<void> loadDiscoveryBooks() async {
    isLoadingBooks = true;
    notifyListeners();

    // 1. Try to fetch from API
    final apiBooks = await ApiService.fetchPublicBooks();

    if (apiBooks != null) {
      // API success: clear local DB and cache new data
      await DatabaseHelper.instance.clearBooks();
      _books.clear();

      for (var b in apiBooks) {
        final owner = (b['users'] != null && b['users'].isNotEmpty) ? b['users'][0] : null;
        
        final bookMap = {
          'id': b['id']?.toString() ?? '',
          'isbn': b['isbn']?.toString(),
          'title': b['title']?.toString() ?? 'No Title',
          'author': b['author']?.toString(),
          'description': b['description']?.toString(),
          'isPublic': 1,
          'statusVerifikasi': b['statusVerifikasi']?.toString(),
          'ownerId': owner != null ? owner['id']?.toString() : null,
          'ownerName': owner != null ? owner['name']?.toString() : 'Unknown',
          'imageUrl': b['coverImageUrl']?.toString() ?? 'https://picsum.photos/seed/${b['id']}/200/300',
          'distance': '1.0 km away', // Mock distance
          'condition': 'Good', // Mock condition
        };

        await DatabaseHelper.instance.insertBook(bookMap);
        _addBookFromMap(bookMap);
      }
    } else {
      // API failed (offline/unauthorized): fetch from local DB
      print('API failed, falling back to local DB...');
      final localBooks = await DatabaseHelper.instance.getAllBooks();
      _books.clear();
      for (var b in localBooks) {
        _addBookFromMap(b);
      }
    }

    isLoadingBooks = false;
    notifyListeners();
  }

  void _addBookFromMap(Map<String, dynamic> b) {
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

  UserRole get currentRole => _currentRole;
  List<BookModel> get books => _books;
  List<BorrowModel> get borrowings => _borrowings;
  List<NotificationModel> get notifications => _notifications;

  void changeRole(UserRole newRole) {
    _currentRole = newRole;
    notifyListeners();
  }

  // Seed initial mock books
  void _seedMockData() {
    // Initial Notifications Seed
    _notifications.addAll([
      NotificationModel(
        id: 'notif_init_1',
        title: 'System Welcome',
        message: 'Welcome to RuangBuku! Complete your profile to start borrowing and sharing books.',
        time: '3 days ago',
        role: UserRole.borrower,
        icon: Icons.celebration,
        iconColor: Colors.purple,
      ),
      NotificationModel(
        id: 'notif_init_2',
        title: 'Admin Curation',
        message: 'Your book "Sapiens" has been approved and is now visible to the community.',
        time: '5 hours ago',
        role: UserRole.lender,
        icon: Icons.check_circle,
        iconColor: Colors.green,
      )
    ]);
  }

  // F-01: Book Registration
  Future<void> addBook(String isbn, String title, String author, String description, String condition, bool isPublic) async {
    final payload = {
      'isbn': isbn,
      'title': title,
      'author': author,
      'description': description,
      'isPublic': isPublic,
    };
    
    final serverData = await ApiService.createBook(payload);
    
    final newId = serverData?['id']?.toString() ?? 'book_${DateTime.now().millisecondsSinceEpoch}';
    
    final book = BookModel(
      id: newId,
      isbn: serverData?['isbn'] ?? isbn,
      title: serverData?['title'] ?? title,
      author: serverData?['author'] ?? author,
      description: serverData?['description'] ?? description,
      isPublic: isPublic,
      statusVerifikasi: isPublic ? BookStatus.publicPending : BookStatus.private,
      ownerId: 'user_alex',
      ownerName: 'Alex Johnson',
      imageUrl: serverData?['coverImageUrl'] ?? 'https://picsum.photos/seed/own${_books.length}/200/300',
      distance: '0.0 km away',
      condition: condition,
    );

    _books.insert(0, book);

    if (isPublic) {
      // Add notification to Admin
      _notifications.insert(0, NotificationModel(
        id: 'notif_adm_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Book Curation Pending',
        message: 'Alex Johnson added "$title" for lending. Click to review and curate.',
        time: 'Just now',
        role: UserRole.admin,
        icon: Icons.gavel,
        iconColor: Colors.orange,
        bookId: newId,
        isPending: true,
      ));
      // Notify Lender
      _notifications.insert(0, NotificationModel(
        id: 'notif_own_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Book Submitted',
        message: 'Your book "$title" has been submitted for Admin curation.',
        time: 'Just now',
        role: UserRole.lender,
        icon: Icons.hourglass_empty,
        iconColor: Colors.blue,
      ));
    } else {
      // Notify Lender directly
      _notifications.insert(0, NotificationModel(
        id: 'notif_own_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Book Added to Private Catalog',
        message: '"$title" is added to your private collection. It is not visible to others.',
        time: 'Just now',
        role: UserRole.lender,
        icon: Icons.lock,
        iconColor: Colors.grey,
      ));
    }

    notifyListeners();
  }

  // Admin verifies book
  void verifyBook(String bookId, bool isApproved) {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final book = _books[index];
      book.statusVerifikasi = isApproved ? BookStatus.publicApproved : BookStatus.publicRejected;

      // Mark the admin notification as resolved
      for (var notif in _notifications) {
        if (notif.bookId == bookId && notif.role == UserRole.admin) {
          notif.isPending = false;
          notif.statusText = isApproved ? 'Approved' : 'Rejected';
        }
      }

      // Add notifications to Owner
      _notifications.insert(0, NotificationModel(
        id: 'notif_own_${DateTime.now().millisecondsSinceEpoch}',
        title: isApproved ? 'Book Approved' : 'Book Rejected',
        message: 'Your book "${book.title}" has been ${isApproved ? 'approved and is now public!' : 'rejected and remains private.'}',
        time: 'Just now',
        role: UserRole.lender,
        icon: isApproved ? Icons.check_circle : Icons.cancel,
        iconColor: isApproved ? Colors.green : Colors.red,
      ));

      notifyListeners();
    }
  }

  // F-02: Book Borrowing Request
  String? requestBorrow(String bookId, DateTime start, DateTime end, String message) {
    // 1. Borrower cannot borrow > 1 active book
    final activeBorrow = _borrowings.any((b) =>
        b.borrowerId == 'user_alex' &&
        b.status != BorrowStatus.completed &&
        b.status != BorrowStatus.cancelled);
    if (activeBorrow) {
      return 'You already have an active borrowing request. P2P Sharing allows max 1 active book at a time.';
    }

    // 2. Validate overlapping dates
    final book = _books.firstWhere((b) => b.id == bookId);
    final isOverlap = _borrowings.any((b) =>
        b.bookId == bookId &&
        b.status != BorrowStatus.cancelled &&
        !(end.isBefore(b.startDate) || start.isAfter(b.endDate)));
    if (isOverlap) {
      return 'The requested dates overlap with an existing booking for this book.';
    }

    final newBorrowId = 'borrow_${DateTime.now().millisecondsSinceEpoch}';
    final borrowing = BorrowModel(
      id: newBorrowId,
      bookId: bookId,
      bookTitle: book.title,
      bookAuthor: book.author,
      bookImageUrl: book.imageUrl,
      borrowerId: 'user_alex',
      borrowerName: 'Alex Johnson',
      startDate: start,
      endDate: end,
      status: BorrowStatus.requested,
      depositAmount: 50000.0, // Fixed Rp. 50,000 deposit
      createdAt: DateTime.now(),
    );

    _borrowings.insert(0, borrowing);

    // Notify Owner (Lender)
    _notifications.insert(0, NotificationModel(
      id: 'notif_borrow_req_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Borrow Request Received',
      message: 'Alex Johnson requested to borrow "${book.title}".',
      time: 'Just now',
      role: UserRole.lender,
      icon: Icons.mail_outline,
      iconColor: Colors.orange,
      borrowId: newBorrowId,
      isPending: true,
    ));

    // Notify Borrower
    _notifications.insert(0, NotificationModel(
      id: 'notif_borrow_sent_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Request Sent',
      message: 'Your request for "${book.title}" has been sent to ${book.ownerName}.',
      time: 'Just now',
      role: UserRole.borrower,
      icon: Icons.send_rounded,
      iconColor: Colors.blue,
      borrowId: newBorrowId,
    ));

    notifyListeners();
    return null; // No errors, success
  }

  // Owner responds to borrow request (approve/reject)
  void respondToBorrowRequest(String borrowId, bool approve) {
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      borrowing.status = approve ? BorrowStatus.waitingDeposit : BorrowStatus.cancelled;

      // Mark lender notifications as resolved
      for (var notif in _notifications) {
        if (notif.borrowId == borrowId && notif.role == UserRole.lender) {
          notif.isPending = false;
          notif.statusText = approve ? 'Approved' : 'Declined';
        }
      }

      // Add borrower notification
      _notifications.insert(0, NotificationModel(
        id: 'notif_borrow_res_${DateTime.now().millisecondsSinceEpoch}',
        title: approve ? 'Request Accepted' : 'Request Declined',
        message: approve
            ? 'Your request for "${borrowing.bookTitle}" was approved by the owner! Please pay the deposit of Rp. 50,000.'
            : 'Your request for "${borrowing.bookTitle}" was declined by the owner.',
        time: 'Just now',
        role: UserRole.borrower,
        icon: approve ? Icons.wallet : Icons.cancel,
        iconColor: approve ? Colors.green : Colors.red,
        borrowId: borrowId,
      ));

      notifyListeners();
    }
  }

  // Borrower uploads payment proof
  void uploadProofOfDeposit(String borrowId) {
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      borrowing.status = BorrowStatus.depositUploaded;
      borrowing.paymentProofUrl = 'https://picsum.photos/seed/receipt/400/600'; // Simulating URL

      // Notify Admin
      _notifications.insert(0, NotificationModel(
        id: 'notif_adm_pay_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Verify Deposit Payment',
        message: 'Alex Johnson uploaded payment proof of Rp. 50,000 for "${borrowing.bookTitle}".',
        time: 'Just now',
        role: UserRole.admin,
        icon: Icons.monetization_on,
        iconColor: Colors.blue,
        borrowId: borrowId,
        isPending: true,
      ));

      // Notify Borrower
      _notifications.insert(0, NotificationModel(
        id: 'notif_bor_pay_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Deposit Proof Uploaded',
        message: 'Deposit proof uploaded. Waiting for Admin verification.',
        time: 'Just now',
        role: UserRole.borrower,
        icon: Icons.access_time,
        iconColor: Colors.blue,
        borrowId: borrowId,
      ));

      notifyListeners();
    }
  }

  // Admin verifies payment
  void verifyDepositPayment(String borrowId, bool isValid) {
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      borrowing.status = isValid ? BorrowStatus.depositVerified : BorrowStatus.waitingDeposit;

      // Mark Admin notification as resolved
      for (var notif in _notifications) {
        if (notif.borrowId == borrowId && notif.role == UserRole.admin) {
          notif.isPending = false;
          notif.statusText = isValid ? 'Verified' : 'Invalid';
        }
      }

      // Notify Borrower
      _notifications.insert(0, NotificationModel(
        id: 'notif_bor_pay_res_${DateTime.now().millisecondsSinceEpoch}',
        title: isValid ? 'Deposit Verified' : 'Deposit Rejected',
        message: isValid
            ? 'Your deposit of Rp. 50,000 is verified! Please coordinate with owner for handover.'
            : 'Your deposit was rejected. Please re-upload valid payment proof.',
        time: 'Just now',
        role: UserRole.borrower,
        icon: isValid ? Icons.verified_user : Icons.warning,
        iconColor: isValid ? Colors.green : Colors.red,
        borrowId: borrowId,
      ));

      // Notify Owner to hand over the book (SLA 3 days)
      if (isValid) {
        _notifications.insert(0, NotificationModel(
          id: 'notif_own_hand_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Deposit Received - Handover Book',
          message: 'Deposit for "${borrowing.bookTitle}" verified by Admin. Please hand over the book within 3 days.',
          time: 'Just now',
          role: UserRole.lender,
          icon: Icons.local_shipping,
          iconColor: Colors.green,
          borrowId: borrowId,
        ));
      }

      notifyListeners();
    }
  }

  // Borrower confirms book received
  void confirmBookReceived(String borrowId) {
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      borrowing.status = BorrowStatus.bookReceived;

      // Update book lending status in book list
      final bookIndex = _books.indexWhere((b) => b.id == borrowing.bookId);
      if (bookIndex != -1) {
        // Just keeping it marked as On Loan
      }

      // Notify Owner
      _notifications.insert(0, NotificationModel(
        id: 'notif_own_rec_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Book Received by Borrower',
        message: 'Alex Johnson has confirmed receipt of "${borrowing.bookTitle}". The loan is active.',
        time: 'Just now',
        role: UserRole.lender,
        icon: Icons.bookmark,
        iconColor: Colors.green,
        borrowId: borrowId,
      ));

      notifyListeners();
    }
  }

  // F-03: Book Return & Inspection
  void returnBook(String borrowId, {required bool isGoodCondition, String? damageDescription, String? damagePhotoUrl}) {
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      
      if (isGoodCondition) {
        borrowing.status = BorrowStatus.returnedGood;

        // Notify Admin to refund deposit
        _notifications.insert(0, NotificationModel(
          id: 'notif_adm_ref_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Refund Pending (Good Condition)',
          message: '"${borrowing.bookTitle}" returned in good condition. Please process Rp. 50,000 refund.',
          time: 'Just now',
          role: UserRole.admin,
          icon: Icons.payments_outlined,
          iconColor: Colors.green,
          borrowId: borrowId,
          isPending: true,
        ));

        // Notify Borrower
        _notifications.insert(0, NotificationModel(
          id: 'notif_bor_ret_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Book Returned',
          message: 'Lender confirmed "${borrowing.bookTitle}" returned in good condition. Admin will refund deposit.',
          time: 'Just now',
          role: UserRole.borrower,
          icon: Icons.done_all,
          iconColor: Colors.green,
          borrowId: borrowId,
        ));
      } else {
        borrowing.status = BorrowStatus.returnedDamaged;
        borrowing.damageReport = DamageReportModel(
          description: damageDescription ?? 'Cacat fisik pada buku.',
          photoUrl: damagePhotoUrl ?? 'https://picsum.photos/seed/damage/400/300',
        );

        // Notify Admin to resolve dispute
        _notifications.insert(0, NotificationModel(
          id: 'notif_adm_disp_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Dispute Resolution Needed',
          message: '"${borrowing.bookTitle}" returned damaged. Action required to verify damage and deduct deposit.',
          time: 'Just now',
          role: UserRole.admin,
          icon: Icons.report_problem,
          iconColor: Colors.red,
          borrowId: borrowId,
          isPending: true,
        ));

        // Notify Borrower
        _notifications.insert(0, NotificationModel(
          id: 'notif_bor_dmg_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Damaged Book Dispute Opened',
          message: 'Lender reported "${borrowing.bookTitle}" as damaged. Admin will investigate and determine deposit deduction.',
          time: 'Just now',
          role: UserRole.borrower,
          icon: Icons.report_gmailerrorred,
          iconColor: Colors.red,
          borrowId: borrowId,
        ));
      }

      notifyListeners();
    }
  }

  // Admin resolves refund or dispute
  void resolveRefundOrDispute(String borrowId, {double deduction = 0.0, String note = ''}) {
    final index = _borrowings.indexWhere((b) => b.id == borrowId);
    if (index != -1) {
      final borrowing = _borrowings[index];
      borrowing.status = BorrowStatus.completed;

      if (borrowing.damageReport != null) {
        borrowing.damageReport!.deductionAmount = deduction;
        borrowing.damageReport!.adminDecision = note;
      }

      // Mark admin notifications as resolved
      for (var notif in _notifications) {
        if (notif.borrowId == borrowId && notif.role == UserRole.admin) {
          notif.isPending = false;
          notif.statusText = 'Resolved';
        }
      }

      // Notify Borrower
      final refundAmount = borrowing.depositAmount - deduction;
      _notifications.insert(0, NotificationModel(
        id: 'notif_bor_comp_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Transaction Completed',
        message: deduction > 0
            ? 'Deposit resolved. Deducted Rp. ${deduction.toInt()} for damage ($note). Refund of Rp. ${refundAmount.toInt()} processed.'
            : 'Refund of Rp. ${borrowing.depositAmount.toInt()} processed successfully.',
        time: 'Just now',
        role: UserRole.borrower,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        borrowId: borrowId,
      ));

      notifyListeners();
    }
  }

  // Delete book from owner catalog
  Future<void> deleteBook(String bookId) async {
    if (!bookId.startsWith('book_')) {
      await ApiService.deleteBook(bookId);
    }
    _books.removeWhere((b) => b.id == bookId);
    notifyListeners();
  }

  // Update book conditions
  Future<void> updateBookCondition(String bookId, String condition, bool isPublic) async {
    if (!bookId.startsWith('book_')) {
      await ApiService.updateBook(bookId, {
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
}
