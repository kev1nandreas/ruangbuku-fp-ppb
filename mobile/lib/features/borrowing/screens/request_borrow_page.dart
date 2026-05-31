import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

class RequestBorrowPage extends StatefulWidget {
  final String bookId;

  const RequestBorrowPage({super.key, required this.bookId});

  @override
  State<RequestBorrowPage> createState() => _RequestBorrowPageState();
}

class _RequestBorrowPageState extends State<RequestBorrowPage> {
  DateTime? _pickupDate;
  DateTime? _returnDate;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPickup) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 90));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPickup ? (_pickupDate ?? now) : (_returnDate ?? now.add(const Duration(days: 7))),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
          // Automatically set return date to 7 days later if not selected or invalid
          if (_returnDate == null || _returnDate!.isBefore(picked)) {
            _returnDate = picked.add(const Duration(days: 7));
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _submitRequest(BookModel book) {
    if (_pickupDate == null || _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both Pickup and Return dates.')),
      );
      return;
    }

    if (_returnDate!.isBefore(_pickupDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Return date must be after pickup date.')),
      );
      return;
    }

    final state = RuangBukuState.instance;
    final error = state.requestBorrow(
      widget.bookId,
      _pickupDate!,
      _returnDate!,
      _messageController.text.trim(),
    );

    if (error != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.error_outline, color: RuangBukuColors.error),
                const SizedBox(width: 8),
                Text('Borrow Limit Exceeded', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: RuangBukuColors.error)),
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(height: 1.4),
            ),
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: RuangBukuColors.primary),
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrowing request submitted successfully (F-02)!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final state = RuangBukuState.instance;

    final book = state.books.firstWhere(
      (b) => b.id == widget.bookId,
      orElse: () => BookModel(
        id: '',
        isbn: '',
        title: 'Not Found',
        author: 'Unknown',
        description: '',
        isPublic: false,
        statusVerifikasi: BookStatus.private,
        ownerId: '',
        ownerName: 'Sarah M.',
        imageUrl: 'https://picsum.photos/200/300',
        distance: '',
        condition: 'Good',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Request to Borrow',
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
            // Book Summary Card
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: RuangBukuRadius.borderRadiusLg,
                boxShadow: RuangBukuElevation.level1,
                border: Border.all(
                  color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(RuangBukuSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: RuangBukuRadius.borderRadiusBase,
                      image: DecorationImage(
                        image: NetworkImage(book.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: RuangBukuSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: RuangBukuSpacing.xs),
                        Text(
                          book.author,
                          style: textTheme.bodyMedium?.copyWith(
                            color: RuangBukuColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),

            // Lender Info
            Text('Lender', style: textTheme.headlineSmall),
            const SizedBox(height: RuangBukuSpacing.md),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://picsum.photos/seed/${book.ownerId}/100/100'),
                ),
                const SizedBox(width: RuangBukuSpacing.md),
                Text(book.ownerName, style: textTheme.titleMedium),
                const SizedBox(width: RuangBukuSpacing.sm),
                const Icon(Icons.verified, color: RuangBukuColors.primary, size: 16),
              ],
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Form Fields
            Text('Borrow Details', style: textTheme.headlineSmall),
            const SizedBox(height: RuangBukuSpacing.md),
            
            // Pickup Date Input
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Pickup Date',
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  _formatDate(_pickupDate),
                  style: TextStyle(
                    color: _pickupDate == null ? RuangBukuColors.textSecondary.withValues(alpha: 0.6) : RuangBukuColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            
            // Return Date Input
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Return Date',
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  _formatDate(_returnDate),
                  style: TextStyle(
                    color: _returnDate == null ? RuangBukuColors.textSecondary.withValues(alpha: 0.6) : RuangBukuColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),

            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message to Lender (Optional)',
                hintText: 'Hi, I would love to borrow this book...',
                alignLabelWithHint: true,
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
          onPressed: () => _submitRequest(book),
          child: const Text('Send Request'),
        ),
      ),
    );
  }
}
