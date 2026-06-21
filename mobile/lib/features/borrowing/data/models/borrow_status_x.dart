import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'borrow_model.dart';

/// UI helpers for [BorrowStatus]. Centralized here so the label and color of a
/// status are defined once and reused by every screen that renders a borrow
/// (detail, lists, admin transactions) instead of being copy-pasted.
extension BorrowStatusX on BorrowStatus {
  /// Localized human-readable label, falling back to Indonesian defaults.
  String label(AppLocalizations? l10n) {
    switch (this) {
      case BorrowStatus.requested:
        return l10n?.statusRequested ?? 'Menunggu Konfirmasi';
      case BorrowStatus.waitingDeposit:
        return l10n?.statusWaitingDeposit ?? 'Menunggu Deposit';
      case BorrowStatus.depositUploaded:
        return l10n?.statusDepositUploaded ?? 'Verifikasi Deposit';
      case BorrowStatus.depositVerified:
        return l10n?.statusDepositVerified ?? 'Deposit Terverifikasi';
      case BorrowStatus.bookReceived:
        return l10n?.statusBookReceived ?? 'Buku Diterima';
      case BorrowStatus.returnedGood:
        return l10n?.statusReturnedGood ?? 'Dikembalikan Baik';
      case BorrowStatus.returnedDamaged:
        return l10n?.statusReturnedDamaged ?? 'Dikembalikan Rusak';
      case BorrowStatus.completed:
        return l10n?.statusCompleted ?? 'Selesai';
      case BorrowStatus.cancelled:
        return l10n?.statusCancelled ?? 'Dibatalkan/Ditolak';
    }
  }

  /// Accent color used for status chips/badges.
  Color get color {
    switch (this) {
      case BorrowStatus.requested:
      case BorrowStatus.waitingDeposit:
      case BorrowStatus.depositUploaded:
        return Colors.orange;
      case BorrowStatus.depositVerified:
      case BorrowStatus.bookReceived:
      case BorrowStatus.returnedGood:
      case BorrowStatus.completed:
        return Colors.green;
      case BorrowStatus.returnedDamaged:
      case BorrowStatus.cancelled:
        return Colors.red;
    }
  }
}
