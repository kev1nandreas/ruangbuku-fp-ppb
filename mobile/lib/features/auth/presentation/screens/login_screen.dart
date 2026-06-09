import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import '../../domain/auth_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await AuthNotifier.instance.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AuthNotifier.instance.errorMessage ?? 'Login gagal.',
            style: RuangBukuTypography.bodyMedium.copyWith(
              color: RuangBukuColors.onError,
            ),
          ),
          backgroundColor: RuangBukuColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: RuangBukuRadius.borderRadiusMd,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RuangBukuColors.surface,
      body: ListenableBuilder(
        listenable: AuthNotifier.instance,
        builder: (context, _) {
          final isLoading =
              AuthNotifier.instance.status == AuthStatus.loading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: RuangBukuSpacing.marginMobile,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: RuangBukuSpacing.huge),
                  _Header(),
                  const SizedBox(height: RuangBukuSpacing.xxxl),
                  _LoginCard(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscurePassword: _obscurePassword,
                    isLoading: isLoading,
                    onTogglePassword: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onSubmit: _submit,
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: RuangBukuColors.primary,
            borderRadius: RuangBukuRadius.borderRadiusXl,
            boxShadow: RuangBukuElevation.level2,
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: RuangBukuColors.onPrimary,
            size: 40,
          ),
        ),
        const SizedBox(height: RuangBukuSpacing.lg),
        Text(
          'RuangBuku',
          style: RuangBukuTypography.displayLargeMobile.copyWith(
            color: RuangBukuColors.textDeep,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: RuangBukuSpacing.sm),
        Text(
          'Berbagi buku, memperluas wawasan.',
          style: RuangBukuTypography.bodyMedium.copyWith(
            color: RuangBukuColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
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
              'Masuk',
              style: RuangBukuTypography.headlineMedium,
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              'Silakan masuk untuk melanjutkan',
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
                if (value.length < 6) {
                  return 'Kata sandi minimal 6 karakter';
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
                      'Masuk',
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
