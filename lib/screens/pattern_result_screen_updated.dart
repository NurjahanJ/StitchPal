import 'package:flutter/material.dart';
import 'package:stitchpal/models/pattern.dart';
import 'package:stitchpal/models/saved_project.dart';
import 'package:stitchpal/services/openai_service.dart';
import 'package:stitchpal/services/project_service.dart';
import 'package:stitchpal/services/global_assistant_service.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/instruction_panel.dart';
import 'package:stitchpal/widgets/pattern_section.dart';
import 'package:stitchpal/widgets/skill_level_badge.dart';
import 'package:stitchpal/widgets/yarn_icon.dart';
import 'package:stitchpal/widgets/yarn_suggestion_card.dart';

class PatternResultScreenUpdated extends StatefulWidget {
  final CrochetPattern pattern;

  const PatternResultScreenUpdated({
    super.key,
    required this.pattern,
  });

  @override
  State<PatternResultScreenUpdated> createState() => _PatternResultScreenUpdatedState();
}

class _PatternResultScreenUpdatedState extends State<PatternResultScreenUpdated> {
  List<YarnSuggestion> _yarnSuggestions = [];
  bool _loadingYarnSuggestions = false;

  @override
  void initState() {
    super.initState();
    _fetchYarnSuggestions();
    
    // Set the current pattern context for the global assistant
    GlobalAssistantService().setPatternContext(widget.pattern);
  }
  
  @override
  void dispose() {
    // Clear the pattern context when leaving the screen
    GlobalAssistantService().setPatternContext(null);
    super.dispose();
  }

  Future<void> _fetchYarnSuggestions() async {
    if (mounted) {
      setState(() {
        _loadingYarnSuggestions = true;
      });
    }

    try {
      // Determine yarn weight from materials
      String yarnWeight = 'medium';
      for (var material in widget.pattern.materials) {
        if (material.name.toLowerCase().contains('yarn') && 
            material.details.toLowerCase().contains('weight')) {
          yarnWeight = material.details.toLowerCase();
          break;
        }
      }

      // Get yarn suggestions
      final suggestions = await OpenAIService.getYarnSuggestions(
        widget.pattern.title,
        yarnWeight,
      );

      if (mounted) {
        setState(() {
          _yarnSuggestions = suggestions;
          _loadingYarnSuggestions = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching yarn suggestions: $e');
      if (mounted) {
        setState(() {
          _loadingYarnSuggestions = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchPalTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Pattern'),
        backgroundColor: StitchPalTheme.primaryColor,
      ),
      // Global StitchPal assistant is now available from the main navigation
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
                
                const SizedBox(height: 24),
                
                // Materials list using the PatternSection widget
                PatternSection(
                  title: 'Materials',
                  icon: Icon(
                    Icons.shopping_basket_outlined,
                    color: StitchPalTheme.primaryColor,
                    size: 20,
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.pattern.materials.map((material) => Padding(
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
                
                // Yarn suggestions section
                _buildYarnSuggestionsSection(context),
                
                const SizedBox(height: 24),
                
                // Instructions section using PatternSection widget
                PatternSection(
                  title: 'Instructions',
                  icon: const YarnIcon(size: 24),
                  scrollable: true,
                  maxHeight: 300,
                  content: Column(
                    children: widget.pattern.instructions.map((instruction) => 
                      InstructionPanel(instruction: instruction)
                    ).toList(),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Stitch abbreviations section
                PatternSection(
                  title: 'Stitch Abbreviations',
                  icon: Icon(
                    Icons.info_outline,
                    color: StitchPalTheme.primaryColor,
                    size: 20,
                  ),
                  content: Column(
                    children: widget.pattern.stitchAbbreviations.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Abbreviation
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: StitchPalTheme.accentColor.withOpacity(0.3),
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
          widget.pattern.title,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        
        const SizedBox(height: 8),
        
        // Pattern description (if available)
        if (widget.pattern.description != null)
          Text(
            widget.pattern.description!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: StitchPalTheme.textColor.withOpacity(0.8),
            ),
          ),
        
        const SizedBox(height: 12),
        
        // Skill level badge
        Row(
          children: [
            SkillLevelBadge(level: widget.pattern.skillLevel),
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

  Widget _buildYarnSuggestionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Yarns',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'DM Serif Display',
          ),
        ),
        const SizedBox(height: 12),
        if (_loadingYarnSuggestions)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(StitchPalTheme.primaryColor),
              ),
            ),
          )
        else if (_yarnSuggestions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No yarn suggestions available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: StitchPalTheme.textColor.withOpacity(0.7),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _yarnSuggestions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return YarnSuggestionCard(suggestion: _yarnSuggestions[index]);
            },
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
              // Create a new saved project
              final savedProject = SavedProject(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                pattern: widget.pattern,
                savedDate: DateTime.now(),
                progress: 0.0,
                tags: [], // Default empty tags, user can add later
                completedSteps: List.generate(
                  widget.pattern.instructions.fold(
                    0, (sum, instruction) => sum + instruction.steps.length),
                  (index) => false
                ),
                yarnSuggestions: _yarnSuggestions, // Save the yarn recommendations
              );
              
              // Save the project using the project service
              ProjectService().saveProject(savedProject);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pattern saved to My Projects'),
                  backgroundColor: StitchPalTheme.primaryColor,
                  action: SnackBarAction(
                    label: 'View',
                    textColor: StitchPalTheme.textColor,
                    onPressed: () {
                      // Navigate to saved projects screen
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/saved_projects',
                        (route) => false,
                      );
                    },
                  ),
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
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Regenerate Pattern?'),
                    content: const Text(
                      'This will create a new pattern based on your original description. Any changes you have made will be lost.'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Show loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Regenerating pattern...'),
                              backgroundColor: StitchPalTheme.primaryColor,
                              duration: Duration(seconds: 1),
                            ),
                          );
                          // Navigate back to trigger regeneration
                          Navigator.of(context).pop();
                        },
                        child: const Text('Regenerate'),
                      ),
                    ],
                  );
                },
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
