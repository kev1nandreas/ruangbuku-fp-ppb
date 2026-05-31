import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

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

  void _simulateScan() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isbnController.text = '9781471156267';
          _titleController.text = 'Sapiens: A Brief History of Humankind';
          _authorController.text = 'Yuval Noah Harari';
          _descriptionController.text = 
              'Earth is 4.5 billion years old. In just a fraction of that time, one species among countless others has conquered it: us. In this bold and provocative book, Yuval Noah Harari explores who we are, how we got here and where we\'re going.';
        });
      }
    });
  }

  void _submitBook() {
    final isbn = _isbnController.text.trim();
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || author.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in at least the Title and Author.')),
      );
      return;
    }

    RuangBukuState.instance.addBook(
      isbn.isEmpty ? 'N/A' : isbn,
      title,
      author,
      description.isEmpty ? 'No description available.' : description,
      _condition,
      _isAvailableForLending,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAvailableForLending 
              ? '"$title" added and submitted for Admin Curation approval (F-01)!' 
              : '"$title" added to your private collection!'
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add a Book',
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
              'Add by ISBN',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _isbnController,
                    decoration: const InputDecoration(
                      labelText: 'ISBN Number',
                      hintText: 'e.g., 9781471156267',
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
                    onPressed: _isLoading ? null : _simulateScan,
                    icon: _isLoading 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.document_scanner_outlined, color: RuangBukuColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: RuangBukuSpacing.xl),

            Text(
              'Book Details',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter book title',
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                hintText: 'Enter author name',
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter synopsis or short description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),

            Text(
              'Your Copy',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Condition',
              ),
              value: _condition,
              items: const [
                DropdownMenuItem(value: 'Like New', child: Text('Like New')),
                DropdownMenuItem(value: 'Very Good', child: Text('Very Good')),
                DropdownMenuItem(value: 'Good', child: Text('Good')),
                DropdownMenuItem(value: 'Acceptable', child: Text('Acceptable')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _condition = value;
                  });
                }
              },
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            
            // Lending Permission
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: RuangBukuRadius.borderRadiusLg,
                border: Border.all(
                  color: RuangBukuColors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              padding: const EdgeInsets.all(RuangBukuSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available for Lending', style: textTheme.titleMedium),
                        const SizedBox(height: RuangBukuSpacing.xs),
                        Text(
                          'Allow others in your area to borrow this book.',
                          style: textTheme.bodySmall?.copyWith(color: RuangBukuColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isAvailableForLending,
                    onChanged: (value) {
                      setState(() {
                        _isAvailableForLending = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: RuangBukuColors.shadowTint.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 12,
            ),
          ],
        ),
        child: FilledButton(
          onPressed: _submitBook,
          child: const Text('Add Book to Library'),
        ),
      ),
    );
  }
}
