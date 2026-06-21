import 'package:flutter/material.dart';
import '../theme.dart';

/// Pill-shaped search input used on the discovery screens.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search books or neighbors...',
    this.onClear,
    this.idleSuffixIcon,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  /// Called when the clear (✕) button is tapped. The clear button only shows
  /// when the field is non-empty.
  final VoidCallback? onClear;

  /// Optional icon shown on the trailing edge when the field is empty.
  final Widget? idleSuffixIcon;

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.isNotEmpty;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: hasText
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : idleSuffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: RuangBukuRadius.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RuangBukuRadius.borderRadiusFull,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RuangBukuRadius.borderRadiusFull,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: RuangBukuSpacing.xl,
          vertical: RuangBukuSpacing.lg,
        ),
      ),
    );
  }
}
