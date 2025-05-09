import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class StepChecklistItem extends StatelessWidget {
  final String stepText;
  final bool isCompleted;
  final Function(bool) onToggle;
  final bool isCurrent;

  const StepChecklistItem({
    super.key,
    required this.stepText,
    required this.isCompleted,
    required this.onToggle,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrent 
            ? StitchPalTheme.primaryColor.withOpacity(0.1) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent 
            ? Border.all(color: StitchPalTheme.primaryColor, width: 1.5)
            : null,
      ),
      child: CheckboxListTile(
        value: isCompleted,
        onChanged: (value) => onToggle(value ?? false),
        title: Text(
          stepText,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted 
                ? StitchPalTheme.textColor.withOpacity(0.6) 
                : StitchPalTheme.textColor,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        activeColor: StitchPalTheme.primaryColor,
        checkColor: StitchPalTheme.textColor,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
