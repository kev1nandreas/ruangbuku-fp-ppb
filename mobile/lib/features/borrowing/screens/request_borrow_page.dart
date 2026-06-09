import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/services/book_service.dart';
import '../../../core/services/borrow_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/book_summary_row.dart';
import '../../../core/widgets/bottom_action_bar.dart';

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

  bool _isLoadingBook = true;
  bool _isSubmitting = false;
  BookModel? _book;

  @override
  void initState() {
    super.initState();
    _fetchBook();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchBook() async {
    setState(() => _isLoadingBook = true);
    try {
      final data = await BookService.getBookDetail(widget.bookId);
      if (mounted) {
        setState(() {
          _book = BookModel.fromJson(data);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading book: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoadingBook = false);
    }
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

  Future<void> _submitRequest(BookModel book) async {
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

    setState(() => _isSubmitting = true);
    try {
      final startDateStr = _formatDate(_pickupDate);
      final endDateStr = _formatDate(_returnDate);
      
      await BorrowService.requestBorrow(widget.bookId, startDateStr, endDateStr);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Borrowing request submitted successfully!')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.error_outline, color: RuangBukuColors.error),
                  const SizedBox(width: 8),
                  Text('Request Failed', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: RuangBukuColors.error)),
                ],
              ),
              content: Text(
                e.toString(),
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
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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

    if (_isLoadingBook) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request to Borrow')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request to Borrow')),
        body: const Center(child: Text('Book not found')),
      );
    }

    final book = _book!;

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
            AppCard(
              padding: const EdgeInsets.all(RuangBukuSpacing.lg),
              child: BookSummaryRow(
                title: book.title,
                author: book.author,
                imageUrl: book.imageUrl,
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
                  backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${book.ownerName}'),
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
      bottomSheet: BottomActionBar(
        child: _isSubmitting 
            ? const Center(child: CircularProgressIndicator()) 
            : FilledButton(
                onPressed: () => _submitRequest(book),
                child: const Text('Send Request'),
              ),
      ),
    );
  }
}
