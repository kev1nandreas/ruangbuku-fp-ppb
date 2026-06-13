import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../discovery/domain/book_notifier.dart';
import '../../../core/widgets/bottom_action_bar.dart';
import '../widgets/condition_dropdown.dart';
import '../widgets/lending_permission_switch.dart';
import '../../../l10n/app_localizations.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  bool _isLoading = false;

  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _condition = 'Like New';
  bool _isAvailableForLending = true;

  @override
  void dispose() {
    _isbnController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _lookupIsbn() async {
    String isbn = _isbnController.text.trim();
    if (isbn.isEmpty) {
      // Demo helper: if empty, search Sapiens
      isbn = '9781471156267';
      _isbnController.text = isbn;
    }

    setState(() {
      _isLoading = true;
    });

    final details = await BookNotifier.instance.checkIsbn(isbn);

    final l10n = AppLocalizations.of(context);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (details != null) {
          _titleController.text = details['title']?.toString() ?? '';
          _authorController.text = details['author']?.toString() ?? '';
          _descriptionController.text = details['description']?.toString() ?? '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n?.bookDetailsLoaded ?? 'Detail buku berhasil dimuat dari API!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n?.bookNotFoundInServer ?? 'Buku tidak ditemukan di server/Google Books.')),
          );
        }
      });
    }
  }

  void _submitBook() async {
    final isbn = _isbnController.text.trim();
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final description = _descriptionController.text.trim();

    final l10n = AppLocalizations.of(context);

    if (title.isEmpty || author.isEmpty || isbn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n?.fillInRequiredFields ?? 'Please fill in ISBN, Title, and Author.')),
      );
      return;
    }

    // Call API
    setState(() => _isLoading = true);
    try {
      await RuangBukuState.instance.addBook(
        isbn,
        title,
        author,
        description,
        _condition,
        _isAvailableForLending,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isAvailableForLending 
                  ? (l10n?.bookAddedForCuration(title) ?? '"$title" added and submitted for Admin Curation approval (F-01)!')
                  : (l10n?.bookAddedPrivate(title) ?? '"$title" added to your private collection!')
            ),
          ),
        );
        Navigator.pop(context, true); // Return true to trigger refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n?.addABook ?? 'Add a Book',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.addByIsbn ?? 'Add by ISBN',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _isbnController,
                    decoration: InputDecoration(
                      labelText: l10n?.isbnNumber ?? 'ISBN Number',
                      hintText: l10n?.isbnHint ?? 'e.g., 9781471156267',
                    ),
                  ),
                ),
                const SizedBox(width: RuangBukuSpacing.md),
                Container(
                  height: 56, // Match text field height
                  decoration: BoxDecoration(
                    color: RuangBukuColors.surfaceContainerLow,
                    borderRadius: RuangBukuRadius.borderRadiusLg,
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _lookupIsbn,
                    icon: _isLoading 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.document_scanner_outlined, color: RuangBukuColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: RuangBukuSpacing.xl),

            Text(
              l10n?.bookDetails ?? 'Book Details',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n?.bookTitleLabel ?? 'Title',
                hintText: l10n?.enterBookTitle ?? 'Enter book title',
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: l10n?.authorLabel ?? 'Author',
                hintText: l10n?.enterAuthorName ?? 'Enter author name',
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n?.descriptionLabel ?? 'Description',
                hintText: l10n?.enterDescription ?? 'Enter synopsis or short description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),

            Text(
              l10n?.yourCopy ?? 'Your Copy',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            ConditionDropdown(
              value: _condition,
              onChanged: (value) => setState(() => _condition = value),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),

            LendingPermissionSwitch(
              value: _isAvailableForLending,
              onChanged: (value) =>
                  setState(() => _isAvailableForLending = value),
            ),

            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: BottomActionBar(
        child: FilledButton(
          onPressed: _submitBook,
          child: Text(l10n?.addBookToLibrary ?? 'Add Book to Library'),
        ),
      ),
    );
  }
}
