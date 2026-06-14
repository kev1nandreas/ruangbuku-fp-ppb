import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/bottom_action_bar.dart';
import '../../../core/widgets/image_picker_helper.dart';
import '../../auth/domain/auth_notifier.dart';

/// Lets the user edit their display name and profile photo. The photo is
/// uploaded to S3/MinIO via the presigned-URL flow; only the resulting URL is
/// sent to the profile-update endpoint.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  String? _avatarUrl;
  bool _isUploadingAvatar = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = AuthNotifier.instance.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _avatarUrl = user?.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _pickAvatar() async {
    setState(() => _isUploadingAvatar = true);
    try {
      final url = await pickAndUploadImage(context, folder: 'avatars');
      if (url != null && mounted) {
        setState(() => _avatarUrl = url);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah foto: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  void _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final ok = await AuthNotifier.instance.updateProfile(
      name: name,
      avatarUrl: _avatarUrl,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil diperbarui.')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          AuthNotifier.instance.errorMessage ?? 'Gagal memperbarui profil.',
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = AuthNotifier.instance.user;
    final seed = user?.id ?? 'guest';
    final shownAvatar = (_avatarUrl?.isNotEmpty ?? false)
        ? _avatarUrl!
        : 'https://picsum.photos/seed/$seed/100/100';

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                    backgroundImage:
                        _isUploadingAvatar ? null : NetworkImage(shownAvatar),
                    child: _isUploadingAvatar
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _isUploadingAvatar ? null : _pickAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: RuangBukuColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 18, color: RuangBukuColors.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),
            Text('Nama', style: textTheme.titleMedium),
            const SizedBox(height: RuangBukuSpacing.sm),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Masukkan nama Anda',
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            Text('Email', style: textTheme.titleMedium),
            const SizedBox(height: RuangBukuSpacing.sm),
            TextField(
              enabled: false,
              controller: TextEditingController(text: user?.email ?? ''),
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: BottomActionBar(
        child: FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan Perubahan'),
        ),
      ),
    );
  }
}
