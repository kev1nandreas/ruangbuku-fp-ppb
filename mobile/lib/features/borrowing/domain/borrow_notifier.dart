import '../data/models/borrow_model.dart';
import '../data/repository/borrow_repository.dart';

class BorrowNotifier {
  BorrowNotifier._();
  static final BorrowNotifier instance = BorrowNotifier._();

  final _repository = BorrowRepository.instance;

  Future<List<BorrowModel>> fetchBorrowings({required bool asOwner}) async {
    final data = await _repository.fetchBorrowings(asOwner: asOwner);
    if (data == null) return [];
    return data.map((e) => BorrowModel.fromJson(e)).toList();
  }

  Future<BorrowModel?> fetchBorrowDetail(String id) async {
    final data = await _repository.fetchBorrowDetail(id);
    if (data == null) return null;
    return BorrowModel.fromJson(data);
  }

  Future<void> requestBorrow(String bookId, String startDate, String endDate) =>
      _repository.requestBorrow(bookId, startDate, endDate);

  Future<void> approveBorrow(String id) => _repository.approveBorrow(id);

  Future<void> rejectBorrow(String id) => _repository.rejectBorrow(id);

  Future<void> uploadDepositProof(String id, String proofUrl) =>
      _repository.uploadDepositProof(id, proofUrl);

  Future<void> confirmHandOver(String id) => _repository.confirmHandOver(id);

  Future<void> confirmReturn(String id) => _repository.confirmReturn(id);

  Future<void> reportDamage(String id, String description, List<String> photoUrls) =>
      _repository.reportDamage(id, description, photoUrls);

  // --- admin actions ---------------------------------------------------

  Future<void> confirmDeposit(String id) => _repository.confirmDeposit(id);

  Future<void> returnDeposit(String id, {String? proofUrl, String? note}) =>
      _repository.returnDeposit(id, proofUrl: proofUrl, note: note);

  Future<void> resolveDamage(String id,
          {required String resolution, required String note, String? proofUrl}) =>
      _repository.resolveDamage(id,
          resolution: resolution, note: note, proofUrl: proofUrl);
}
