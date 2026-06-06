import 'package:flutter/material.dart';

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

  RuangBukuState._() {
    _seedMockData();
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
    _books.addAll([
      BookModel(
        id: 'book_1',
        isbn: '9781471156267',
        title: 'Sapiens: A Brief History of Humankind',
        author: 'Yuval Noah Harari',
        description: 'Earth is 4.5 billion years old. In just a fraction of that time, one species among countless others has conquered it: us. In this bold and provocative book, Yuval Noah Harari explores who we are, how we got here and where we\'re going.',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_sarah',
        ownerName: 'Sarah M.',
        imageUrl: 'https://picsum.photos/seed/pop0/200/300',
        distance: '1.2 km away',
        condition: 'Like New',
      ),
      BookModel(
        id: 'book_2',
        isbn: '9780441172719',
        title: 'Dune',
        author: 'Frank Herbert',
        description: 'Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides, heir to a noble family tasked with ruling an inhospitable world where the only thing of value is the "spice" melange, a drug capable of extending life and enhancing consciousness.',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_david',
        ownerName: 'David T.',
        imageUrl: 'https://picsum.photos/seed/pop2/200/300',
        distance: '2.5 km away',
        condition: 'Good',
      ),
      BookModel(
        id: 'book_3',
        isbn: '9781529055962',
        title: 'Tomorrow, and Tomorrow, and Tomorrow',
        author: 'Gabrielle Zevin',
        description: 'Two friends—often in love, but never lovers—become creative partners in a dazzling and intricately imagined world of video game design, where success brings them fame, joy, tragedy, duplicity, and, ultimately, a kind of immortality.',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_emma',
        ownerName: 'Emma W.',
        imageUrl: 'https://picsum.photos/seed/pop1/200/300',
        distance: '3.1 km away',
        condition: 'Very Good',
      ),
      BookModel(
        id: 'book_4',
        isbn: '9780593135204',
        title: 'Project Hail Mary',
        author: 'Andy Weir',
        description: 'Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish. Except that right now, he doesn\'t know that. He can\'t even remember his own name, let alone the nature of his assignment or how to complete it.',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_michael',
        ownerName: 'Michael K.',
        imageUrl: 'https://picsum.photos/seed/rec2/200/300',
        distance: '4.8 km away',
        condition: 'Acceptable',
      ),
      BookModel(
        id: 'book_5',
        isbn: '9781847941831',
        title: 'Atomic Habits',
        author: 'James Clear',
        description: 'People think when you want to change your life, you need to think big. But world-renowned habits expert James Clear has discovered another way. He knows that real change comes from the compound effect of hundreds of small decisions.',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_sarah',
        ownerName: 'Sarah M.',
        imageUrl: 'https://picsum.photos/seed/rec0/200/300',
        distance: '1.2 km away',
        condition: 'Like New',
      ),
      BookModel(
        id: 'book_6',
        isbn: '9781471156269',
        title: 'The Midnight Library',
        author: 'Matt Haig',
        description: 'Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived. To see how things would be if you had made other choices... Would you have done anything different, if you had the chance to undo your regrets?',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_sarah',
        ownerName: 'Sarah M.',
        imageUrl: 'https://picsum.photos/seed/grid0/200/300',
        distance: '1.5 km away',
        condition: 'Very Good',
      ),
      BookModel(
        id: 'book_7',
        isbn: '9780451524935',
        title: '1984',
        author: 'George Orwell',
        description: 'Winston Smith reins in his rebellion against the Party\'s total control, but his secret love affair with Julia leads him into the clutches of the Thought Police, where he faces torture and brainwashing in Room 101.',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_david',
        ownerName: 'David T.',
        imageUrl: 'https://picsum.photos/seed/grid1/200/300',
        distance: '2.5 km away',
        condition: 'Good',
      ),
      BookModel(
        id: 'book_8',
        isbn: '9780374275631',
        title: 'Thinking, Fast and Slow',
        author: 'Daniel Kahneman',
        description: 'In the international bestseller, Thinking, Fast and Slow, Daniel Kahneman, the renowned psychologist and winner of the Nobel Prize in Economics, takes us on a groundbreaking tour of the mind and explains the two systems that drive the way we think.',
        isPublic: true,
        statusVerifikasi: BookStatus.publicApproved,
        ownerId: 'user_emma',
        ownerName: 'Emma W.',
        imageUrl: 'https://picsum.photos/seed/grid3/200/300',
        distance: '3.1 km away',
        condition: 'Like New',
      ),
    ]);

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
  void addBook(String isbn, String title, String author, String description, String condition, bool isPublic) {
    final newId = 'book_${DateTime.now().millisecondsSinceEpoch}';
    final book = BookModel(
      id: newId,
      isbn: isbn,
      title: title,
      author: author,
      description: description,
      isPublic: isPublic,
      statusVerifikasi: isPublic ? BookStatus.publicPending : BookStatus.private,
      ownerId: 'user_alex',
      ownerName: 'Alex Johnson',
      imageUrl: 'https://picsum.photos/seed/own${_books.length}/200/300',
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
  void deleteBook(String bookId) {
    _books.removeWhere((b) => b.id == bookId);
    notifyListeners();
  }

  // Update book conditions
  void updateBookCondition(String bookId, String condition, bool isPublic) {
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
