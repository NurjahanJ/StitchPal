import 'package:flutter/material.dart';
import 'package:stitchpal/models/pattern.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/instruction_panel.dart';
import 'package:stitchpal/widgets/pattern_section.dart';
import 'package:stitchpal/widgets/skill_level_badge.dart';
import 'package:stitchpal/widgets/yarn_icon.dart';

class PatternResultScreen extends StatelessWidget {
  final CrochetPattern pattern;

  const PatternResultScreen({
    super.key,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchPalTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Pattern'),
        backgroundColor: StitchPalTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pattern title and skill level badge
                _buildTitleSection(context),
                
                const SizedBox(height: 24),
                
                // Materials list using the new PatternSection widget
                PatternSection(
                  title: 'Materials',
                  icon: Icon(
                    Icons.shopping_basket_outlined,
                    color: StitchPalTheme.primaryColor,
                    size: 20,
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pattern.materials.map((material) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              color: StitchPalTheme.accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  material.name,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  material.details,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Instructions section using PatternSection widget
                PatternSection(
                  title: 'Instructions',
                  icon: const YarnIcon(size: 24),
                  scrollable: true,
                  maxHeight: 300,
                  content: Column(
                    children: pattern.instructions.map((instruction) => 
                      InstructionPanel(instruction: instruction)
                    ).toList(),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Stitch abbreviations legend using PatternSection widget
                PatternSection(
                  title: 'Stitch Legend',
                  icon: Icon(
                    Icons.info_outline,
                    color: StitchPalTheme.primaryColor,
                    size: 20,
                  ),
                  content: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: pattern.stitchAbbreviations.entries.map((entry) {
                      return SizedBox(
                        width: 140,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Abbreviation
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: StitchPalTheme.accentColor.withAlpha(
                                  (StitchPalTheme.accentColor.a * 0.3).round()
                                ),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: StitchPalTheme.accentColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                entry.key,
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
                                entry.value,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Action buttons
                _buildActionButtons(context),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pattern title
        Text(
          pattern.title,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        
        const SizedBox(height: 12),
        
        // Skill level badge
        Row(
          children: [
            SkillLevelBadge(level: pattern.skillLevel),
          ],
        ),
        
        // Decorative divider
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 2,
            width: 100,
            decoration: BoxDecoration(
              color: StitchPalTheme.primaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Save to My Projects button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pattern saved to My Projects'),
                  backgroundColor: StitchPalTheme.primaryColor,
                ),
              );
            },
            icon: const Icon(Icons.bookmark_border),
            label: const Text('Save to My Projects'),
            style: ElevatedButton.styleFrom(
              backgroundColor: StitchPalTheme.secondaryColor,
              foregroundColor: StitchPalTheme.textColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Regenerate button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Regenerating pattern...'),
                  backgroundColor: StitchPalTheme.primaryColor,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Regenerate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: StitchPalTheme.primaryColor,
              foregroundColor: StitchPalTheme.textColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
