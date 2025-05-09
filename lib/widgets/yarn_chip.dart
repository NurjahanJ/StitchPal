import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stitchpal/theme.dart';

/// A custom chip widget with yarn-themed styling
class YarnChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const YarnChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get tag-specific color based on label
    final Color tagColor = StitchPalTheme.getTagColor(label);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          splashColor: tagColor.withOpacity(0.3),
          highlightColor: tagColor.withOpacity(0.1),
          child: Ink(
            decoration: BoxDecoration(
              color: isSelected 
                  ? tagColor.withOpacity(0.15)
                  : StitchPalTheme.surfaceColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected 
                    ? tagColor
                    : StitchPalTheme.dividerColor,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected 
                  ? [
                      BoxShadow(
                        color: tagColor.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ] 
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[  
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: tagColor,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? tagColor : StitchPalTheme.textColor.withOpacity(0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
