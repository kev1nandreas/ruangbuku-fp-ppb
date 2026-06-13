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

class DamageReportModel {
  final String description;
  final List<String> photoUrls;
  double deductionAmount;
  String adminDecision;

  DamageReportModel({
    required this.description,
    this.photoUrls = const [],
    this.deductionAmount = 0.0,
    this.adminDecision = '',
  });

  /// Convenience: first photo or empty string.
  String get photoUrl => photoUrls.isNotEmpty ? photoUrls.first : '';

  factory DamageReportModel.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'];
    final photos = rawPhotos is List
        ? rawPhotos.map((e) => e.toString()).toList()
        : <String>[];
    return DamageReportModel(
      description: json['description']?.toString() ?? '',
      photoUrls: photos,
    );
  }
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

  /// Per-step lifecycle timestamps, set by the backend at each transition.
  /// Null until that step is reached.
  final DateTime? verifiedAt;
  final DateTime? depositReceivedAt;
  final DateTime? handedOverAt;
  final DateTime? returnedAt;
  final DateTime? depositReturnedAt;

  /// Who the admin returned the deposit to once settled: 'borrower' or 'owner'.
  final String? depositReturnedTo;
  final String? depositProofUrl;
  final String? resolutionNote;

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
    this.verifiedAt,
    this.depositReceivedAt,
    this.handedOverAt,
    this.returnedAt,
    this.depositReturnedAt,
    this.depositReturnedTo,
    this.depositProofUrl,
    this.resolutionNote,
  });

  /// Parses a nullable backend timestamp. Returns null when absent/invalid
  /// (the step hasn't happened yet), unlike the required-date fields.
  static DateTime? _parseDate(dynamic raw) {
    final s = raw?.toString();
    if (s == null || s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  factory BorrowModel.fromJson(Map<String, dynamic> json) {
    // Backend status strings (App\Models\Peminjaman constants).
    BorrowStatus parseStatus(String st) {
      switch (st) {
        case 'pending': return BorrowStatus.requested;
        case 'waiting_deposit': return BorrowStatus.waitingDeposit;
        case 'deposit_received': return BorrowStatus.depositVerified;
        case 'book_received': return BorrowStatus.bookReceived;
        case 'returned': return BorrowStatus.returnedGood;
        case 'damaged': return BorrowStatus.returnedDamaged;
        case 'completed': return BorrowStatus.completed;
        case 'rejected': return BorrowStatus.cancelled;
        case 'cancelled': return BorrowStatus.cancelled;
        default: return BorrowStatus.requested;
      }
    }

    final book = json['buku'] ?? {};

    final rawDeposit = json['buktiDeposit']?.toString();
    var status = parseStatus(json['status']?.toString() ?? '');
    // Borrower has submitted deposit proof but admin hasn't confirmed yet.
    if (status == BorrowStatus.waitingDeposit &&
        rawDeposit != null &&
        rawDeposit.isNotEmpty) {
      status = BorrowStatus.depositUploaded;
    }

    final kerusakan = json['kerusakan'];

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
      status: status,
      depositAmount: double.tryParse(json['deposit_amount']?.toString() ?? '50000') ?? 50000.0,
      paymentProofUrl: rawDeposit,
      damageReport: kerusakan is Map<String, dynamic>
          ? DamageReportModel.fromJson(kerusakan)
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      verifiedAt: _parseDate(json['verified_at']),
      depositReceivedAt: _parseDate(json['deposit_received_at']),
      handedOverAt: _parseDate(json['handed_over_at']),
      returnedAt: _parseDate(json['returned_at']),
      depositReturnedAt: _parseDate(json['deposit_returned_at']),
      depositReturnedTo: json['deposit_returned_to']?.toString(),
      depositProofUrl: json['deposit_proof_url']?.toString(),
      resolutionNote: json['resolution_note']?.toString(),
    );
  }
}
