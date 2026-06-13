// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get ruangBuku => 'RuangBuku';

  @override
  String get home => 'Beranda';

  @override
  String get findBook => 'Cari Buku';

  @override
  String get curation => 'Kurasi';

  @override
  String get yourBooks => 'Buku Anda';

  @override
  String get borrowing => 'Peminjaman';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get indonesia => 'Indonesia';

  @override
  String get english => 'Inggris';

  @override
  String get authHeaderTagline => 'Berbagi buku, memperluas wawasan.';

  @override
  String get login => 'Masuk';

  @override
  String get loginSubtitle => 'Silakan masuk untuk melanjutkan';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Masukkan email Anda';

  @override
  String get emailEmptyError => 'Email tidak boleh kosong';

  @override
  String get emailInvalidError => 'Format email tidak valid';

  @override
  String get password => 'Kata Sandi';

  @override
  String get passwordHint => 'Masukkan kata sandi Anda';

  @override
  String get passwordEmptyError => 'Kata sandi tidak boleh kosong';

  @override
  String get passwordLengthError => 'Kata sandi minimal 8 karakter';

  @override
  String get noAccountPrompt => 'Belum punya akun? ';

  @override
  String get register => 'Daftar';

  @override
  String get registerSubtitle => 'Buat akun untuk mulai meminjam buku';

  @override
  String get name => 'Nama';

  @override
  String get nameHint => 'Masukkan nama Anda';

  @override
  String get nameEmptyError => 'Nama tidak boleh kosong';

  @override
  String get nameLengthError => 'Nama minimal 3 karakter';

  @override
  String get confirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get confirmPasswordHint => 'Masukkan ulang kata sandi Anda';

  @override
  String get confirmPasswordEmptyError =>
      'Konfirmasi kata sandi tidak boleh kosong';

  @override
  String get confirmPasswordMatchError => 'Konfirmasi kata sandi tidak cocok';

  @override
  String get hasAccountPrompt => 'Sudah punya akun? ';

  @override
  String get editProfile => 'Edit Profil';

  @override
  String get paymentDetails => 'Rincian Pembayaran';

  @override
  String get helpSupport => 'Bantuan & Dukungan';

  @override
  String get contactSupport => 'Pilih cara untuk menghubungi kami:';

  @override
  String get emailContact => 'Email';

  @override
  String get whatsappContact => 'WhatsApp';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutConfirmation => 'Apakah Anda yakin ingin keluar?';

  @override
  String get cancel => 'Batal';

  @override
  String get paymentInfo => 'Informasi Pembayaran';

  @override
  String get paymentDesc =>
      'Gunakan detail berikut untuk memverifikasi pembayaran deposit atau mentransfer dana.';

  @override
  String get bankTransfer => 'Transfer Bank';

  @override
  String get eWallet => 'E-Wallet';

  @override
  String get owned => 'Dimiliki';

  @override
  String get borrowed => 'Dipinjam';

  @override
  String get lent => 'Dipinjamkan';

  @override
  String get addNewMethod => 'Tambah Metode Baru';

  @override
  String get logoutTitle => 'Keluar dari Akun';

  @override
  String get logoutDesc =>
      'Apakah Anda yakin ingin keluar? Anda perlu masuk kembali untuk mengakses akun.';

  @override
  String get goodMorning => 'Selamat pagi,';

  @override
  String get findNextRead =>
      'Temukan bacaan Anda selanjutnya dari perpustakaan komunitas Anda.';

  @override
  String get searchBooks => 'Cari buku atau tetangga...';

  @override
  String get popularNearYou => 'Populer di Sekitar Anda';

  @override
  String get seeAll => 'Lihat semua';

  @override
  String get recentlyAdded => 'Baru Ditambahkan';

  @override
  String noBooksFound(String query) {
    return 'Tidak ada buku yang cocok dengan \"$query\"';
  }

  @override
  String get allCategories => 'Semua Kategori';

  @override
  String get availableNow => 'Tersedia Sekarang';

  @override
  String get within5km => 'Dalam 5km';

  @override
  String booksFound(String count) {
    return '$count Buku Ditemukan';
  }

  @override
  String get sortDistance => 'Urutkan Jarak';

  @override
  String get onLoan => 'Dipinjam';

  @override
  String get available => 'Tersedia';

  @override
  String kmAway(String distance) {
    return '$distance km jauhnya';
  }

  @override
  String get pendingApproval => 'Menunggu Persetujuan';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Hapus';

  @override
  String get addBook => 'Tambah Buku';

  @override
  String addedBy(String name) {
    return 'Ditambahkan oleh $name';
  }

  @override
  String get adminCuration => 'Kurasi Admin';

  @override
  String get allCaughtUp => 'Semua Selesai!';

  @override
  String get noBooksAwaitingCuration =>
      'Tidak ada buku yang menunggu persetujuan kurasi saat ini.';

  @override
  String get yourLibraryEmpty => 'Perpustakaan Anda kosong';

  @override
  String get haventAddedBooks =>
      'Anda belum menambahkan buku apa pun. Klik tombol \"+\" di bawah ini untuk mendaftarkan buku (F-01)!';

  @override
  String get rejected => 'Ditolak';

  @override
  String get privateBook => 'Privat';

  @override
  String get deleteConfirmTitle => 'Apakah Anda ingin menghapus buku Anda?';

  @override
  String deleteConfirmMsg(String title) {
    return 'Silakan masukkan \"$title\" untuk mengonfirmasi.';
  }

  @override
  String get bookRemoved => 'Buku dihapus dari perpustakaan';

  @override
  String get borrowings => 'Peminjaman';

  @override
  String get noTransactions => 'Belum Ada Transaksi';

  @override
  String get noTransactionsMsg =>
      'Anda belum memiliki transaksi peminjaman buku.';

  @override
  String get incomingRequests => 'Permintaan Masuk';

  @override
  String get yourTransactions => 'Transaksi Anda';

  @override
  String borrowerName(String name) {
    return 'Peminjam: $name';
  }

  @override
  String ownerName(String name) {
    return 'Pemilik: $name';
  }

  @override
  String get statusRequested => 'Menunggu Konfirmasi';

  @override
  String get statusWaitingDeposit => 'Menunggu Deposit';

  @override
  String get statusDepositUploaded => 'Verifikasi Deposit';

  @override
  String get statusDepositVerified => 'Deposit Terverifikasi';

  @override
  String get statusBookReceived => 'Buku Diterima';

  @override
  String get statusReturnedGood => 'Dikembalikan Baik';

  @override
  String get statusReturnedDamaged => 'Dikembalikan Rusak';

  @override
  String get statusCompleted => 'Selesai';

  @override
  String get statusCancelled => 'Dibatalkan/Ditolak';

  @override
  String get requestAccepted => 'Permintaan diterima.';

  @override
  String get requestRejected => 'Permintaan ditolak.';

  @override
  String failed(String error) {
    return 'Gagal: $error';
  }

  @override
  String get reject => 'Tolak';

  @override
  String get accept => 'Terima';

  @override
  String get myBookDetails => 'Detail Buku Saya';

  @override
  String errorLoadingBookDetails(String error) {
    return 'Gagal memuat detail buku: $error';
  }

  @override
  String get bookNotFound => 'Buku tidak ditemukan.';

  @override
  String get condition => 'Kondisi';

  @override
  String get lendingStatus => 'Status Peminjaman';

  @override
  String get privateCollection => 'Koleksi Privat';

  @override
  String get borrowHistory => 'Riwayat Peminjaman';

  @override
  String get deleteNotSupported => 'Fitur hapus belum didukung oleh backend';

  @override
  String get removeBook => 'Hapus Buku dari Perpustakaan';

  @override
  String get bookDetailsLoaded => 'Detail buku berhasil dimuat dari API!';

  @override
  String get bookNotFoundInServer =>
      'Buku tidak ditemukan di server/Google Books.';

  @override
  String get fillInRequiredFields => 'Harap isi ISBN, Judul, dan Penulis.';

  @override
  String bookAddedForCuration(String title) {
    return '\"$title\" berhasil ditambahkan dan diajukan untuk persetujuan Kurasi Admin (F-01)!';
  }

  @override
  String bookAddedPrivate(String title) {
    return '\"$title\" ditambahkan ke koleksi privat Anda!';
  }

  @override
  String get addABook => 'Tambah Buku';

  @override
  String get addByIsbn => 'Tambah dengan ISBN';

  @override
  String get isbnNumber => 'Nomor ISBN';

  @override
  String get isbnHint => 'contoh: 9781471156267';

  @override
  String get bookDetails => 'Detail Buku';

  @override
  String get bookTitleLabel => 'Judul';

  @override
  String get enterBookTitle => 'Masukkan judul buku';

  @override
  String get authorLabel => 'Penulis';

  @override
  String get enterAuthorName => 'Masukkan nama penulis';

  @override
  String get descriptionLabel => 'Deskripsi';

  @override
  String get enterDescription => 'Masukkan sinopsis atau deskripsi singkat';

  @override
  String get yourCopy => 'Salinan Anda';

  @override
  String get addBookToLibrary => 'Tambahkan Buku ke Perpustakaan';

  @override
  String get borrowingDetailsTitle => 'Detail Peminjaman';

  @override
  String get transactionNotFound => 'Transaksi tidak ditemukan';

  @override
  String get transactionInfo => 'Informasi Transaksi';

  @override
  String get borrowerLabel => 'Peminjam';

  @override
  String get ownerLabel => 'Pemilik Buku';

  @override
  String get borrowingDate => 'Tanggal Peminjaman';

  @override
  String get depositAmountLabel => 'Nominal Deposit';

  @override
  String get borrowingProgress => 'Progres Peminjaman';

  @override
  String get damageReportLabel => 'Laporan Kerusakan';

  @override
  String depositDeduction(String amount) {
    return 'Potongan Deposit: Rp $amount';
  }

  @override
  String get waitingOwnerApproval => 'Menunggu persetujuan pemilik buku.';

  @override
  String get approvedUploadDeposit =>
      'Disetujui! Unggah bukti deposit untuk melanjutkan.';

  @override
  String get uploadDepositProof => 'Unggah Bukti Deposit (Rp 50.000)';

  @override
  String get depositSent => 'Bukti deposit terkirim.';

  @override
  String get viewDepositProof => 'Lihat Bukti Deposit';

  @override
  String get waitingAdminVerification => 'Menunggu Verifikasi Admin';

  @override
  String get depositVerifiedTakeBook =>
      'Deposit terverifikasi. Ambil buku, lalu konfirmasi.';

  @override
  String get confirmBookReceived => 'Konfirmasi Buku Diterima';

  @override
  String get bookConfirmedReceived => 'Buku dikonfirmasi diterima.';

  @override
  String get youHoldBook =>
      'Anda memegang buku ini. Koordinasi pengembalian dengan pemilik.';

  @override
  String get currentlyBorrowed => 'Sedang Dipinjam';

  @override
  String get bookReturnedGoodWaitingDeposit =>
      'Buku dikembalikan baik. Menunggu pengembalian deposit.';

  @override
  String get waitingDepositReturn => 'Menunggu Pengembalian Deposit';

  @override
  String get reportedDamagedWaitingAdmin =>
      'Dilaporkan rusak. Menunggu penyelesaian admin.';

  @override
  String get disputeOpened => 'Sengketa Dibuka';

  @override
  String get borrowerActions => 'Tindakan Peminjam';

  @override
  String get ownerActions => 'Tindakan Pemilik';

  @override
  String get borrowerHoldsBook =>
      'Peminjam sedang memegang buku. Saat dikembalikan, konfirmasi kondisinya.';

  @override
  String get confirmReturn => 'Konfirmasi Pengembalian';

  @override
  String get depositConfirmed => 'Deposit dikonfirmasi.';

  @override
  String get confirmDepositAdmin => 'Konfirmasi Deposit';

  @override
  String get depositReturnedToBorrower => 'Deposit dikembalikan ke peminjam.';

  @override
  String get returnDepositToBorrower => 'Kembalikan Deposit ke Peminjam';

  @override
  String get settleDamageDispute => 'Selesaikan Sengketa Kerusakan';

  @override
  String get adminActions => 'Tindakan Admin';

  @override
  String get failedLoadBook =>
      'Gagal memuat detail buku. Periksa koneksi Anda.';

  @override
  String get retry => 'Coba lagi';

  @override
  String ownerLabelName(String name) {
    return 'Pemilik: $name';
  }

  @override
  String reviewsCount(String count) {
    return '($count Ulasan)';
  }

  @override
  String copyCondition(String condition) {
    return 'Salinan: $condition';
  }

  @override
  String get synopsis => 'Sinopsis';

  @override
  String get thisIsYourOwnBook => 'Ini adalah buku Anda sendiri';

  @override
  String get bookCurrentlyOnLoan => 'Buku sedang dipinjam';

  @override
  String get finishActiveBorrowing =>
      'Selesaikan peminjaman aktif Anda sebelum meminta yang lain.';

  @override
  String get borrowBook => 'Pinjam Buku';

  @override
  String get waitingForLenderApproval => 'Menunggu persetujuan Pemilik...';

  @override
  String get requestedStatus => 'Diminta';

  @override
  String get lenderApprovedPayDeposit =>
      'Pemilik menyetujui! Silakan bayar deposit.';

  @override
  String get uploadDepositProofRp => 'Unggah Bukti Deposit (Rp. 50.000)';

  @override
  String get depositProofSubmitted => 'Bukti deposit dikirim.';

  @override
  String get depositVerifiedMeetOwner =>
      'Deposit terverifikasi. Temui pemilik dan ambil buku.';

  @override
  String get bookStatusUpdatedBorrowed =>
      'Status buku diperbarui: Sedang Dipinjam.';

  @override
  String get youHaveThisBook =>
      'Anda memegang buku ini. Koordinasikan pengembalian; pemilik akan mengonfirmasi kondisinya.';

  @override
  String get onLoanText => 'Sedang Dipinjam';

  @override
  String get returnedGoodWaitingRefund =>
      'Dikembalikan Baik - Menunggu Pengembalian Dana';

  @override
  String get returnedDamagedDisputeOpen =>
      'Dikembalikan Rusak - Sengketa Terbuka';

  @override
  String errorLoadingBookName(String e) {
    return 'Gagal memuat buku: $e';
  }

  @override
  String get selectBothDates =>
      'Harap pilih tanggal Pengambilan dan Pengembalian.';

  @override
  String get returnDateAfterPickup =>
      'Tanggal pengembalian harus setelah tanggal pengambilan.';

  @override
  String get borrowRequestSubmitted =>
      'Permintaan peminjaman berhasil dikirim!';

  @override
  String get requestFailed => 'Permintaan Gagal';

  @override
  String get okText => 'OK';

  @override
  String get selectDateText => 'Pilih tanggal';

  @override
  String get requestToBorrow => 'Ajukan Peminjaman';

  @override
  String get lenderLabel => 'Pemilik';

  @override
  String get pickupDate => 'Tanggal Pengambilan';

  @override
  String get returnDate => 'Tanggal Pengembalian';

  @override
  String get messageToLender => 'Pesan untuk Pemilik (Opsional)';

  @override
  String get messageToLenderHint => 'Hai, saya ingin meminjam buku ini...';

  @override
  String get sendRequest => 'Kirim Permintaan';

  @override
  String get notificationsTitle => 'Notifikasi';

  @override
  String get noNotifications => 'Tidak Ada Notifikasi';

  @override
  String get noNotificationsCurrentRole =>
      'Anda tidak memiliki notifikasi pada peran Anda saat ini.';

  @override
  String get declineLabel => 'Tolak';

  @override
  String get acceptLabel => 'Terima';

  @override
  String get borrowRequestDeclined => 'Permintaan peminjaman ditolak.';

  @override
  String get borrowRequestAccepted =>
      'Permintaan peminjaman diterima (F-02)! Deep-link ke WA disimulasikan.';

  @override
  String get rejectPayment => 'Tolak Pembayaran';

  @override
  String get verifyPayment => 'Verifikasi Pembayaran';

  @override
  String get paymentRejected => 'Pembayaran ditolak.';

  @override
  String get paymentVerified =>
      'Pembayaran terverifikasi! Status deposit berubah menjadi DIBAYAR (F-02).';

  @override
  String reportedDamageLabel(String description) {
    return 'Laporan Kerusakan: $description';
  }

  @override
  String get resolveDisputeRefund => 'Selesaikan Sengketa & Kembalikan Dana';

  @override
  String get goodAfternoonSiang => 'Selamat siang,';

  @override
  String get goodAfternoonSore => 'Selamat sore,';

  @override
  String get goodEvening => 'Selamat malam,';
}
