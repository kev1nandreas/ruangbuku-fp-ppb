import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

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
              'Daftar',
              style: RuangBukuTypography.headlineMedium,
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              'Buat akun untuk mulai meminjam buku',
              style: RuangBukuTypography.bodyMedium.copyWith(
                color: RuangBukuColors.textSecondary,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Nama',
                hintText: 'Masukkan nama Anda',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                if (value.trim().length < 3) {
                  return 'Nama minimal 3 karakter';
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
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Masukkan email Anda',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value.trim())) {
                  return 'Format email tidak valid';
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
                labelText: 'Kata Sandi',
                hintText: 'Masukkan kata sandi Anda',
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
                  return 'Kata sandi tidak boleh kosong';
                }
                if (value.length < 8) {
                  return 'Kata sandi minimal 8 karakter';
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
                labelText: 'Konfirmasi Kata Sandi',
                hintText: 'Masukkan ulang kata sandi Anda',
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
                  return 'Konfirmasi kata sandi tidak boleh kosong';
                }
                if (value != passwordController.text) {
                  return 'Konfirmasi kata sandi tidak cocok';
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
                      'Daftar',
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
