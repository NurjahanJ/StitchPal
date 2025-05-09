import 'package:flutter/material.dart';
import 'package:stitchpal/services/openai_service.dart';
import 'package:stitchpal/theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// A card widget to display yarn suggestions with a button to shop online
class YarnSuggestionCard extends StatelessWidget {
  final YarnSuggestion suggestion;

  const YarnSuggestionCard({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand and yarn name
            Text(
              suggestion.brandName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              suggestion.yarnName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            
            // Color options
            Text(
              'Available Colors:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: suggestion.colors
                  .map((color) => Chip(
                        label: Text(color),
                        backgroundColor: StitchPalTheme.bgBeige,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            
            // Shop button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(suggestion.storeUrl),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Shop Online'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: StitchPalTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Launch the store URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }
}

/// A section widget to display multiple yarn suggestions
class YarnSuggestionsSection extends StatelessWidget {
  final List<YarnSuggestion> suggestions;

  const YarnSuggestionsSection({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Recommended Yarns',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'DM Serif Display',
                ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: YarnSuggestionCard(suggestion: suggestions[index]),
            );
          },
        ),
      ],
    );
  }
}
