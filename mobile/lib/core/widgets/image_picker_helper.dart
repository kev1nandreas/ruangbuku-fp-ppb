import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../storage/storage_repository.dart';

/// Generic image-pick-and-upload helper, reusable across features (book cover,
/// profile avatar, deposit proof). Asks camera/gallery, picks the image,
/// uploads it to MinIO under [folder], and returns the public URL — or null if
/// the user cancelled. Throws on upload failure.
Future<String?> pickAndUploadImage(
  BuildContext context, {
  required String folder,
}) async {
  final picker = ImagePicker();

  final source = await _chooseImageSource(context);
  if (source == null) return null;

  final XFile? picked = await picker.pickImage(
    source: source,
    imageQuality: 85,
    maxWidth: 1600,
  );
  if (picked == null) return null;

  return StorageRepository.instance.uploadFile(File(picked.path), folder: folder);
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
