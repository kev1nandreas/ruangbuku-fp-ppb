import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// RuangBuku — Theme Blueprint (Single Source of Truth)
// =============================================================================
// This file defines the complete visual identity for the RuangBuku app.
// ALL screens MUST consume these tokens exclusively via Theme.of(context).
// Direct hard-coding of colors, sizes, or paddings in screen files is FORBIDDEN.
// =============================================================================

// ─────────────────────────────────────────────────────────────────────────────
// 1. COLOR PALETTE — Modern Aesthetic Library
// ─────────────────────────────────────────────────────────────────────────────

class RuangBukuColors {
  RuangBukuColors._();

  // ── Core Palette ──────────────────────────────────────────────────────────
  /// Background / Surface — Off-White / Soft Linen
  static const Color surface = Color(0xFFF8F9FA);

  /// Primary (Brand, Headers, Active Nav) — Matcha / Olive Green
  static const Color primary = Color(0xFF8FA88B);

  /// Accent (Action Buttons: 'Borrow', Bookmarks) — Muted Terracotta / Peach Clay
  static const Color accent = Color(0xFFE29578);

  /// Typography (Titles, Body Text) — Deep Navy / Charcoal
  static const Color textPrimary = Color(0xFF212529);

  /// Typography — Alternate deeper navy variant
  static const Color textDeep = Color(0xFF1A2530);

  // ── Derived / Supporting Colors ───────────────────────────────────────────
  /// On-primary text (white on Matcha Green)
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// On-accent text (white on Terracotta)
  static const Color onAccent = Color(0xFFFFFFFF);

  /// Card surface — pure white to pop against off-white background
  static const Color cardSurface = Color(0xFFFFFFFF);

  /// Surface container low — subtle differentiation layer
  static const Color surfaceContainerLow = Color(0xFFF4F3F2);

  /// Surface container — medium differentiation
  static const Color surfaceContainer = Color(0xFFEEEEED);

  /// Surface container high — strong differentiation
  static const Color surfaceContainerHigh = Color(0xFFE9E8E7);

  /// Outline — for borders, dividers
  static const Color outline = Color(0xFF75777E);

  /// Outline variant — lighter borders
  static const Color outlineVariant = Color(0xFFC5C6CE);

  /// On-surface variant — secondary text, captions
  static const Color textSecondary = Color(0xFF44474D);

  /// Inverse surface — dark overlays, bottom sheets
  static const Color inverseSurface = Color(0xFF2F3130);

  /// Inverse on-surface — text on dark overlays
  static const Color inverseOnSurface = Color(0xFFF1F0F0);

  /// Error
  static const Color error = Color(0xFFBA1A1A);

  /// On-error
  static const Color onError = Color(0xFFFFFFFF);

  /// Error container
  static const Color errorContainer = Color(0xFFFFDAD6);

  /// Success / Available status — Soft Sage
  static const Color success = Color(0xFF6FCF97);

  /// On Loan / Neutral status chip
  static const Color neutralChip = Color(0xFF9E9E9E);

  /// Primary at 10% opacity — used for input field borders
  static const Color primaryBorder10 = Color(0x1A8FA88B);

  /// Shadow tint — primary-tinted shadow at 5-8% opacity
  static const Color shadowTint = Color(0x0D212529);

  /// Divider color
  static const Color divider = Color(0xFFE0E0E0);
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. SPACING TOKENS — 4px Baseline Grid
// ─────────────────────────────────────────────────────────────────────────────

class RuangBukuSpacing {
  RuangBukuSpacing._();

  /// Baseline unit
  static const double unit = 4.0;

  /// 4px — extra-small
  static const double xs = 4.0;

  /// 8px — stack-sm: related elements (title + author)
  static const double sm = 8.0;

  /// 12px — intermediate
  static const double md = 12.0;

  /// 16px — stack-md: distinct components within a section / gutter
  static const double lg = 16.0;

  /// 20px — mobile side margin
  static const double marginMobile = 20.0;

  /// 24px — stack-lg: separating major layout blocks
  static const double xl = 24.0;

  /// 32px — extra-large
  static const double xxl = 32.0;

  /// 40px
  static const double xxxl = 40.0;

  /// 48px
  static const double huge = 48.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. SHAPE / RADIUS TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class RuangBukuRadius {
  RuangBukuRadius._();

  /// 4px — sm: small elements, tags
  static const double sm = 4.0;

  /// 8px — DEFAULT: book cover images, small cards
  static const double base = 8.0;

  /// 12px — md: medium rounding
  static const double md = 12.0;

  /// 16px — lg: standard cards, input fields (base radius per DESIGN.md)
  static const double lg = 16.0;

  /// 24px — xl: larger containers, modals
  static const double xl = 24.0;

  /// 9999px — full pill shape: status chips, search bar, FAB
  static const double full = 9999.0;

  // Pre-built BorderRadius for convenience
  static final BorderRadius borderRadiusSm = BorderRadius.circular(sm);
  static final BorderRadius borderRadiusBase = BorderRadius.circular(base);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(md);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(lg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(xl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(full);
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. ELEVATION / SHADOW TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class RuangBukuElevation {
  RuangBukuElevation._();

  /// Level 0 — base background, no shadow
  static const List<BoxShadow> level0 = [];

  /// Level 1 — cards, book listings (4px blur, 5-8% tinted shadow)
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: RuangBukuColors.shadowTint,
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  /// Level 2 — modals, overlays, bottom sheets (12px blur)
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: RuangBukuColors.shadowTint,
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];

  /// Level 3 — FAB, highest priority elements (16px blur)
  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: RuangBukuColors.shadowTint,
      blurRadius: 16.0,
      offset: Offset(0, 6),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. TYPOGRAPHY — Literata (Headings) + Inter (Body/UI)
// ─────────────────────────────────────────────────────────────────────────────

class RuangBukuTypography {
  RuangBukuTypography._();

  /// Display Large — 32px, Literata Bold
  static TextStyle get displayLarge => GoogleFonts.literata(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32, // lineHeight: 40px
        letterSpacing: -0.02 * 32, // -0.02em
        color: RuangBukuColors.textPrimary,
      );

  /// Display Large Mobile — 28px, Literata Bold
  static TextStyle get displayLargeMobile => GoogleFonts.literata(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 36 / 28, // lineHeight: 36px
        color: RuangBukuColors.textPrimary,
      );

  /// Headline Medium — 24px, Literata SemiBold
  static TextStyle get headlineMedium => GoogleFonts.literata(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24, // lineHeight: 32px
        color: RuangBukuColors.textPrimary,
      );

  /// Headline Small — 20px, Literata SemiBold
  static TextStyle get headlineSmall => GoogleFonts.literata(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20, // lineHeight: 28px
        color: RuangBukuColors.textPrimary,
      );

  /// Title Large — 18px, Literata SemiBold (supplemental for sub-headings)
  static TextStyle get titleLarge => GoogleFonts.literata(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: RuangBukuColors.textPrimary,
      );

  /// Title Medium — 16px, Inter Medium
  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        color: RuangBukuColors.textPrimary,
      );

  /// Title Small — 14px, Inter Medium
  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: RuangBukuColors.textPrimary,
      );

  /// Body Large — 16px, Inter Regular
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16, // lineHeight: 24px
        color: RuangBukuColors.textPrimary,
      );

  /// Body Medium — 14px, Inter Regular
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14, // lineHeight: 20px
        color: RuangBukuColors.textPrimary,
      );

  /// Body Small — 12px, Inter Regular (supplemental)
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: RuangBukuColors.textSecondary,
      );

  /// Label Large — 14px, Inter SemiBold (buttons, prominent labels)
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: RuangBukuColors.textPrimary,
      );

  /// Label Medium — 12px, Inter SemiBold (label-bold from DESIGN.md)
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12, // lineHeight: 16px
        letterSpacing: 0.05 * 12, // 0.05em
        color: RuangBukuColors.textPrimary,
      );

  /// Label Small — 10px, Inter Medium (smallest annotations)
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 14 / 10,
        letterSpacing: 0.04 * 10,
        color: RuangBukuColors.textSecondary,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. THEME DATA — Complete Material 3 ThemeData
// ─────────────────────────────────────────────────────────────────────────────

class RuangBukuTheme {
  RuangBukuTheme._();

  // ── Color Scheme ──────────────────────────────────────────────────────────
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    // Core
    primary: RuangBukuColors.primary,
    onPrimary: RuangBukuColors.onPrimary,
    primaryContainer: RuangBukuColors.primary,
    onPrimaryContainer: RuangBukuColors.onPrimary,
    // Secondary = Accent (Terracotta)
    secondary: RuangBukuColors.accent,
    onSecondary: RuangBukuColors.onAccent,
    secondaryContainer: RuangBukuColors.accent,
    onSecondaryContainer: RuangBukuColors.onAccent,
    // Tertiary = Success (Soft Sage)
    tertiary: RuangBukuColors.success,
    onTertiary: RuangBukuColors.onPrimary,
    // Surface & Background
    surface: RuangBukuColors.surface,
    onSurface: RuangBukuColors.textPrimary,
    onSurfaceVariant: RuangBukuColors.textSecondary,
    surfaceContainerLowest: RuangBukuColors.cardSurface,
    surfaceContainerLow: RuangBukuColors.surfaceContainerLow,
    surfaceContainer: RuangBukuColors.surfaceContainer,
    surfaceContainerHigh: RuangBukuColors.surfaceContainerHigh,
    // Outlines
    outline: RuangBukuColors.outline,
    outlineVariant: RuangBukuColors.outlineVariant,
    // Inverse
    inverseSurface: RuangBukuColors.inverseSurface,
    onInverseSurface: RuangBukuColors.inverseOnSurface,
    inversePrimary: RuangBukuColors.primary,
    // Error
    error: RuangBukuColors.error,
    onError: RuangBukuColors.onError,
    errorContainer: RuangBukuColors.errorContainer,
    onErrorContainer: RuangBukuColors.error,
    // Shadow
    shadow: RuangBukuColors.shadowTint,
  );

  // ── Text Theme ────────────────────────────────────────────────────────────
  static final TextTheme _textTheme = TextTheme(
    displayLarge: RuangBukuTypography.displayLarge,
    displayMedium: RuangBukuTypography.displayLargeMobile,
    displaySmall: RuangBukuTypography.headlineMedium,
    headlineLarge: RuangBukuTypography.displayLargeMobile,
    headlineMedium: RuangBukuTypography.headlineMedium,
    headlineSmall: RuangBukuTypography.headlineSmall,
    titleLarge: RuangBukuTypography.titleLarge,
    titleMedium: RuangBukuTypography.titleMedium,
    titleSmall: RuangBukuTypography.titleSmall,
    bodyLarge: RuangBukuTypography.bodyLarge,
    bodyMedium: RuangBukuTypography.bodyMedium,
    bodySmall: RuangBukuTypography.bodySmall,
    labelLarge: RuangBukuTypography.labelLarge,
    labelMedium: RuangBukuTypography.labelMedium,
    labelSmall: RuangBukuTypography.labelSmall,
  );

  // ── Component Themes ─────────────────────────────────────────────────────

  /// AppBar — transparent/surface background, Literata title
  static final AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: RuangBukuColors.surface,
    foregroundColor: RuangBukuColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    centerTitle: true,
    titleTextStyle: GoogleFonts.literata(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: RuangBukuColors.textPrimary,
    ),
    iconTheme: const IconThemeData(
      color: RuangBukuColors.textPrimary,
      size: 24,
    ),
  );

  /// Elevated Button — Primary action (Matcha Green) with white text
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RuangBukuColors.primary,
      foregroundColor: RuangBukuColors.onPrimary,
      disabledBackgroundColor: RuangBukuColors.primary.withValues(alpha: 0.38),
      disabledForegroundColor:
          RuangBukuColors.onPrimary.withValues(alpha: 0.38),
      elevation: 0,
      shadowColor: RuangBukuColors.shadowTint,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.xl,
        vertical: RuangBukuSpacing.lg,
      ),
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusLg,
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
    ),
  );

  /// Filled Button — Accent action (Terracotta) for 'Borrow', warm CTAs
  static final FilledButtonThemeData _filledButtonTheme =
      FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: RuangBukuColors.accent,
      foregroundColor: RuangBukuColors.onAccent,
      disabledBackgroundColor: RuangBukuColors.accent.withValues(alpha: 0.38),
      disabledForegroundColor:
          RuangBukuColors.onAccent.withValues(alpha: 0.38),
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.xl,
        vertical: RuangBukuSpacing.lg,
      ),
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusLg,
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
    ),
  );

  /// Outlined Button — Secondary action with 1.5px stroke (per DESIGN.md)
  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: RuangBukuColors.textPrimary,
      side: const BorderSide(
        color: RuangBukuColors.outlineVariant,
        width: 1.5,
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.xl,
        vertical: RuangBukuSpacing.lg,
      ),
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusLg,
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
    ),
  );

  /// Text Button — Tertiary / inline actions
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: RuangBukuColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.lg,
        vertical: RuangBukuSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusSm,
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
      ),
    ),
  );

  /// Card — White surface with subtle tinted shadow (Level 1 elevation)
  static const CardThemeData _cardTheme = CardThemeData(
    color: RuangBukuColors.cardSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0, // We use custom BoxShadow for tinted shadows
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    clipBehavior: Clip.antiAlias,
  );

  /// Input Decoration — 16px rounded corners, light border, focus transitions
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: RuangBukuColors.cardSurface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: RuangBukuSpacing.lg,
      vertical: RuangBukuSpacing.lg,
    ),
    // Default border — light, subtle
    border: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: BorderSide(
        color: RuangBukuColors.outlineVariant.withValues(alpha: 0.5),
        width: 1.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: BorderSide(
        color: RuangBukuColors.outlineVariant.withValues(alpha: 0.5),
        width: 1.0,
      ),
    ),
    // Focus border — 2px primary stroke (per DESIGN.md)
    focusedBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuColors.primary,
        width: 2.0,
      ),
    ),
    // Error border
    errorBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuColors.error,
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuColors.error,
        width: 2.0,
      ),
    ),
    // Typography
    hintStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: RuangBukuColors.textSecondary.withValues(alpha: 0.6),
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: RuangBukuColors.textSecondary,
    ),
    floatingLabelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: RuangBukuColors.primary,
    ),
    errorStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: RuangBukuColors.error,
    ),
    prefixIconColor: RuangBukuColors.textSecondary,
    suffixIconColor: RuangBukuColors.textSecondary,
  );

  /// Bottom Navigation Bar — Active icon uses Primary (Matcha Green)
  static final BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: RuangBukuColors.cardSurface,
    selectedItemColor: RuangBukuColors.primary,
    unselectedItemColor: RuangBukuColors.textSecondary,
    selectedLabelStyle: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w400,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    showUnselectedLabels: true,
    showSelectedLabels: true,
  );

  /// Navigation Bar (Material 3) — for use with NavigationBar widget
  static final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
    backgroundColor: RuangBukuColors.cardSurface,
    indicatorColor: RuangBukuColors.primary.withValues(alpha: 0.12),
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    height: 72,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: RuangBukuColors.primary,
        );
      }
      return GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: RuangBukuColors.textSecondary,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(
          color: RuangBukuColors.primary,
          size: 24,
        );
      }
      return const IconThemeData(
        color: RuangBukuColors.textSecondary,
        size: 24,
      );
    }),
  );

  /// Floating Action Button — highest elevation, accent color
  static const FloatingActionButtonThemeData _fabTheme =
      FloatingActionButtonThemeData(
    backgroundColor: RuangBukuColors.accent,
    foregroundColor: RuangBukuColors.onAccent,
    elevation: 6,
    focusElevation: 8,
    hoverElevation: 8,
    highlightElevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  /// Chip — pill-shaped status chips
  static final ChipThemeData _chipTheme = ChipThemeData(
    backgroundColor: RuangBukuColors.surfaceContainerLow,
    labelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.05 * 12,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: RuangBukuSpacing.md,
      vertical: RuangBukuSpacing.xs,
    ),
    shape: const StadiumBorder(),
    side: BorderSide.none,
  );

  /// Bottom Sheet — rounded top corners, Level 2 elevation
  static const BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: RuangBukuColors.cardSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    modalElevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    showDragHandle: true,
    dragHandleColor: RuangBukuColors.outlineVariant,
    dragHandleSize: Size(40, 4),
  );

  /// Dialog
  static final DialogThemeData _dialogTheme = DialogThemeData(
    backgroundColor: RuangBukuColors.cardSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusXl,
    ),
    titleTextStyle: RuangBukuTypography.headlineSmall,
    contentTextStyle: RuangBukuTypography.bodyMedium,
  );

  /// Divider
  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: RuangBukuColors.divider,
    thickness: 1,
    space: 1,
  );

  /// Icon
  static const IconThemeData _iconTheme = IconThemeData(
    color: RuangBukuColors.textPrimary,
    size: 24,
  );

  /// Snackbar
  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: RuangBukuColors.inverseSurface,
    contentTextStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: RuangBukuColors.inverseOnSurface,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusMd,
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
  );

  /// Tab Bar
  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelColor: RuangBukuColors.primary,
    unselectedLabelColor: RuangBukuColors.textSecondary,
    indicatorColor: RuangBukuColors.primary,
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );

  /// Switch
  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuColors.onPrimary;
      }
      return RuangBukuColors.outlineVariant;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuColors.primary;
      }
      return RuangBukuColors.surfaceContainerHigh;
    }),
  );

  /// Checkbox
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuColors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(RuangBukuColors.onPrimary),
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusSm,
    ),
    side: const BorderSide(
      color: RuangBukuColors.outlineVariant,
      width: 1.5,
    ),
  );

  /// Radio
  static final RadioThemeData _radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuColors.primary;
      }
      return RuangBukuColors.outlineVariant;
    }),
  );

  /// ListTile
  static final ListTileThemeData _listTileTheme = ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: RuangBukuSpacing.lg,
      vertical: RuangBukuSpacing.sm,
    ),
    titleTextStyle: RuangBukuTypography.bodyLarge,
    subtitleTextStyle: RuangBukuTypography.bodySmall,
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
    ),
  );

  // ── Build the Complete ThemeData ──────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: RuangBukuColors.surface,
      textTheme: _textTheme,

      // Component Themes
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputDecorationTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      navigationBarTheme: _navigationBarTheme,
      floatingActionButtonTheme: _fabTheme,
      chipTheme: _chipTheme,
      bottomSheetTheme: _bottomSheetTheme,
      dialogTheme: _dialogTheme,
      dividerTheme: _dividerTheme,
      iconTheme: _iconTheme,
      snackBarTheme: _snackBarTheme,
      tabBarTheme: _tabBarTheme,
      switchTheme: _switchTheme,
      checkboxTheme: _checkboxTheme,
      radioTheme: _radioTheme,
      listTileTheme: _listTileTheme,

      // Global visual density for comfortable tap targets
      visualDensity: VisualDensity.standard,

      // Splash / Ripple
      splashColor: RuangBukuColors.primary.withValues(alpha: 0.08),
      highlightColor: RuangBukuColors.primary.withValues(alpha: 0.04),
      splashFactory: InkSparkle.splashFactory,

      // Page transition
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. EXTENSION — Convenient access to custom semantic colors
// ─────────────────────────────────────────────────────────────────────────────

/// Extension on [ThemeData] for quick access to RuangBuku semantic tokens
/// that don't map cleanly to Material's ColorScheme.
///
/// Usage: `Theme.of(context).extension<RuangBukuSemanticColors>()!.success`
@immutable
class RuangBukuSemanticColors extends ThemeExtension<RuangBukuSemanticColors> {
  const RuangBukuSemanticColors({
    required this.success,
    required this.neutralChip,
    required this.cardSurface,
    required this.shadowTint,
    required this.accentTerracotta,
  });

  final Color success;
  final Color neutralChip;
  final Color cardSurface;
  final Color shadowTint;
  final Color accentTerracotta;

  /// Default instance with the standard RuangBuku colors
  static const standard = RuangBukuSemanticColors(
    success: RuangBukuColors.success,
    neutralChip: RuangBukuColors.neutralChip,
    cardSurface: RuangBukuColors.cardSurface,
    shadowTint: RuangBukuColors.shadowTint,
    accentTerracotta: RuangBukuColors.accent,
  );

  @override
  RuangBukuSemanticColors copyWith({
    Color? success,
    Color? neutralChip,
    Color? cardSurface,
    Color? shadowTint,
    Color? accentTerracotta,
  }) {
    return RuangBukuSemanticColors(
      success: success ?? this.success,
      neutralChip: neutralChip ?? this.neutralChip,
      cardSurface: cardSurface ?? this.cardSurface,
      shadowTint: shadowTint ?? this.shadowTint,
      accentTerracotta: accentTerracotta ?? this.accentTerracotta,
    );
  }

  @override
  RuangBukuSemanticColors lerp(
    covariant ThemeExtension<RuangBukuSemanticColors>? other,
    double t,
  ) {
    if (other is! RuangBukuSemanticColors) return this;
    return RuangBukuSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      neutralChip: Color.lerp(neutralChip, other.neutralChip, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      shadowTint: Color.lerp(shadowTint, other.shadowTint, t)!,
      accentTerracotta:
          Color.lerp(accentTerracotta, other.accentTerracotta, t)!,
    );
  }
}
