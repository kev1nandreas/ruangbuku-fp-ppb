import 'package:flutter/material.dart';
import '../../../core/state.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/image_picker_helper.dart';

/// Lets the borrower choose camera or gallery, pick/take an image, upload it to
/// MinIO, then attach the returned URL to the borrow as the deposit proof.
/// Shows progress + result via snackbars. Returns true on success.
Future<bool> pickAndUploadDepositProof(
  BuildContext context,
  String borrowId,
) async {
  final messenger = ScaffoldMessenger.of(context);

  try {
    final url = await pickAndUploadImage(context, folder: 'deposits');
    if (url == null) return false;

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
                  errorBuilder: (context, error, stackTrace) => const Padding(
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
