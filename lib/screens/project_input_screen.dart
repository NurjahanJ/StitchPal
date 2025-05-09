import 'package:flutter/material.dart';
import 'package:stitchpal/screens/pattern_result_screen_updated.dart';
import 'package:stitchpal/services/openai_service.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/yarn_chip.dart';
import 'package:stitchpal/widgets/yarn_icon.dart';

class ProjectInputScreen extends StatefulWidget {
  const ProjectInputScreen({super.key});

  @override
  State<ProjectInputScreen> createState() => _ProjectInputScreenState();
}

class _ProjectInputScreenState extends State<ProjectInputScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _tags = ['scarf', 'blanket', 'amigurumi', 'gift', 'seasonal'];
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _generatePattern() async {
    // Get the input data
    final String description = _descriptionController.text.trim();
    final List<String> selectedTags = _selectedTags.toList();
    
    // Validate input
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your crochet project')),
      );
      return;
    }
    
    // Log the input data
    debugPrint('Description: $description');
    debugPrint('Selected Tags: $selectedTags');
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(StitchPalTheme.primaryColor),
          ),
        );
      },
    );
    
    try {
      // Generate pattern using OpenAI
      final pattern = await OpenAIService.generatePattern(description, selectedTags);
      
      // Log the pattern generation
      debugPrint('Successfully generated pattern: ${pattern.title}');
      
      // Check if the widget is still mounted before using BuildContext
      if (!mounted) return;
      
      // Close the loading dialog
      Navigator.of(context).pop();
      
      // Navigate to the pattern result screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PatternResultScreenUpdated(pattern: pattern),
        ),
      );
    } catch (e) {
      // Check if the widget is still mounted before using BuildContext
      if (!mounted) return;
      
      // Close the loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating pattern: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchPalTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('New Crochet Project'),
        backgroundColor: StitchPalTheme.surfaceColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero header with illustration
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: StitchPalTheme.surfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: StitchPalTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcoming title with yarn icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: StitchPalTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const YarnIcon(
                            size: 28,
                            color: StitchPalTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Let\'s create something beautiful!',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: StitchPalTheme.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Describe your project and we\'ll generate a custom crochet pattern just for you.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: StitchPalTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input section label
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 4),
                      child: Text(
                        'Project Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    // Enhanced multiline text field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: StitchPalTheme.primaryColor.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'E.g., A cozy winter scarf with tassels, a baby blanket with a star pattern...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: StitchPalTheme.surfaceColor,
                          contentPadding: const EdgeInsets.all(20),
                          hintStyle: TextStyle(
                            color: StitchPalTheme.textColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Tags section with improved styling
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 18,
                            color: StitchPalTheme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add Tags',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Wrap for better tag flow on different screen sizes
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _tags.map((tag) {
                        return YarnChip(
                          label: tag,
                          isSelected: _selectedTags.contains(tag),
                          onTap: () => _toggleTag(tag),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Enhanced Generate Pattern button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: StitchPalTheme.primaryColor.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _generatePattern,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.auto_awesome, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              'Generate Pattern',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Decorative element and hint text
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              height: 4,
                              width: 60,
                              decoration: BoxDecoration(
                                color: StitchPalTheme.accentColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your pattern will be generated using AI technology',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: StitchPalTheme.textColor.withOpacity(0.5),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
