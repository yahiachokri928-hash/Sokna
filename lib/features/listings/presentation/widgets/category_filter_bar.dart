import 'package:flutter/material.dart';
import '../../../../core/strings/messages.dart';

class CategoryFilterBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  static const List<String> categories = [
    CATEGORY_ALL,
    CATEGORY_APPARTEMENT,
    CATEGORY_VILLA,
    CATEGORY_STUDIO,
    CATEGORY_MAISON,
  ];

  const CategoryFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.toLowerCase() == selectedCategory.toLowerCase();

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onSelected(category);
              }
            },
            showCheckmark: false,
            selectedColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            labelStyle: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          );
        },
      ),
    );
  }
}
