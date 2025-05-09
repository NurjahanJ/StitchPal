import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/yarn_icon.dart';

/// A reusable widget for displaying a titled section in the pattern screens
class PatternSection extends StatelessWidget {
  /// The title of the section
  final String title;
  
  /// The icon to display next to the title (defaults to yarn icon)
  final Widget? icon;
  
  /// The content of the section
  final Widget content;
  
  /// Whether the content should be scrollable
  final bool scrollable;
  
  /// Maximum height for scrollable content
  final double? maxHeight;
  
  /// Optional padding for the content
  final EdgeInsetsGeometry contentPadding;

  const PatternSection({
    super.key,
    required this.title,
    this.icon,
    required this.content,
    this.scrollable = false,
    this.maxHeight,
    this.contentPadding = const EdgeInsets.only(top: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: StitchPalTheme.safeAlpha(StitchPalTheme.accentColor, 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with icon
            Row(
              children: [
                icon ?? const YarnIcon(size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            // Content with optional scrolling
            Padding(
              padding: contentPadding,
              child: scrollable 
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: maxHeight ?? 200,
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: content,
                      ),
                    ),
                  )
                : content,
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget for displaying a list of items with bullet points
class BulletPointList extends StatelessWidget {
  final List<String> items;
  final TextStyle? itemStyle;
  final Color bulletColor;
  final double bulletSize;
  final double spacing;

  const BulletPointList({
    super.key,
    required this.items,
    this.itemStyle,
    this.bulletColor = StitchPalTheme.accentColor,
    this.bulletSize = 8,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: bulletSize,
              height: bulletSize,
              margin: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: bulletColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Text(
                item,
                style: itemStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
