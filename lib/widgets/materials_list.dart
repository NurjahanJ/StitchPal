import 'package:flutter/material.dart';
import 'package:stitchpal/models/pattern.dart' as pattern_model;
import 'package:stitchpal/theme.dart';

class MaterialsList extends StatelessWidget {
  final List<pattern_model.Material> materials;

  const MaterialsList({
    super.key,
    required this.materials,
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
            // Materials header
            Row(
              children: [
                Icon(
                  Icons.shopping_basket_outlined,
                  color: StitchPalTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Materials',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Materials list
            ...materials.map((material) => _buildMaterialItem(context, material)),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialItem(BuildContext context, pattern_model.Material material) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative yarn ball
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
          
          // Material name and details
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
                const SizedBox(height: 2),
                Text(
                  material.details,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: StitchPalTheme.textColor.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
