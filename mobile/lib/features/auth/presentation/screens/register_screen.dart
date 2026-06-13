import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/auth_notifier.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await AuthNotifier.instance.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Auth state is now `authenticated`, so popping back to the app root
      // reveals the MainScaffold (the root listens to AuthNotifier).
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AuthNotifier.instance.errorMessage ?? 'Pendaftaran gagal.',
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                  const SizedBox(height: RuangBukuSpacing.xxxl),
                  const AuthHeader(),
                  const SizedBox(height: RuangBukuSpacing.xxxl),
                  RegisterCard(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    obscurePassword: _obscurePassword,
                    obscureConfirmPassword: _obscureConfirmPassword,
                    isLoading: isLoading,
                    onTogglePassword: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onToggleConfirmPassword: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword),
                    onSubmit: _submit,
                  ),
                  const SizedBox(height: RuangBukuSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n?.hasAccountPrompt ?? 'Sudah punya akun? ',
                        style: RuangBukuTypography.bodyMedium.copyWith(
                          color: RuangBukuColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(
                          l10n?.login ?? 'Masuk',
                          style: RuangBukuTypography.bodyMedium.copyWith(
                            color: RuangBukuColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
