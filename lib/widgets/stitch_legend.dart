import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class StitchLegend extends StatelessWidget {
  final Map<String, String> abbreviations;

  const StitchLegend({
    super.key,
    required this.abbreviations,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: StitchPalTheme.accentColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Legend header
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: StitchPalTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Stitch Legend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Abbreviations grid
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: abbreviations.entries.map((entry) {
                return _buildAbbreviationItem(context, entry.key, entry.value);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbbreviationItem(BuildContext context, String abbr, String meaning) {
    return SizedBox(
      width: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Abbreviation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: StitchPalTheme.accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: StitchPalTheme.accentColor,
                width: 1,
              ),
            ),
            child: Text(
              abbr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Meaning
          Expanded(
            child: Text(
              meaning,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
