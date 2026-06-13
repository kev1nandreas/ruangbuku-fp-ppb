// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ruangBuku => 'RuangBuku';

  @override
  String get home => 'Home';

  @override
  String get findBook => 'Find Book';

  @override
  String get curation => 'Curation';

  @override
  String get yourBooks => 'Your Books';

  @override
  String get borrowing => 'Borrowing';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get indonesia => 'Indonesian';

  @override
  String get english => 'English';

  @override
  String get authHeaderTagline => 'Share books, expand your horizons.';

  @override
  String get login => 'Login';

  @override
  String get loginSubtitle => 'Please login to continue';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get emailEmptyError => 'Email cannot be empty';

  @override
  String get emailInvalidError => 'Invalid email format';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordEmptyError => 'Password cannot be empty';

  @override
  String get passwordLengthError => 'Password must be at least 8 characters';

  @override
  String get noAccountPrompt => 'Don\'t have an account? ';

  @override
  String get register => 'Register';

  @override
  String get registerSubtitle => 'Create an account to start borrowing books';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'Enter your name';

  @override
  String get nameEmptyError => 'Name cannot be empty';

  @override
  String get nameLengthError => 'Name must be at least 3 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get confirmPasswordEmptyError => 'Confirm password cannot be empty';

  @override
  String get confirmPasswordMatchError => 'Passwords do not match';

  @override
  String get hasAccountPrompt => 'Already have an account? ';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get contactSupport => 'Choose how you would like to contact us:';

  @override
  String get emailContact => 'Email';

  @override
  String get whatsappContact => 'WhatsApp';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get paymentInfo => 'Payment Information';

  @override
  String get paymentDesc =>
      'Use the following details to verify deposit payments or transfer funds.';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get eWallet => 'E-Wallet';

  @override
  String get owned => 'Owned';

  @override
  String get borrowed => 'Borrowed';

  @override
  String get lent => 'Lent';

  @override
  String get addNewMethod => 'Add New Method';

  @override
  String get logoutTitle => 'Logout from Account';

  @override
  String get logoutDesc =>
      'Are you sure you want to log out? You will need to log in again to access your account.';

  @override
  String get goodMorning => 'Good morning,';

  @override
  String get findNextRead => 'Find your next read from your community library.';

  @override
  String get searchBooks => 'Search books or neighbors...';

  @override
  String get popularNearYou => 'Popular Near You';

  @override
  String get seeAll => 'See all';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String noBooksFound(String query) {
    return 'No books found matching \"$query\"';
  }

  @override
  String get allCategories => 'All Categories';

  @override
  String get availableNow => 'Available Now';

  @override
  String get within5km => 'Within 5km';

  @override
  String booksFound(String count) {
    return '$count Books Found';
  }

  @override
  String get sortDistance => 'Sort by Distance';

  @override
  String get onLoan => 'On Loan';

  @override
  String get available => 'Available';

  @override
  String kmAway(String distance) {
    return '$distance km away';
  }

  @override
  String get pendingApproval => 'Pending Approval';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get addBook => 'Add Book';

  @override
  String addedBy(String name) {
    return 'Added by $name';
  }

  @override
  String get adminCuration => 'Admin Curation';

  @override
  String get allCaughtUp => 'All Caught Up!';

  @override
  String get noBooksAwaitingCuration =>
      'There are no books awaiting curation approval right now.';

  @override
  String get yourLibraryEmpty => 'Your library is empty';

  @override
  String get haventAddedBooks =>
      'You haven\'t added any books yet. Click the \"+\" button below to register a book (F-01)!';

  @override
  String get rejected => 'Rejected';

  @override
  String get privateBook => 'Private';

  @override
  String get deleteConfirmTitle => 'Do you want to delete your book?';

  @override
  String deleteConfirmMsg(String title) {
    return 'Please enter \"$title\" to confirm.';
  }

  @override
  String get bookRemoved => 'Book removed from library';

  @override
  String get borrowings => 'Borrowings';

  @override
  String get noTransactions => 'No Transactions Yet';

  @override
  String get noTransactionsMsg => 'You have no book borrowing transactions.';

  @override
  String get incomingRequests => 'Incoming Requests';

  @override
  String get yourTransactions => 'Your Transactions';

  @override
  String borrowerName(String name) {
    return 'Borrower: $name';
  }

  @override
  String ownerName(String name) {
    return 'Owner: $name';
  }

  @override
  String get statusRequested => 'Awaiting Confirmation';

  @override
  String get statusWaitingDeposit => 'Awaiting Deposit';

  @override
  String get statusDepositUploaded => 'Verifying Deposit';

  @override
  String get statusDepositVerified => 'Deposit Verified';

  @override
  String get statusBookReceived => 'Book Received';

  @override
  String get statusReturnedGood => 'Returned in Good Condition';

  @override
  String get statusReturnedDamaged => 'Returned Damaged';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled/Rejected';

  @override
  String get requestAccepted => 'Request accepted.';

  @override
  String get requestRejected => 'Request rejected.';

  @override
  String failed(String error) {
    return 'Failed: $error';
  }

  @override
  String get reject => 'Reject';

  @override
  String get accept => 'Accept';

  @override
  String get myBookDetails => 'My Book Details';

  @override
  String errorLoadingBookDetails(String error) {
    return 'Error loading book details: $error';
  }

  @override
  String get bookNotFound => 'Book not found.';

  @override
  String get condition => 'Condition';

  @override
  String get lendingStatus => 'Lending Status';

  @override
  String get privateCollection => 'Private Collection';

  @override
  String get borrowHistory => 'Borrow History';

  @override
  String get deleteNotSupported =>
      'Delete feature not supported by backend yet';

  @override
  String get removeBook => 'Remove Book from Library';

  @override
  String get bookDetailsLoaded => 'Book details successfully loaded from API!';

  @override
  String get bookNotFoundInServer => 'Book not found on server/Google Books.';

  @override
  String get fillInRequiredFields => 'Please fill in ISBN, Title, and Author.';

  @override
  String bookAddedForCuration(String title) {
    return '\"$title\" added and submitted for Admin Curation approval (F-01)!';
  }

  @override
  String bookAddedPrivate(String title) {
    return '\"$title\" added to your private collection!';
  }

  @override
  String get addABook => 'Add a Book';

  @override
  String get addByIsbn => 'Add by ISBN';

  @override
  String get isbnNumber => 'ISBN Number';

  @override
  String get isbnHint => 'e.g., 9781471156267';

  @override
  String get bookDetails => 'Book Details';

  @override
  String get bookTitleLabel => 'Title';

  @override
  String get enterBookTitle => 'Enter book title';

  @override
  String get authorLabel => 'Author';

  @override
  String get enterAuthorName => 'Enter author name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get enterDescription => 'Enter synopsis or short description';

  @override
  String get yourCopy => 'Your Copy';

  @override
  String get addBookToLibrary => 'Add Book to Library';

  @override
  String get borrowingDetailsTitle => 'Borrowing Details';

  @override
  String get transactionNotFound => 'Transaction not found';

  @override
  String get transactionInfo => 'Transaction Information';

  @override
  String get borrowerLabel => 'Borrower';

  @override
  String get ownerLabel => 'Book Owner';

  @override
  String get borrowingDate => 'Borrowing Date';

  @override
  String get depositAmountLabel => 'Deposit Amount';

  @override
  String get borrowingProgress => 'Borrowing Progress';

  @override
  String get damageReportLabel => 'Damage Report';

  @override
  String depositDeduction(String amount) {
    return 'Deposit Deduction: Rp $amount';
  }

  @override
  String get waitingOwnerApproval => 'Awaiting book owner\'s approval.';

  @override
  String get approvedUploadDeposit =>
      'Approved! Upload deposit proof to continue.';

  @override
  String get uploadDepositProof => 'Upload Deposit Proof (Rp 50.000)';

  @override
  String get depositSent => 'Deposit proof sent.';

  @override
  String get viewDepositProof => 'View Deposit Proof';

  @override
  String get waitingAdminVerification => 'Awaiting Admin Verification';

  @override
  String get depositVerifiedTakeBook =>
      'Deposit verified. Take the book, then confirm.';

  @override
  String get confirmBookReceived => 'Confirm Book Received';

  @override
  String get bookConfirmedReceived => 'Book confirmed received.';

  @override
  String get youHoldBook =>
      'You are holding this book. Coordinate return with owner.';

  @override
  String get currentlyBorrowed => 'Currently Borrowed';

  @override
  String get bookReturnedGoodWaitingDeposit =>
      'Book returned in good condition. Awaiting deposit return.';

  @override
  String get waitingDepositReturn => 'Awaiting Deposit Return';

  @override
  String get reportedDamagedWaitingAdmin =>
      'Reported damaged. Awaiting admin settlement.';

  @override
  String get disputeOpened => 'Dispute Opened';

  @override
  String get borrowerActions => 'Borrower Actions';

  @override
  String get ownerActions => 'Owner Actions';

  @override
  String get borrowerHoldsBook =>
      'Borrower is holding the book. Upon return, confirm its condition.';

  @override
  String get confirmReturn => 'Confirm Return';

  @override
  String get depositConfirmed => 'Deposit confirmed.';

  @override
  String get confirmDepositAdmin => 'Confirm Deposit';

  @override
  String get depositReturnedToBorrower => 'Deposit returned to borrower.';

  @override
  String get returnDepositToBorrower => 'Return Deposit to Borrower';

  @override
  String get settleDamageDispute => 'Settle Damage Dispute';

  @override
  String get adminActions => 'Admin Actions';

  @override
  String get failedLoadBook =>
      'Failed to load book detail. Check your connection.';

  @override
  String get retry => 'Retry';

  @override
  String ownerLabelName(String name) {
    return 'Owner: $name';
  }

  @override
  String reviewsCount(String count) {
    return '($count Reviews)';
  }

  @override
  String copyCondition(String condition) {
    return 'Copy: $condition';
  }

  @override
  String get synopsis => 'Synopsis';

  @override
  String get thisIsYourOwnBook => 'This is your own book';

  @override
  String get bookCurrentlyOnLoan => 'Book Currently on Loan';

  @override
  String get finishActiveBorrowing =>
      'Finish your active borrowing before requesting another.';

  @override
  String get borrowBook => 'Borrow Book';

  @override
  String get waitingForLenderApproval => 'Waiting for Lender approval...';

  @override
  String get requestedStatus => 'Requested';

  @override
  String get lenderApprovedPayDeposit =>
      'Lender approved! Please pay the deposit.';

  @override
  String get uploadDepositProofRp => 'Upload Deposit Proof (Rp. 50,000)';

  @override
  String get depositProofSubmitted => 'Deposit proof submitted.';

  @override
  String get depositVerifiedMeetOwner =>
      'Deposit verified. Meet owner and pick up book.';

  @override
  String get bookStatusUpdatedBorrowed =>
      'Book status updated: Sedang Dipinjam.';

  @override
  String get youHaveThisBook =>
      'You have this book. Coordinate the return; the owner confirms its condition.';

  @override
  String get onLoanText => 'On Loan';

  @override
  String get returnedGoodWaitingRefund => 'Returned Good - Waiting Refund';

  @override
  String get returnedDamagedDisputeOpen => 'Returned Damaged - Dispute Open';

  @override
  String errorLoadingBookName(String e) {
    return 'Error loading book: $e';
  }

  @override
  String get selectBothDates => 'Please select both Pickup and Return dates.';

  @override
  String get returnDateAfterPickup => 'Return date must be after pickup date.';

  @override
  String get borrowRequestSubmitted =>
      'Borrowing request submitted successfully!';

  @override
  String get requestFailed => 'Request Failed';

  @override
  String get okText => 'OK';

  @override
  String get selectDateText => 'Select date';

  @override
  String get requestToBorrow => 'Request to Borrow';

  @override
  String get lenderLabel => 'Lender';

  @override
  String get pickupDate => 'Pickup Date';

  @override
  String get returnDate => 'Return Date';

  @override
  String get messageToLender => 'Message to Lender (Optional)';

  @override
  String get messageToLenderHint => 'Hi, I would love to borrow this book...';

  @override
  String get sendRequest => 'Send Request';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get noNotificationsCurrentRole =>
      'You have no notifications in your current role.';

  @override
  String get declineLabel => 'Decline';

  @override
  String get acceptLabel => 'Accept';

  @override
  String get borrowRequestDeclined => 'Borrow request declined.';

  @override
  String get borrowRequestAccepted =>
      'Borrow request accepted (F-02)! Deep-link to WA simulated.';

  @override
  String get rejectPayment => 'Reject Payment';

  @override
  String get verifyPayment => 'Verify Payment';

  @override
  String get paymentRejected => 'Payment rejected.';

  @override
  String get paymentVerified =>
      'Payment verified! Deposit status changed to PAID (F-02).';

  @override
  String reportedDamageLabel(String description) {
    return 'Reported Damage: $description';
  }

  @override
  String get resolveDisputeRefund => 'Resolve Dispute & Refund';

  @override
  String get goodAfternoonSiang => 'Good afternoon,';

  @override
  String get goodAfternoonSore => 'Good afternoon,';

  @override
  String get goodEvening => 'Good evening,';
}
