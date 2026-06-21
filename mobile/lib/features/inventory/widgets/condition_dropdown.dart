import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Dropdown for selecting a book's physical condition. Shared by the add/edit
/// book forms.
class ConditionDropdown extends StatelessWidget {
  const ConditionDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  static const List<String> options = [
    'Like New',
    'Very Good',
    'Good',
    'Acceptable',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: AppLocalizations.of(context)?.conditionLabel ?? 'Condition'),
      initialValue: value,
      items: [
        DropdownMenuItem(value: 'Like New', child: Text(AppLocalizations.of(context)?.likeNew ?? 'Like New')),
        DropdownMenuItem(value: 'Very Good', child: Text(AppLocalizations.of(context)?.veryGood ?? 'Very Good')),
        DropdownMenuItem(value: 'Good', child: Text(AppLocalizations.of(context)?.good ?? 'Good')),
        DropdownMenuItem(value: 'Acceptable', child: Text(AppLocalizations.of(context)?.acceptable ?? 'Acceptable')),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
