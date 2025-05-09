import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class SkillLevelBadge extends StatelessWidget {
  final String level;

  const SkillLevelBadge({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData badgeIcon;

    // Determine color and icon based on skill level
    switch (level.toLowerCase()) {
      case 'beginner':
        badgeColor = Colors.green.shade200;
        badgeIcon = Icons.star_outline;
        break;
      case 'intermediate':
        badgeColor = Colors.orange.shade200;
        badgeIcon = Icons.star_half;
        break;
      case 'advanced':
        badgeColor = Colors.red.shade200;
        badgeIcon = Icons.star;
        break;
      default:
        badgeColor = Colors.blue.shade200;
        badgeIcon = Icons.star_border;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            size: 16,
            color: badgeColor.withOpacity(0.8),
          ),
          const SizedBox(width: 6),
          Text(
            level,
            style: TextStyle(
              color: StitchPalTheme.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
