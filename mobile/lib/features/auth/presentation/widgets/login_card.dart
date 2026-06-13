import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';

/// The login form card: email + password fields and the submit button.
class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(RuangBukuSpacing.xl),
      decoration: BoxDecoration(
        color: RuangBukuColors.cardSurface,
        borderRadius: RuangBukuRadius.borderRadiusXl,
        boxShadow: RuangBukuElevation.level2,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n?.login ?? 'Masuk',
              style: RuangBukuTypography.headlineMedium,
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              l10n?.loginSubtitle ?? 'Silakan masuk untuk melanjutkan',
              style: RuangBukuTypography.bodyMedium.copyWith(
                color: RuangBukuColors.textSecondary,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: l10n?.email ?? 'Email',
                hintText: l10n?.emailHint ?? 'Masukkan email Anda',
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n?.emailEmptyError ?? 'Email tidak boleh kosong';
                }
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value.trim())) {
                  return l10n?.emailInvalidError ?? 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              onFieldSubmitted: (_) => onSubmit(),
              decoration: InputDecoration(
                labelText: l10n?.password ?? 'Kata Sandi',
                hintText: l10n?.passwordHint ?? 'Masukkan kata sandi Anda',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: onTogglePassword,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n?.passwordEmptyError ?? 'Kata sandi tidak boleh kosong';
                }
                if (value.length < 6) {
                  return l10n?.passwordLengthError ?? 'Kata sandi minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),
            FilledButton(
              onPressed: isLoading ? null : onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: RuangBukuColors.primary,
                foregroundColor: RuangBukuColors.onPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: RuangBukuRadius.borderRadiusLg,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: RuangBukuColors.onPrimary,
                      ),
                    )
                  : Text(
                      l10n?.login ?? 'Masuk',
                      style: RuangBukuTypography.labelLarge.copyWith(
                        color: RuangBukuColors.onPrimary,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
