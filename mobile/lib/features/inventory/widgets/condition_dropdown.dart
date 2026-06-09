import 'package:flutter/material.dart';

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
      decoration: const InputDecoration(labelText: 'Condition'),
      initialValue: value,
      items: options
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
