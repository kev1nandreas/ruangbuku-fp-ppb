import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// App Name (must not be translated)
  ///
  /// In id, this message translates to:
  /// **'RuangBuku'**
  String get ruangBuku;

  /// No description provided for @home.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get home;

  /// No description provided for @findBook.
  ///
  /// In id, this message translates to:
  /// **'Cari Buku'**
  String get findBook;

  /// No description provided for @curation.
  ///
  /// In id, this message translates to:
  /// **'Kurasi'**
  String get curation;

  /// No description provided for @yourBooks.
  ///
  /// In id, this message translates to:
  /// **'Buku Anda'**
  String get yourBooks;

  /// No description provided for @borrowing.
  ///
  /// In id, this message translates to:
  /// **'Peminjaman'**
  String get borrowing;

  /// No description provided for @profile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @indonesia.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get indonesia;

  /// No description provided for @english.
  ///
  /// In id, this message translates to:
  /// **'Inggris'**
  String get english;

  /// No description provided for @authHeaderTagline.
  ///
  /// In id, this message translates to:
  /// **'Berbagi buku, memperluas wawasan.'**
  String get authHeaderTagline;

  /// No description provided for @login.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Silakan masuk untuk melanjutkan'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan email Anda'**
  String get emailHint;

  /// No description provided for @emailEmptyError.
  ///
  /// In id, this message translates to:
  /// **'Email tidak boleh kosong'**
  String get emailEmptyError;

  /// No description provided for @emailInvalidError.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid'**
  String get emailInvalidError;

  /// No description provided for @password.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi Anda'**
  String get passwordHint;

  /// No description provided for @passwordEmptyError.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi tidak boleh kosong'**
  String get passwordEmptyError;

  /// No description provided for @passwordLengthError.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi minimal 8 karakter'**
  String get passwordLengthError;

  /// No description provided for @noAccountPrompt.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? '**
  String get noAccountPrompt;

  /// No description provided for @register.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get register;

  /// No description provided for @registerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Buat akun untuk mulai meminjam buku'**
  String get registerSubtitle;

  /// No description provided for @name.
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get name;

  /// No description provided for @nameHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama Anda'**
  String get nameHint;

  /// No description provided for @nameEmptyError.
  ///
  /// In id, this message translates to:
  /// **'Nama tidak boleh kosong'**
  String get nameEmptyError;

  /// No description provided for @nameLengthError.
  ///
  /// In id, this message translates to:
  /// **'Nama minimal 3 karakter'**
  String get nameLengthError;

  /// No description provided for @confirmPassword.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Kata Sandi'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan ulang kata sandi Anda'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordEmptyError.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi tidak boleh kosong'**
  String get confirmPasswordEmptyError;

  /// No description provided for @confirmPasswordMatchError.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi tidak cocok'**
  String get confirmPasswordMatchError;

  /// No description provided for @hasAccountPrompt.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? '**
  String get hasAccountPrompt;

  /// No description provided for @editProfile.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get editProfile;

  /// No description provided for @paymentDetails.
  ///
  /// In id, this message translates to:
  /// **'Rincian Pembayaran'**
  String get paymentDetails;

  /// No description provided for @helpSupport.
  ///
  /// In id, this message translates to:
  /// **'Bantuan & Dukungan'**
  String get helpSupport;

  /// No description provided for @contactSupport.
  ///
  /// In id, this message translates to:
  /// **'Pilih cara untuk menghubungi kami:'**
  String get contactSupport;

  /// No description provided for @emailContact.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get emailContact;

  /// No description provided for @whatsappContact.
  ///
  /// In id, this message translates to:
  /// **'WhatsApp'**
  String get whatsappContact;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin keluar?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @paymentInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi Pembayaran'**
  String get paymentInfo;

  /// No description provided for @paymentDesc.
  ///
  /// In id, this message translates to:
  /// **'Gunakan detail berikut untuk memverifikasi pembayaran deposit atau mentransfer dana.'**
  String get paymentDesc;

  /// No description provided for @bankTransfer.
  ///
  /// In id, this message translates to:
  /// **'Transfer Bank'**
  String get bankTransfer;

  /// No description provided for @eWallet.
  ///
  /// In id, this message translates to:
  /// **'E-Wallet'**
  String get eWallet;

  /// No description provided for @owned.
  ///
  /// In id, this message translates to:
  /// **'Dimiliki'**
  String get owned;

  /// No description provided for @borrowed.
  ///
  /// In id, this message translates to:
  /// **'Dipinjam'**
  String get borrowed;

  /// No description provided for @lent.
  ///
  /// In id, this message translates to:
  /// **'Dipinjamkan'**
  String get lent;

  /// No description provided for @addNewMethod.
  ///
  /// In id, this message translates to:
  /// **'Tambah Metode Baru'**
  String get addNewMethod;

  /// No description provided for @logoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Akun'**
  String get logoutTitle;

  /// No description provided for @logoutDesc.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin keluar? Anda perlu masuk kembali untuk mengakses akun.'**
  String get logoutDesc;

  /// No description provided for @goodMorning.
  ///
  /// In id, this message translates to:
  /// **'Selamat pagi,'**
  String get goodMorning;

  /// No description provided for @findNextRead.
  ///
  /// In id, this message translates to:
  /// **'Temukan bacaan Anda selanjutnya dari perpustakaan komunitas Anda.'**
  String get findNextRead;

  /// No description provided for @searchBooks.
  ///
  /// In id, this message translates to:
  /// **'Cari buku atau tetangga...'**
  String get searchBooks;

  /// No description provided for @popularNearYou.
  ///
  /// In id, this message translates to:
  /// **'Populer di Sekitar Anda'**
  String get popularNearYou;

  /// No description provided for @seeAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua'**
  String get seeAll;

  /// No description provided for @recentlyAdded.
  ///
  /// In id, this message translates to:
  /// **'Baru Ditambahkan'**
  String get recentlyAdded;

  /// No description provided for @noBooksFound.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada buku yang cocok dengan \"{query}\"'**
  String noBooksFound(String query);

  /// No description provided for @allCategories.
  ///
  /// In id, this message translates to:
  /// **'Semua Kategori'**
  String get allCategories;

  /// No description provided for @availableNow.
  ///
  /// In id, this message translates to:
  /// **'Tersedia Sekarang'**
  String get availableNow;

  /// No description provided for @within5km.
  ///
  /// In id, this message translates to:
  /// **'Dalam 5km'**
  String get within5km;

  /// No description provided for @booksFound.
  ///
  /// In id, this message translates to:
  /// **'{count} Buku Ditemukan'**
  String booksFound(String count);

  /// No description provided for @sortDistance.
  ///
  /// In id, this message translates to:
  /// **'Urutkan Jarak'**
  String get sortDistance;

  /// No description provided for @onLoan.
  ///
  /// In id, this message translates to:
  /// **'Dipinjam'**
  String get onLoan;

  /// No description provided for @available.
  ///
  /// In id, this message translates to:
  /// **'Tersedia'**
  String get available;

  /// No description provided for @kmAway.
  ///
  /// In id, this message translates to:
  /// **'{distance} km jauhnya'**
  String kmAway(String distance);

  /// No description provided for @pendingApproval.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Persetujuan'**
  String get pendingApproval;

  /// No description provided for @edit.
  ///
  /// In id, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @addBook.
  ///
  /// In id, this message translates to:
  /// **'Tambah Buku'**
  String get addBook;

  /// No description provided for @addedBy.
  ///
  /// In id, this message translates to:
  /// **'Ditambahkan oleh {name}'**
  String addedBy(String name);

  /// No description provided for @adminCuration.
  ///
  /// In id, this message translates to:
  /// **'Kurasi Admin'**
  String get adminCuration;

  /// No description provided for @allCaughtUp.
  ///
  /// In id, this message translates to:
  /// **'Semua Selesai!'**
  String get allCaughtUp;

  /// No description provided for @noBooksAwaitingCuration.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada buku yang menunggu persetujuan kurasi saat ini.'**
  String get noBooksAwaitingCuration;

  /// No description provided for @yourLibraryEmpty.
  ///
  /// In id, this message translates to:
  /// **'Perpustakaan Anda kosong'**
  String get yourLibraryEmpty;

  /// No description provided for @haventAddedBooks.
  ///
  /// In id, this message translates to:
  /// **'Anda belum menambahkan buku apa pun. Klik tombol \"+\" di bawah ini untuk mendaftarkan buku (F-01)!'**
  String get haventAddedBooks;

  /// No description provided for @rejected.
  ///
  /// In id, this message translates to:
  /// **'Ditolak'**
  String get rejected;

  /// No description provided for @privateBook.
  ///
  /// In id, this message translates to:
  /// **'Privat'**
  String get privateBook;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda ingin menghapus buku Anda?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMsg.
  ///
  /// In id, this message translates to:
  /// **'Silakan masukkan \"{title}\" untuk mengonfirmasi.'**
  String deleteConfirmMsg(String title);

  /// No description provided for @bookRemoved.
  ///
  /// In id, this message translates to:
  /// **'Buku dihapus dari perpustakaan'**
  String get bookRemoved;

  /// No description provided for @borrowings.
  ///
  /// In id, this message translates to:
  /// **'Peminjaman'**
  String get borrowings;

  /// No description provided for @noTransactions.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Transaksi'**
  String get noTransactions;

  /// No description provided for @noTransactionsMsg.
  ///
  /// In id, this message translates to:
  /// **'Anda belum memiliki transaksi peminjaman buku.'**
  String get noTransactionsMsg;

  /// No description provided for @incomingRequests.
  ///
  /// In id, this message translates to:
  /// **'Permintaan Masuk'**
  String get incomingRequests;

  /// No description provided for @yourTransactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Anda'**
  String get yourTransactions;

  /// No description provided for @borrowerName.
  ///
  /// In id, this message translates to:
  /// **'Peminjam: {name}'**
  String borrowerName(String name);

  /// No description provided for @ownerName.
  ///
  /// In id, this message translates to:
  /// **'Pemilik: {name}'**
  String ownerName(String name);

  /// No description provided for @statusRequested.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Konfirmasi'**
  String get statusRequested;

  /// No description provided for @statusWaitingDeposit.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Deposit'**
  String get statusWaitingDeposit;

  /// No description provided for @statusDepositUploaded.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi Deposit'**
  String get statusDepositUploaded;

  /// No description provided for @statusDepositVerified.
  ///
  /// In id, this message translates to:
  /// **'Deposit Terverifikasi'**
  String get statusDepositVerified;

  /// No description provided for @statusBookReceived.
  ///
  /// In id, this message translates to:
  /// **'Buku Diterima'**
  String get statusBookReceived;

  /// No description provided for @statusReturnedGood.
  ///
  /// In id, this message translates to:
  /// **'Dikembalikan Baik'**
  String get statusReturnedGood;

  /// No description provided for @statusReturnedDamaged.
  ///
  /// In id, this message translates to:
  /// **'Dikembalikan Rusak'**
  String get statusReturnedDamaged;

  /// No description provided for @statusCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan/Ditolak'**
  String get statusCancelled;

  /// No description provided for @requestAccepted.
  ///
  /// In id, this message translates to:
  /// **'Permintaan diterima.'**
  String get requestAccepted;

  /// No description provided for @requestRejected.
  ///
  /// In id, this message translates to:
  /// **'Permintaan ditolak.'**
  String get requestRejected;

  /// No description provided for @failed.
  ///
  /// In id, this message translates to:
  /// **'Gagal: {error}'**
  String failed(String error);

  /// No description provided for @reject.
  ///
  /// In id, this message translates to:
  /// **'Tolak'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In id, this message translates to:
  /// **'Terima'**
  String get accept;

  /// No description provided for @myBookDetails.
  ///
  /// In id, this message translates to:
  /// **'Detail Buku Saya'**
  String get myBookDetails;

  /// No description provided for @errorLoadingBookDetails.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat detail buku: {error}'**
  String errorLoadingBookDetails(String error);

  /// No description provided for @bookNotFound.
  ///
  /// In id, this message translates to:
  /// **'Buku tidak ditemukan.'**
  String get bookNotFound;

  /// No description provided for @condition.
  ///
  /// In id, this message translates to:
  /// **'Kondisi'**
  String get condition;

  /// No description provided for @lendingStatus.
  ///
  /// In id, this message translates to:
  /// **'Status Peminjaman'**
  String get lendingStatus;

  /// No description provided for @privateCollection.
  ///
  /// In id, this message translates to:
  /// **'Koleksi Privat'**
  String get privateCollection;

  /// No description provided for @borrowHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Peminjaman'**
  String get borrowHistory;

  /// No description provided for @deleteNotSupported.
  ///
  /// In id, this message translates to:
  /// **'Fitur hapus belum didukung oleh backend'**
  String get deleteNotSupported;

  /// No description provided for @removeBook.
  ///
  /// In id, this message translates to:
  /// **'Hapus Buku dari Perpustakaan'**
  String get removeBook;

  /// No description provided for @bookDetailsLoaded.
  ///
  /// In id, this message translates to:
  /// **'Detail buku berhasil dimuat dari API!'**
  String get bookDetailsLoaded;

  /// No description provided for @bookNotFoundInServer.
  ///
  /// In id, this message translates to:
  /// **'Buku tidak ditemukan di server/Google Books.'**
  String get bookNotFoundInServer;

  /// No description provided for @fillInRequiredFields.
  ///
  /// In id, this message translates to:
  /// **'Harap isi ISBN, Judul, dan Penulis.'**
  String get fillInRequiredFields;

  /// No description provided for @bookAddedForCuration.
  ///
  /// In id, this message translates to:
  /// **'\"{title}\" berhasil ditambahkan dan diajukan untuk persetujuan Kurasi Admin (F-01)!'**
  String bookAddedForCuration(String title);

  /// No description provided for @bookAddedPrivate.
  ///
  /// In id, this message translates to:
  /// **'\"{title}\" ditambahkan ke koleksi privat Anda!'**
  String bookAddedPrivate(String title);

  /// No description provided for @addABook.
  ///
  /// In id, this message translates to:
  /// **'Tambah Buku'**
  String get addABook;

  /// No description provided for @addByIsbn.
  ///
  /// In id, this message translates to:
  /// **'Tambah dengan ISBN'**
  String get addByIsbn;

  /// No description provided for @isbnNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor ISBN'**
  String get isbnNumber;

  /// No description provided for @isbnHint.
  ///
  /// In id, this message translates to:
  /// **'contoh: 9781471156267'**
  String get isbnHint;

  /// No description provided for @bookDetails.
  ///
  /// In id, this message translates to:
  /// **'Detail Buku'**
  String get bookDetails;

  /// No description provided for @bookTitleLabel.
  ///
  /// In id, this message translates to:
  /// **'Judul'**
  String get bookTitleLabel;

  /// No description provided for @enterBookTitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan judul buku'**
  String get enterBookTitle;

  /// No description provided for @authorLabel.
  ///
  /// In id, this message translates to:
  /// **'Penulis'**
  String get authorLabel;

  /// No description provided for @enterAuthorName.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama penulis'**
  String get enterAuthorName;

  /// No description provided for @descriptionLabel.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get descriptionLabel;

  /// No description provided for @enterDescription.
  ///
  /// In id, this message translates to:
  /// **'Masukkan sinopsis atau deskripsi singkat'**
  String get enterDescription;

  /// No description provided for @yourCopy.
  ///
  /// In id, this message translates to:
  /// **'Salinan Anda'**
  String get yourCopy;

  /// No description provided for @addBookToLibrary.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan Buku ke Perpustakaan'**
  String get addBookToLibrary;

  /// No description provided for @borrowingDetailsTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Peminjaman'**
  String get borrowingDetailsTitle;

  /// No description provided for @transactionNotFound.
  ///
  /// In id, this message translates to:
  /// **'Transaksi tidak ditemukan'**
  String get transactionNotFound;

  /// No description provided for @transactionInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi Transaksi'**
  String get transactionInfo;

  /// No description provided for @borrowerLabel.
  ///
  /// In id, this message translates to:
  /// **'Peminjam'**
  String get borrowerLabel;

  /// No description provided for @ownerLabel.
  ///
  /// In id, this message translates to:
  /// **'Pemilik Buku'**
  String get ownerLabel;

  /// No description provided for @borrowingDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Peminjaman'**
  String get borrowingDate;

  /// No description provided for @depositAmountLabel.
  ///
  /// In id, this message translates to:
  /// **'Nominal Deposit'**
  String get depositAmountLabel;

  /// No description provided for @borrowingProgress.
  ///
  /// In id, this message translates to:
  /// **'Progres Peminjaman'**
  String get borrowingProgress;

  /// No description provided for @damageReportLabel.
  ///
  /// In id, this message translates to:
  /// **'Laporan Kerusakan'**
  String get damageReportLabel;

  /// No description provided for @depositDeduction.
  ///
  /// In id, this message translates to:
  /// **'Potongan Deposit: Rp {amount}'**
  String depositDeduction(String amount);

  /// No description provided for @waitingOwnerApproval.
  ///
  /// In id, this message translates to:
  /// **'Menunggu persetujuan pemilik buku.'**
  String get waitingOwnerApproval;

  /// No description provided for @approvedUploadDeposit.
  ///
  /// In id, this message translates to:
  /// **'Disetujui! Unggah bukti deposit untuk melanjutkan.'**
  String get approvedUploadDeposit;

  /// No description provided for @uploadDepositProof.
  ///
  /// In id, this message translates to:
  /// **'Unggah Bukti Deposit (Rp 50.000)'**
  String get uploadDepositProof;

  /// No description provided for @depositSent.
  ///
  /// In id, this message translates to:
  /// **'Bukti deposit terkirim.'**
  String get depositSent;

  /// No description provided for @viewDepositProof.
  ///
  /// In id, this message translates to:
  /// **'Lihat Bukti Deposit'**
  String get viewDepositProof;

  /// No description provided for @waitingAdminVerification.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Verifikasi Admin'**
  String get waitingAdminVerification;

  /// No description provided for @depositVerifiedTakeBook.
  ///
  /// In id, this message translates to:
  /// **'Deposit terverifikasi. Ambil buku, lalu konfirmasi.'**
  String get depositVerifiedTakeBook;

  /// No description provided for @confirmBookReceived.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Buku Diterima'**
  String get confirmBookReceived;

  /// No description provided for @bookConfirmedReceived.
  ///
  /// In id, this message translates to:
  /// **'Buku dikonfirmasi diterima.'**
  String get bookConfirmedReceived;

  /// No description provided for @youHoldBook.
  ///
  /// In id, this message translates to:
  /// **'Anda memegang buku ini. Koordinasi pengembalian dengan pemilik.'**
  String get youHoldBook;

  /// No description provided for @currentlyBorrowed.
  ///
  /// In id, this message translates to:
  /// **'Sedang Dipinjam'**
  String get currentlyBorrowed;

  /// No description provided for @bookReturnedGoodWaitingDeposit.
  ///
  /// In id, this message translates to:
  /// **'Buku dikembalikan baik. Menunggu pengembalian deposit.'**
  String get bookReturnedGoodWaitingDeposit;

  /// No description provided for @waitingDepositReturn.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Pengembalian Deposit'**
  String get waitingDepositReturn;

  /// No description provided for @reportedDamagedWaitingAdmin.
  ///
  /// In id, this message translates to:
  /// **'Dilaporkan rusak. Menunggu penyelesaian admin.'**
  String get reportedDamagedWaitingAdmin;

  /// No description provided for @disputeOpened.
  ///
  /// In id, this message translates to:
  /// **'Sengketa Dibuka'**
  String get disputeOpened;

  /// No description provided for @borrowerActions.
  ///
  /// In id, this message translates to:
  /// **'Tindakan Peminjam'**
  String get borrowerActions;

  /// No description provided for @ownerActions.
  ///
  /// In id, this message translates to:
  /// **'Tindakan Pemilik'**
  String get ownerActions;

  /// No description provided for @borrowerHoldsBook.
  ///
  /// In id, this message translates to:
  /// **'Peminjam sedang memegang buku. Saat dikembalikan, konfirmasi kondisinya.'**
  String get borrowerHoldsBook;

  /// No description provided for @confirmReturn.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Pengembalian'**
  String get confirmReturn;

  /// No description provided for @depositConfirmed.
  ///
  /// In id, this message translates to:
  /// **'Deposit dikonfirmasi.'**
  String get depositConfirmed;

  /// No description provided for @confirmDepositAdmin.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Deposit'**
  String get confirmDepositAdmin;

  /// No description provided for @depositReturnedToBorrower.
  ///
  /// In id, this message translates to:
  /// **'Deposit dikembalikan ke peminjam.'**
  String get depositReturnedToBorrower;

  /// No description provided for @returnDepositToBorrower.
  ///
  /// In id, this message translates to:
  /// **'Kembalikan Deposit ke Peminjam'**
  String get returnDepositToBorrower;

  /// No description provided for @settleDamageDispute.
  ///
  /// In id, this message translates to:
  /// **'Selesaikan Sengketa Kerusakan'**
  String get settleDamageDispute;

  /// No description provided for @adminActions.
  ///
  /// In id, this message translates to:
  /// **'Tindakan Admin'**
  String get adminActions;

  /// No description provided for @failedLoadBook.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat detail buku. Periksa koneksi Anda.'**
  String get failedLoadBook;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get retry;

  /// No description provided for @ownerLabelName.
  ///
  /// In id, this message translates to:
  /// **'Pemilik: {name}'**
  String ownerLabelName(String name);

  /// No description provided for @reviewsCount.
  ///
  /// In id, this message translates to:
  /// **'({count} Ulasan)'**
  String reviewsCount(String count);

  /// No description provided for @copyCondition.
  ///
  /// In id, this message translates to:
  /// **'Salinan: {condition}'**
  String copyCondition(String condition);

  /// No description provided for @synopsis.
  ///
  /// In id, this message translates to:
  /// **'Sinopsis'**
  String get synopsis;

  /// No description provided for @thisIsYourOwnBook.
  ///
  /// In id, this message translates to:
  /// **'Ini adalah buku Anda sendiri'**
  String get thisIsYourOwnBook;

  /// No description provided for @bookCurrentlyOnLoan.
  ///
  /// In id, this message translates to:
  /// **'Buku sedang dipinjam'**
  String get bookCurrentlyOnLoan;

  /// No description provided for @finishActiveBorrowing.
  ///
  /// In id, this message translates to:
  /// **'Selesaikan peminjaman aktif Anda sebelum meminta yang lain.'**
  String get finishActiveBorrowing;

  /// No description provided for @borrowBook.
  ///
  /// In id, this message translates to:
  /// **'Pinjam Buku'**
  String get borrowBook;

  /// No description provided for @waitingForLenderApproval.
  ///
  /// In id, this message translates to:
  /// **'Menunggu persetujuan Pemilik...'**
  String get waitingForLenderApproval;

  /// No description provided for @requestedStatus.
  ///
  /// In id, this message translates to:
  /// **'Diminta'**
  String get requestedStatus;

  /// No description provided for @lenderApprovedPayDeposit.
  ///
  /// In id, this message translates to:
  /// **'Pemilik menyetujui! Silakan bayar deposit.'**
  String get lenderApprovedPayDeposit;

  /// No description provided for @uploadDepositProofRp.
  ///
  /// In id, this message translates to:
  /// **'Unggah Bukti Deposit (Rp. 50.000)'**
  String get uploadDepositProofRp;

  /// No description provided for @depositProofSubmitted.
  ///
  /// In id, this message translates to:
  /// **'Bukti deposit dikirim.'**
  String get depositProofSubmitted;

  /// No description provided for @depositVerifiedMeetOwner.
  ///
  /// In id, this message translates to:
  /// **'Deposit terverifikasi. Temui pemilik dan ambil buku.'**
  String get depositVerifiedMeetOwner;

  /// No description provided for @bookStatusUpdatedBorrowed.
  ///
  /// In id, this message translates to:
  /// **'Status buku diperbarui: Sedang Dipinjam.'**
  String get bookStatusUpdatedBorrowed;

  /// No description provided for @youHaveThisBook.
  ///
  /// In id, this message translates to:
  /// **'Anda memegang buku ini. Koordinasikan pengembalian; pemilik akan mengonfirmasi kondisinya.'**
  String get youHaveThisBook;

  /// No description provided for @onLoanText.
  ///
  /// In id, this message translates to:
  /// **'Sedang Dipinjam'**
  String get onLoanText;

  /// No description provided for @returnedGoodWaitingRefund.
  ///
  /// In id, this message translates to:
  /// **'Dikembalikan Baik - Menunggu Pengembalian Dana'**
  String get returnedGoodWaitingRefund;

  /// No description provided for @returnedDamagedDisputeOpen.
  ///
  /// In id, this message translates to:
  /// **'Dikembalikan Rusak - Sengketa Terbuka'**
  String get returnedDamagedDisputeOpen;

  /// No description provided for @errorLoadingBookName.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat buku: {e}'**
  String errorLoadingBookName(String e);

  /// No description provided for @selectBothDates.
  ///
  /// In id, this message translates to:
  /// **'Harap pilih tanggal Pengambilan dan Pengembalian.'**
  String get selectBothDates;

  /// No description provided for @returnDateAfterPickup.
  ///
  /// In id, this message translates to:
  /// **'Tanggal pengembalian harus setelah tanggal pengambilan.'**
  String get returnDateAfterPickup;

  /// No description provided for @borrowRequestSubmitted.
  ///
  /// In id, this message translates to:
  /// **'Permintaan peminjaman berhasil dikirim!'**
  String get borrowRequestSubmitted;

  /// No description provided for @requestFailed.
  ///
  /// In id, this message translates to:
  /// **'Permintaan Gagal'**
  String get requestFailed;

  /// No description provided for @okText.
  ///
  /// In id, this message translates to:
  /// **'OK'**
  String get okText;

  /// No description provided for @selectDateText.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal'**
  String get selectDateText;

  /// No description provided for @requestToBorrow.
  ///
  /// In id, this message translates to:
  /// **'Ajukan Peminjaman'**
  String get requestToBorrow;

  /// No description provided for @lenderLabel.
  ///
  /// In id, this message translates to:
  /// **'Pemilik'**
  String get lenderLabel;

  /// No description provided for @pickupDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Pengambilan'**
  String get pickupDate;

  /// No description provided for @returnDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Pengembalian'**
  String get returnDate;

  /// No description provided for @messageToLender.
  ///
  /// In id, this message translates to:
  /// **'Pesan untuk Pemilik (Opsional)'**
  String get messageToLender;

  /// No description provided for @messageToLenderHint.
  ///
  /// In id, this message translates to:
  /// **'Hai, saya ingin meminjam buku ini...'**
  String get messageToLenderHint;

  /// No description provided for @sendRequest.
  ///
  /// In id, this message translates to:
  /// **'Kirim Permintaan'**
  String get sendRequest;

  /// No description provided for @notificationsTitle.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notificationsTitle;

  /// No description provided for @noNotifications.
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Notifikasi'**
  String get noNotifications;

  /// No description provided for @noNotificationsCurrentRole.
  ///
  /// In id, this message translates to:
  /// **'Anda tidak memiliki notifikasi pada peran Anda saat ini.'**
  String get noNotificationsCurrentRole;

  /// No description provided for @declineLabel.
  ///
  /// In id, this message translates to:
  /// **'Tolak'**
  String get declineLabel;

  /// No description provided for @acceptLabel.
  ///
  /// In id, this message translates to:
  /// **'Terima'**
  String get acceptLabel;

  /// No description provided for @borrowRequestDeclined.
  ///
  /// In id, this message translates to:
  /// **'Permintaan peminjaman ditolak.'**
  String get borrowRequestDeclined;

  /// No description provided for @borrowRequestAccepted.
  ///
  /// In id, this message translates to:
  /// **'Permintaan peminjaman diterima (F-02)! Deep-link ke WA disimulasikan.'**
  String get borrowRequestAccepted;

  /// No description provided for @rejectPayment.
  ///
  /// In id, this message translates to:
  /// **'Tolak Pembayaran'**
  String get rejectPayment;

  /// No description provided for @verifyPayment.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi Pembayaran'**
  String get verifyPayment;

  /// No description provided for @paymentRejected.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran ditolak.'**
  String get paymentRejected;

  /// No description provided for @paymentVerified.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran terverifikasi! Status deposit berubah menjadi DIBAYAR (F-02).'**
  String get paymentVerified;

  /// No description provided for @reportedDamageLabel.
  ///
  /// In id, this message translates to:
  /// **'Laporan Kerusakan: {description}'**
  String reportedDamageLabel(String description);

  /// No description provided for @resolveDisputeRefund.
  ///
  /// In id, this message translates to:
  /// **'Selesaikan Sengketa & Kembalikan Dana'**
  String get resolveDisputeRefund;

  /// No description provided for @goodAfternoonSiang.
  ///
  /// In id, this message translates to:
  /// **'Selamat siang,'**
  String get goodAfternoonSiang;

  /// No description provided for @goodAfternoonSore.
  ///
  /// In id, this message translates to:
  /// **'Selamat sore,'**
  String get goodAfternoonSore;

  /// No description provided for @goodEvening.
  ///
  /// In id, this message translates to:
  /// **'Selamat malam,'**
  String get goodEvening;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
