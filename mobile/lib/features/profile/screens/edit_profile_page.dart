import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/bottom_action_bar.dart';
import '../../../core/widgets/image_picker_helper.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../../db/local_bookDB.dart';

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
  
  final TextEditingController _dobController = TextEditingController();
  String _selectedStatus = 'Siswa';
  final List<String> _statusOptions = ['Siswa', 'Mahasiswa', 'Dosen', 'Umum'];

  @override
  void initState() {
    super.initState();
    final user = AuthNotifier.instance.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _avatarUrl = user?.avatarUrl;
    _loadLocalProfileData();
  }

  Future<void> _loadLocalProfileData() async {
    final email = AuthNotifier.instance.user?.email;
    if (email == null) return;
    
    final userMap = await LocalBookDB.instance.getUserByEmail(email);
    if (userMap != null && mounted) {
      setState(() {
        if (userMap['dob'] != null && userMap['dob'].toString().isNotEmpty) {
          _dobController.text = userMap['dob'].toString();
        }
        if (userMap['status'] != null && _statusOptions.contains(userMap['status'])) {
          _selectedStatus = userMap['status'].toString();
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
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
    
    // Selalu simpan DOB dan Status ke lokal tanpa mempedulikan internet
    final email = AuthNotifier.instance.user?.email;
    if (email != null) {
      await LocalBookDB.instance.updateUserLocalProfile(
        email,
        _dobController.text,
        _selectedStatus,
      );
    }

    // Sinkronkan Nama dan Avatar ke backend
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
      // Walaupun API gagal, data DOB dan Status tetap tersimpan di atas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          AuthNotifier.instance.errorMessage ?? 'Gagal memperbarui profil backend, tapi data lokal tersimpan.',
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
              child: _AvatarEditor(
                imageUrl: shownAvatar,
                isUploading: _isUploadingAvatar,
                onTap: _isUploadingAvatar ? null : _pickAvatar,
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
            const SizedBox(height: RuangBukuSpacing.lg),
            Text('Tanggal Lahir', style: textTheme.titleMedium),
            const SizedBox(height: RuangBukuSpacing.sm),
            TextField(
              controller: _dobController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Pilih Tanggal Lahir',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _dobController.text = "${date.day}/${date.month}/${date.year}";
                  });
                }
              },
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            Text('Status', style: textTheme.titleMedium),
            const SizedBox(height: RuangBukuSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedStatus = val);
                }
              },
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

/// Circular avatar with a camera badge that triggers the image picker. Shows a
/// spinner while a new photo uploads.
class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.imageUrl,
    required this.isUploading,
    required this.onTap,
  });

  final String imageUrl;
  final bool isUploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          backgroundImage: isUploading ? null : NetworkImage(imageUrl),
          child: isUploading ? const CircularProgressIndicator() : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onTap,
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
    );
  }
}
