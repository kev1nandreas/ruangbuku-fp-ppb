import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';

/// The register form card: name, email, password + confirmation fields and the
/// submit button.
class RegisterCard extends StatelessWidget {
  const RegisterCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(RuangBukuSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: RuangBukuRadius.borderRadiusXl,
        boxShadow: RuangBukuElevation.level2,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n?.register ?? 'Daftar',
              style: RuangBukuTypography.headlineMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              l10n?.registerSubtitle ?? 'Buat akun untuk mulai meminjam buku',
              style: RuangBukuTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: l10n?.name ?? 'Nama',
                hintText: l10n?.nameHint ?? 'Masukkan nama Anda',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n?.nameEmptyError ?? 'Nama tidak boleh kosong';
                }
                if (value.trim().length < 3) {
                  return l10n?.nameLengthError ?? 'Nama minimal 3 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
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
                if (value.trim().length > 50) {
                  return 'Email maksimal 50 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
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
                if (value.length < 8) {
                  return l10n?.passwordLengthError ?? 'Kata sandi minimal 8 karakter';
                }
                if (value.length > 50) {
                  return 'Kata sandi maksimal 50 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              onFieldSubmitted: (_) => onSubmit(),
              decoration: InputDecoration(
                labelText: l10n?.confirmPassword ?? 'Konfirmasi Kata Sandi',
                hintText: l10n?.confirmPasswordHint ?? 'Masukkan ulang kata sandi Anda',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: onToggleConfirmPassword,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n?.confirmPasswordEmptyError ?? 'Konfirmasi kata sandi tidak boleh kosong';
                }
                if (value != passwordController.text) {
                  return l10n?.confirmPasswordMatchError ?? 'Konfirmasi kata sandi tidak cocok';
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
                      l10n?.register ?? 'Daftar',
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
