import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class StitchGuide extends StatefulWidget {
  const StitchGuide({super.key});

  @override
  State<StitchGuide> createState() => _StitchGuideState();
}

class _StitchGuideState extends State<StitchGuide> {
  final List<StitchInfo> _stitches = [
    StitchInfo(
      name: 'Chain Stitch (ch)',
      description: 'The foundation of most crochet projects.',
      steps: [
        'Make a slip knot and place it on your hook.',
        'Yarn over (wrap the yarn around your hook).',
        'Pull the yarn through the loop on your hook.',
        'Repeat for desired number of chains.'
      ],
      imageAsset: 'assets/images/chain_stitch.png',
    ),
    StitchInfo(
      name: 'Single Crochet (sc)',
      description: 'Creates a tight, solid fabric.',
      steps: [
        'Insert hook into the specified stitch or chain.',
        'Yarn over and pull up a loop (2 loops on hook).',
        'Yarn over again and pull through both loops on hook.',
      ],
      imageAsset: 'assets/images/single_crochet.png',
    ),
    StitchInfo(
      name: 'Half Double Crochet (hdc)',
      description: 'Taller than single crochet but shorter than double crochet.',
      steps: [
        'Yarn over before inserting hook into the stitch.',
        'Insert hook into the specified stitch or chain.',
        'Yarn over and pull up a loop (3 loops on hook).',
        'Yarn over again and pull through all 3 loops on hook.',
      ],
      imageAsset: 'assets/images/half_double_crochet.png',
    ),
    StitchInfo(
      name: 'Double Crochet (dc)',
      description: 'Creates a taller, more open fabric than single crochet.',
      steps: [
        'Yarn over before inserting hook into the stitch.',
        'Insert hook into the specified stitch or chain.',
        'Yarn over and pull up a loop (3 loops on hook).',
        'Yarn over and pull through first 2 loops (2 loops on hook).',
        'Yarn over again and pull through remaining 2 loops.',
      ],
      imageAsset: 'assets/images/double_crochet.png',
    ),
    StitchInfo(
      name: 'Treble Crochet (tr)',
      description: 'Even taller than double crochet, creates a very open fabric.',
      steps: [
        'Yarn over twice before inserting hook into the stitch.',
        'Insert hook into the specified stitch or chain.',
        'Yarn over and pull up a loop (4 loops on hook).',
        'Yarn over and pull through first 2 loops (3 loops on hook).',
        'Yarn over and pull through next 2 loops (2 loops on hook).',
        'Yarn over again and pull through remaining 2 loops.',
      ],
      imageAsset: 'assets/images/treble_crochet.png',
    ),
    StitchInfo(
      name: 'Slip Stitch (sl st)',
      description: 'Used to join rounds or move across a row without adding height.',
      steps: [
        'Insert hook into the specified stitch or chain.',
        'Yarn over and pull directly through both the stitch and the loop on your hook.',
      ],
      imageAsset: 'assets/images/slip_stitch.png',
    ),
    StitchInfo(
      name: 'Cluster Stitch',
      description: 'Multiple stitches worked together into one stitch.',
      steps: [
        'Begin first double crochet but stop before final yarn over (2 loops on hook).',
        'Begin second double crochet in same stitch but stop before final yarn over (3 loops on hook).',
        'Yarn over and pull through all loops on hook.',
      ],
      imageAsset: 'assets/images/cluster_stitch.png',
    ),
    StitchInfo(
      name: 'Bobble Stitch',
      description: 'Creates a raised, textured bump.',
      steps: [
        'Work 5 unfinished double crochets in the same stitch, keeping the last loop of each on the hook.',
        'Yarn over and pull through all 6 loops on the hook.',
        'Chain 1 to secure the bobble.',
      ],
      imageAsset: 'assets/images/bobble_stitch.png',
    ),
    StitchInfo(
      name: 'Shell Stitch',
      description: 'Multiple stitches worked into the same stitch, creating a fan or shell shape.',
      steps: [
        'Work 5 double crochets into the same stitch or space.',
        'Skip specified number of stitches (usually 2-3).',
        'Repeat pattern across row.',
      ],
      imageAsset: 'assets/images/shell_stitch.png',
    ),
    StitchInfo(
      name: 'Popcorn Stitch',
      description: 'Creates a rounded, popcorn-like texture.',
      steps: [
        'Work 5 double crochets in the same stitch.',
        'Remove hook from the loop and insert it into the first double crochet.',
        'Grab the dropped loop and pull it through the first double crochet.',
        'Chain 1 to secure the popcorn.',
      ],
      imageAsset: 'assets/images/popcorn_stitch.png',
    ),
  ];

  String _searchQuery = '';
  List<StitchInfo> get _filteredStitches {
    if (_searchQuery.isEmpty) {
      return _stitches;
    }
    return _stitches.where((stitch) => 
      stitch.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      stitch.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: StitchPalTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: StitchPalTheme.primaryColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search stitches...',
                prefixIcon: const Icon(Icons.search, color: StitchPalTheme.primaryColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stitch count
          Text(
            '${_filteredStitches.length} Stitches',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: StitchPalTheme.textColor.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Stitch list
          Expanded(
            child: _filteredStitches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: StitchPalTheme.textColor.withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No stitches found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: StitchPalTheme.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredStitches.length,
                    itemBuilder: (context, index) {
                      final stitch = _filteredStitches[index];
                      return _buildStitchCard(context, stitch);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStitchCard(BuildContext context, StitchInfo stitch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: StitchPalTheme.dividerColor,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          stitch.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          stitch.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: StitchPalTheme.textColor.withOpacity(0.7),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: StitchPalTheme.primaryColor.withOpacity(0.1),
          child: Image.asset(
            stitch.imageAsset,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.fiber_manual_record,
                color: StitchPalTheme.primaryColor,
              );
            },
          ),
        ),
        children: [
          const SizedBox(height: 8),
          ...stitch.steps.asMap().entries.map((entry) {
            int idx = entry.key;
            String step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: StitchPalTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${idx + 1}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class StitchInfo {
  final String name;
  final String description;
  final List<String> steps;
  final String imageAsset;

  StitchInfo({
    required this.name,
    required this.description,
    required this.steps,
    required this.imageAsset,
  });
}
