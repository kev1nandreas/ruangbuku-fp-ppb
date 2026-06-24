import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

// RuangBuku — Dark Theme Blueprint (Separated from theme.dart)

// 1. DARK COLOR PALETTE (Charcoal Gray - Option B)

class RuangBukuDarkColors {
  RuangBukuDarkColors._();

  // Core Palette
  /// Background / Surface — Very dark grey (Material Default)
  static const Color surface = Color(0xFF121212);

  /// Primary (Brand, Headers, Active Nav) — Matcha / Olive Green
  static const Color primary = Color(0xFF8FA88B);

  /// Accent (Action Buttons: 'Borrow', Bookmarks) — Muted Terracotta / Peach Clay
  static const Color accent = Color(0xFFE29578);

  /// Typography (Titles, Body Text) — Light Grey
  static const Color textPrimary = Color(0xFFE3E3E3);

  /// Typography — Pure White for ultimate contrast
  static const Color textDeep = Color(0xFFFFFFFF);

  // Derived / Supporting Colors
  /// On-primary text
  static const Color onPrimary = Color(0xFF121212);

  /// On-accent text
  static const Color onAccent = Color(0xFF121212);

  /// Card surface — Slightly lighter than surface
  static const Color cardSurface = Color(0xFF1E1E1E);

  /// Surface container low
  static const Color surfaceContainerLow = Color(0xFF1A1A1A);

  /// Surface container
  static const Color surfaceContainer = Color(0xFF1E1E1E);

  /// Surface container high
  static const Color surfaceContainerHigh = Color(0xFF2C2C2C);

  /// Outline
  static const Color outline = Color(0xFF4A4A4A);

  /// Outline variant
  static const Color outlineVariant = Color(0xFF333333);

  /// On-surface variant — secondary text, captions
  static const Color textSecondary = Color(0xFFA0A0A0);

  /// Inverse surface
  static const Color inverseSurface = Color(0xFFE3E3E3);

  /// Inverse on-surface
  static const Color inverseOnSurface = Color(0xFF121212);

  /// Error (Material dark mode standard error red)
  static const Color error = Color(0xFFCF6679);

  /// On-error
  static const Color onError = Color(0xFF121212);

  /// Error container
  static const Color errorContainer = Color(0xFF93000A);

  /// Success / Available status
  static const Color success = Color(0xFF6FCF97);

  /// On Loan / Neutral status chip
  static const Color neutralChip = Color(0xFF4A4A4A);

  /// Shadow tint
  static const Color shadowTint = Color(0x66000000); // Darker shadow for dark mode

  /// Divider color
  static const Color divider = Color(0xFF2C2C2C);
}

// 2. DARK TYPOGRAPHY — Poppins (Headings) + Roboto (Body)

class RuangBukuDarkTypography {
  RuangBukuDarkTypography._();

  /// Display Large — 32px, Poppins Bold
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Display Large Mobile — 28px, Poppins Bold
  static TextStyle get displayLargeMobile => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 36 / 28,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Headline Medium — 24px, Poppins SemiBold
  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Headline Small — 20px, Poppins SemiBold
  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Title Large — 18px, Poppins SemiBold
  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Title Medium — 16px, Roboto Medium
  static TextStyle get titleMedium => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Title Small — 14px, Roboto Medium
  static TextStyle get titleSmall => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Body Large — 16px, Roboto Regular
  static TextStyle get bodyLarge => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Body Medium — 14px, Roboto Regular
  static TextStyle get bodyMedium => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Body Small — 12px, Roboto Regular
  static TextStyle get bodySmall => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: RuangBukuDarkColors.textSecondary,
      );

  /// Label Large — 14px, Roboto SemiBold
  static TextStyle get labelLarge => GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Label Medium — 12px, Roboto SemiBold
  static TextStyle get labelMedium => GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.05 * 12,
        color: RuangBukuDarkColors.textPrimary,
      );

  /// Label Small — 10px, Roboto Medium
  static TextStyle get labelSmall => GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 14 / 10,
        letterSpacing: 0.04 * 10,
        color: RuangBukuDarkColors.textSecondary,
      );
}

// 3. DARK THEME DATA — Complete Material 3 ThemeData

class RuangBukuDarkTheme {
  RuangBukuDarkTheme._();

  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: RuangBukuDarkColors.primary,
    onPrimary: RuangBukuDarkColors.onPrimary,
    primaryContainer: RuangBukuDarkColors.primary,
    onPrimaryContainer: RuangBukuDarkColors.onPrimary,
    secondary: RuangBukuDarkColors.accent,
    onSecondary: RuangBukuDarkColors.onAccent,
    secondaryContainer: RuangBukuDarkColors.accent,
    onSecondaryContainer: RuangBukuDarkColors.onAccent,
    tertiary: RuangBukuDarkColors.success,
    onTertiary: RuangBukuDarkColors.onPrimary,
    surface: RuangBukuDarkColors.surface,
    onSurface: RuangBukuDarkColors.textPrimary,
    onSurfaceVariant: RuangBukuDarkColors.textSecondary,
    surfaceContainerLowest: RuangBukuDarkColors.surface,
    surfaceContainerLow: RuangBukuDarkColors.surfaceContainerLow,
    surfaceContainer: RuangBukuDarkColors.surfaceContainer,
    surfaceContainerHigh: RuangBukuDarkColors.surfaceContainerHigh,
    outline: RuangBukuDarkColors.outline,
    outlineVariant: RuangBukuDarkColors.outlineVariant,
    inverseSurface: RuangBukuDarkColors.inverseSurface,
    onInverseSurface: RuangBukuDarkColors.inverseOnSurface,
    inversePrimary: RuangBukuDarkColors.primary,
    error: RuangBukuDarkColors.error,
    onError: RuangBukuDarkColors.onError,
    errorContainer: RuangBukuDarkColors.errorContainer,
    onErrorContainer: RuangBukuDarkColors.error,
    shadow: RuangBukuDarkColors.shadowTint,
  );

  static final TextTheme _textTheme = TextTheme(
    displayLarge: RuangBukuDarkTypography.displayLarge,
    displayMedium: RuangBukuDarkTypography.displayLargeMobile,
    displaySmall: RuangBukuDarkTypography.headlineMedium,
    headlineLarge: RuangBukuDarkTypography.displayLargeMobile,
    headlineMedium: RuangBukuDarkTypography.headlineMedium,
    headlineSmall: RuangBukuDarkTypography.headlineSmall,
    titleLarge: RuangBukuDarkTypography.titleLarge,
    titleMedium: RuangBukuDarkTypography.titleMedium,
    titleSmall: RuangBukuDarkTypography.titleSmall,
    bodyLarge: RuangBukuDarkTypography.bodyLarge,
    bodyMedium: RuangBukuDarkTypography.bodyMedium,
    bodySmall: RuangBukuDarkTypography.bodySmall,
    labelLarge: RuangBukuDarkTypography.labelLarge,
    labelMedium: RuangBukuDarkTypography.labelMedium,
    labelSmall: RuangBukuDarkTypography.labelSmall,
  );

  static final AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: RuangBukuDarkColors.surface,
    foregroundColor: RuangBukuDarkColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    centerTitle: true,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: RuangBukuDarkColors.textPrimary,
    ),
    iconTheme: const IconThemeData(
      color: RuangBukuDarkColors.textPrimary,
      size: 24,
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RuangBukuDarkColors.primary,
      foregroundColor: RuangBukuDarkColors.onPrimary,
      disabledBackgroundColor: RuangBukuDarkColors.primary.withValues(alpha: 0.38),
      disabledForegroundColor:
          RuangBukuDarkColors.onPrimary.withValues(alpha: 0.38),
      elevation: 0,
      shadowColor: RuangBukuDarkColors.shadowTint,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.xl,
        vertical: RuangBukuSpacing.lg,
      ),
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusLg,
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
    ),
  );

  static final FilledButtonThemeData _filledButtonTheme =
      FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: RuangBukuDarkColors.accent,
      foregroundColor: RuangBukuDarkColors.onAccent,
      disabledBackgroundColor: RuangBukuDarkColors.accent.withValues(alpha: 0.38),
      disabledForegroundColor:
          RuangBukuDarkColors.onAccent.withValues(alpha: 0.38),
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.xl,
        vertical: RuangBukuSpacing.lg,
      ),
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusLg,
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: RuangBukuDarkColors.textPrimary,
      side: const BorderSide(
        color: RuangBukuDarkColors.outlineVariant,
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
      textStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
    ),
  );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: RuangBukuDarkColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.lg,
        vertical: RuangBukuSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusSm,
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
      ),
    ),
  );

  static const CardThemeData _cardTheme = CardThemeData(
    color: RuangBukuDarkColors.cardSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    clipBehavior: Clip.antiAlias,
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: RuangBukuDarkColors.cardSurface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: RuangBukuSpacing.lg,
      vertical: RuangBukuSpacing.lg,
    ),
    border: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuDarkColors.outlineVariant,
        width: 1.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuDarkColors.outlineVariant,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuDarkColors.primary,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuDarkColors.error,
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
      borderSide: const BorderSide(
        color: RuangBukuDarkColors.error,
        width: 2.0,
      ),
    ),
    hintStyle: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: RuangBukuDarkColors.textSecondary.withValues(alpha: 0.6),
    ),
    labelStyle: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: RuangBukuDarkColors.textSecondary,
    ),
    floatingLabelStyle: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: RuangBukuDarkColors.primary,
    ),
    errorStyle: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: RuangBukuDarkColors.error,
    ),
    prefixIconColor: RuangBukuDarkColors.textSecondary,
    suffixIconColor: RuangBukuDarkColors.textSecondary,
  );

  static final BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: RuangBukuDarkColors.cardSurface,
    selectedItemColor: RuangBukuDarkColors.primary,
    unselectedItemColor: RuangBukuDarkColors.textSecondary,
    selectedLabelStyle: GoogleFonts.roboto(
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.roboto(
      fontSize: 11,
      fontWeight: FontWeight.w400,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    showUnselectedLabels: true,
    showSelectedLabels: true,
  );

  static final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
    backgroundColor: RuangBukuDarkColors.cardSurface,
    indicatorColor: RuangBukuDarkColors.primary.withValues(alpha: 0.12),
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    height: 72,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return GoogleFonts.roboto(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: RuangBukuDarkColors.primary,
        );
      }
      return GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: RuangBukuDarkColors.textSecondary,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(
          color: RuangBukuDarkColors.primary,
          size: 24,
        );
      }
      return const IconThemeData(
        color: RuangBukuDarkColors.textSecondary,
        size: 24,
      );
    }),
  );

  static const FloatingActionButtonThemeData _fabTheme =
      FloatingActionButtonThemeData(
    backgroundColor: RuangBukuDarkColors.accent,
    foregroundColor: RuangBukuDarkColors.onAccent,
    elevation: 6,
    focusElevation: 8,
    hoverElevation: 8,
    highlightElevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static final ChipThemeData _chipTheme = ChipThemeData(
    backgroundColor: RuangBukuDarkColors.surfaceContainerLow,
    labelStyle: GoogleFonts.roboto(
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

  static const BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: RuangBukuDarkColors.cardSurface,
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
    dragHandleColor: RuangBukuDarkColors.outlineVariant,
    dragHandleSize: Size(40, 4),
  );

  static final DialogThemeData _dialogTheme = DialogThemeData(
    backgroundColor: RuangBukuDarkColors.cardSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusXl,
    ),
    titleTextStyle: RuangBukuDarkTypography.headlineSmall,
    contentTextStyle: RuangBukuDarkTypography.bodyMedium,
  );

  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: RuangBukuDarkColors.divider,
    thickness: 1,
    space: 1,
  );

  static const IconThemeData _iconTheme = IconThemeData(
    color: RuangBukuDarkColors.textPrimary,
    size: 24,
  );

  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: RuangBukuDarkColors.inverseSurface,
    contentTextStyle: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: RuangBukuDarkColors.inverseOnSurface,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusMd,
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
  );

  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelColor: RuangBukuDarkColors.primary,
    unselectedLabelColor: RuangBukuDarkColors.textSecondary,
    indicatorColor: RuangBukuDarkColors.primary,
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );

  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuDarkColors.onPrimary;
      }
      return RuangBukuDarkColors.outlineVariant;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuDarkColors.primary;
      }
      return RuangBukuDarkColors.surfaceContainerHigh;
    }),
  );

  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuDarkColors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(RuangBukuDarkColors.onPrimary),
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusSm,
    ),
    side: const BorderSide(
      color: RuangBukuDarkColors.outlineVariant,
      width: 1.5,
    ),
  );

  static final RadioThemeData _radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return RuangBukuDarkColors.primary;
      }
      return RuangBukuDarkColors.outlineVariant;
    }),
  );

  static final ListTileThemeData _listTileTheme = ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: RuangBukuSpacing.lg,
      vertical: RuangBukuSpacing.sm,
    ),
    titleTextStyle: RuangBukuDarkTypography.bodyLarge,
    subtitleTextStyle: RuangBukuDarkTypography.bodySmall,
    shape: RoundedRectangleBorder(
      borderRadius: RuangBukuRadius.borderRadiusLg,
    ),
  );

  // Build the Complete ThemeData
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: RuangBukuDarkColors.surface,
      textTheme: _textTheme,
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
      visualDensity: VisualDensity.standard,
      splashColor: RuangBukuDarkColors.primary.withValues(alpha: 0.08),
      highlightColor: RuangBukuDarkColors.primary.withValues(alpha: 0.04),
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
