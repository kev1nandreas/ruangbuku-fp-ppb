import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/state.dart';
import '../../../core/storage/storage_repository.dart';
import '../../../core/theme.dart';

/// Lets the borrower choose camera or gallery, pick/take an image, upload it to
/// MinIO, then attach the returned URL to the borrow as the deposit proof.
/// Shows progress + result via snackbars. Returns true on success.
Future<bool> pickAndUploadDepositProof(
  BuildContext context,
  String borrowId,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final picker = ImagePicker();

  final source = await _chooseImageSource(context);
  if (source == null) return false;

  final XFile? picked = await picker.pickImage(
    source: source,
    imageQuality: 85,
    maxWidth: 1600,
  );
  if (picked == null) return false;

  messenger.showSnackBar(
    const SnackBar(content: Text('Mengunggah bukti deposit...')),
  );

  try {
    final url = await StorageRepository.instance
        .uploadFile(File(picked.path), folder: 'deposits');
    await RuangBukuState.instance.uploadProofOfDeposit(borrowId, url);
    messenger.showSnackBar(
      const SnackBar(content: Text('Bukti deposit terkirim, menunggu konfirmasi admin.')),
    );
    return true;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Gagal mengunggah: $e')));
    return false;
  }
}

/// Bottom sheet asking the user to take a photo or pick from the gallery.
Future<ImageSource?> _chooseImageSource(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Ambil Foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );
}

/// Full-screen viewer for an uploaded deposit proof image. Usable by both the
/// borrower (their own proof) and the admin (to verify before confirming).
void showDepositProofViewer(BuildContext context, String proofUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(RuangBukuSpacing.md),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  proofUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'Gagal memuat gambar bukti.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}
