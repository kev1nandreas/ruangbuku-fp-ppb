import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  bool _isLoading = false;
  bool _isAutoFilled = false;

  void _simulateScan() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isAutoFilled = true;
        });
      }
    });
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
                    decoration: const InputDecoration(
                      labelText: 'ISBN Number',
                      hintText: 'e.g., 9781471156267',
                    ),
                    controller: _isAutoFilled ? TextEditingController(text: '9781471156267') : null,
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

            if (_isAutoFilled) ...[
              Text(
                'Book Details (Auto-filled)',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: RuangBukuSpacing.md),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: TextEditingController(text: 'Sapiens: A Brief History of Humankind'),
                readOnly: true,
              ),
              const SizedBox(height: RuangBukuSpacing.lg),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Author',
                ),
                controller: TextEditingController(text: 'Yuval Noah Harari'),
                readOnly: true,
              ),
              const SizedBox(height: RuangBukuSpacing.xl),
            ],

            Text(
              'Your Copy',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Condition',
              ),
              items: const [
                DropdownMenuItem(value: 'Like New', child: Text('Like New')),
                DropdownMenuItem(value: 'Very Good', child: Text('Very Good')),
                DropdownMenuItem(value: 'Good', child: Text('Good')),
                DropdownMenuItem(value: 'Acceptable', child: Text('Acceptable')),
              ],
              onChanged: (value) {},
              hint: const Text('Select condition'),
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
                    value: true,
                    onChanged: (value) {},
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Add Book to Library'),
        ),
      ),
    );
  }
}

