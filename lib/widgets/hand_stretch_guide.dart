import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class HandStretchGuide extends StatelessWidget {
  const HandStretchGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hand Stretch Guide'),
        backgroundColor: StitchPalTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crochet Hand Stretches',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: StitchPalTheme.primaryColor,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Prevent hand fatigue and strain with these simple stretches',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: StitchPalTheme.textColor.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildStretchCard(
              context,
              title: 'Wrist Flexor Stretch',
              instructions: [
                'Extend your arm with palm up',
                'Gently pull fingers back toward your body with other hand',
                'Hold for 15-30 seconds',
                'Repeat with other hand'
              ],
              icon: Icons.back_hand,
            ),
            
            _buildStretchCard(
              context,
              title: 'Finger Spread',
              instructions: [
                'Hold your hands out in front of you',
                'Spread your fingers as wide as possible',
                'Hold for 5-10 seconds',
                'Relax and repeat 3-5 times'
              ],
              icon: Icons.front_hand,
            ),
            
            _buildStretchCard(
              context,
              title: 'Thumb Circles',
              instructions: [
                'Make a loose fist with your thumb outside',
                'Rotate your thumb in circles',
                'Do 5 circles in each direction',
                'Repeat with other hand'
              ],
              icon: Icons.thumb_up_alt,
            ),
            
            _buildStretchCard(
              context,
              title: 'Prayer Stretch',
              instructions: [
                'Place palms together in front of your chest',
                'Keeping palms together, slowly lower your hands',
                'Stop when you feel a gentle stretch in your wrists',
                'Hold for 15-30 seconds'
              ],
              icon: Icons.volunteer_activism,
            ),
            
            _buildStretchCard(
              context,
              title: 'Wrist Rotation',
              instructions: [
                'Extend arms in front of you',
                'Make loose fists with both hands',
                'Rotate wrists in circles',
                'Do 10 circles in each direction'
              ],
              icon: Icons.rotate_right,
            ),
            
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: StitchPalTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: StitchPalTheme.accentColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: StitchPalTheme.accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Important Tips',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: StitchPalTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Take breaks every 30 minutes when crocheting\n'
                    '• Stop if you feel pain (not just tension)\n'
                    '• Use ergonomic hooks if possible\n'
                    '• Maintain good posture while crocheting\n'
                    '• Stay hydrated during crafting sessions',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStretchCard(
    BuildContext context, {
    required String title,
    required List<String> instructions,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: StitchPalTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            icon,
            color: StitchPalTheme.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: instructions.asMap().entries.map((entry) {
              final index = entry.key;
              final instruction = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(instruction),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
