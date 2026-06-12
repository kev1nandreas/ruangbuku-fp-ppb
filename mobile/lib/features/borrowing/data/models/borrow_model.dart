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
