import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

/// Bottom sheet for advanced book filtering (currently genre selection).
/// Mutates [selectedGenres] in place and calls [onApply] when applied.
Future<void> showAdvancedFilterSheet(
  BuildContext context, {
  required List<String> selectedGenres,
  required VoidCallback onApply,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    builder: (context) => _AdvancedFilterSheet(
      selectedGenres: selectedGenres,
      onApply: onApply,
    ),
  );
}

class _AdvancedFilterSheet extends StatefulWidget {
  const _AdvancedFilterSheet({
    required this.selectedGenres,
    required this.onApply,
  });

  final List<String> selectedGenres;
  final VoidCallback onApply;

  @override
  State<_AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<_AdvancedFilterSheet> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final genres = RuangBukuState.instance.genres;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          RuangBukuSpacing.xl,
          RuangBukuSpacing.md,
          RuangBukuSpacing.xl,
          RuangBukuSpacing.xl + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: RuangBukuSpacing.md),
                decoration: BoxDecoration(
                  color: RuangBukuColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            Text('Advanced Filter', style: textTheme.titleLarge),
            const SizedBox(height: RuangBukuSpacing.lg),
            Text('Genre', style: textTheme.titleMedium),
            const SizedBox(height: RuangBukuSpacing.md),
            if (genres.isEmpty)
              const Text('Tidak ada genre tersedia.')
            else
              Wrap(
                spacing: RuangBukuSpacing.sm,
                children: genres.map((g) {
                  final isSelected = widget.selectedGenres.contains(g.id);
                  return ChoiceChip(
                    label: Text(g.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          widget.selectedGenres.add(g.id);
                        } else {
                          widget.selectedGenres.remove(g.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: RuangBukuSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onApply();
                  Navigator.pop(context);
                },
                child: const Text('Terapkan Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
