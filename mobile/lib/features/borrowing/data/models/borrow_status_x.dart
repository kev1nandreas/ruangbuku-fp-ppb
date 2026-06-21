import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
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

  /// Accent color (fill / icon) for status chips and badges. Tuned to sit
  /// inside the Matcha + Terracotta palette instead of raw Material colors.
  Color get color {
    switch (this) {
      case BorrowStatus.requested:
      case BorrowStatus.waitingDeposit:
      case BorrowStatus.depositUploaded:
        return RuangBukuColors.statusPending;
      case BorrowStatus.depositVerified:
      case BorrowStatus.bookReceived:
      case BorrowStatus.returnedGood:
      case BorrowStatus.completed:
        return RuangBukuColors.statusActive;
      case BorrowStatus.returnedDamaged:
      case BorrowStatus.cancelled:
        return RuangBukuColors.statusDanger;
    }
  }

  /// Darker variant of [color] for chip/badge *text*, so small labels stay
  /// legible on the translucent fill (the fill color itself is too light).
  Color get textColor {
    switch (this) {
      case BorrowStatus.requested:
      case BorrowStatus.waitingDeposit:
      case BorrowStatus.depositUploaded:
        return RuangBukuColors.statusPendingText;
      case BorrowStatus.depositVerified:
      case BorrowStatus.bookReceived:
      case BorrowStatus.returnedGood:
      case BorrowStatus.completed:
        return RuangBukuColors.statusActiveText;
      case BorrowStatus.returnedDamaged:
      case BorrowStatus.cancelled:
        return RuangBukuColors.statusDangerText;
    }
  }

  /// Soft tinted background for chips/badges.
  Color get chipBackground => color.withValues(alpha: 0.14);

  /// Brightness-aware label color for chips/badges. On light surfaces the dark
  /// [textColor] gives strong contrast; on dark surfaces that same dark tone
  /// would disappear, so the lighter [color] is used against the tinted fill.
  Color labelColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? color : textColor;
}
