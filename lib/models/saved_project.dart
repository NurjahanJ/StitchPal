import 'package:stitchpal/models/pattern.dart';
import 'package:stitchpal/services/openai_service.dart';

class SavedProject {
  final String id;
  final CrochetPattern pattern;
  final DateTime savedDate;
  final double progress; // 0.0 to 1.0
  final List<String> tags;
  final List<bool> completedSteps;
  final List<YarnSuggestion> yarnSuggestions;

  SavedProject({
    required this.id,
    required this.pattern,
    required this.savedDate,
    required this.progress,
    required this.tags,
    required this.completedSteps,
    this.yarnSuggestions = const [],
  });

  // Create a copy with updated fields
  SavedProject copyWith({
    String? id,
    CrochetPattern? pattern,
    DateTime? savedDate,
    double? progress,
    List<String>? tags,
    List<bool>? completedSteps,
    List<YarnSuggestion>? yarnSuggestions,
  }) {
    return SavedProject(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      savedDate: savedDate ?? this.savedDate,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      completedSteps: completedSteps ?? this.completedSteps,
      yarnSuggestions: yarnSuggestions ?? this.yarnSuggestions,
    );
  }

  // Get total number of steps across all instructions
  int get totalSteps {
    return pattern.instructions.fold(0, (sum, instruction) => sum + instruction.steps.length);
  }

  // Get number of completed steps
  int get completedStepCount {
    return completedSteps.where((isCompleted) => isCompleted).length;
  }

  // Sample projects for development and testing
  static List<SavedProject> getSampleProjects() {
    final samplePattern = CrochetPattern.getSamplePattern();
    
    // Create a list to track completed steps for the sample pattern
    final totalStepsCount = samplePattern.instructions.fold(
      0, (sum, instruction) => sum + instruction.steps.length);
    
    // Sample yarn suggestions
    final sampleYarnSuggestions = [
      YarnSuggestion(
        brandName: 'Lion Brand',
        yarnName: 'Wool-Ease',
        colors: ['Blue Mist', 'Fisherman', 'Rose Heather'],
        storeUrl: 'https://www.lionbrand.com/products/wool-ease-yarn',
      ),
      YarnSuggestion(
        brandName: 'Bernat',
        yarnName: 'Softee Chunky',
        colors: ['True Grey', 'Natural', 'Dark Grey'],
        storeUrl: 'https://www.yarnspirations.com/bernat-softee-chunky-yarn/161128.html',
      ),
    ];
    
    return [
      SavedProject(
        id: '1',
        pattern: samplePattern,
        savedDate: DateTime.now().subtract(const Duration(days: 7)),
        progress: 0.75,
        tags: ['scarf', 'winter'],
        completedSteps: List.generate(totalStepsCount, (index) => index < totalStepsCount * 0.75),
        yarnSuggestions: sampleYarnSuggestions,
      ),
      SavedProject(
        id: '2',
        pattern: CrochetPattern(
          title: 'Amigurumi Bunny',
          skillLevel: 'Intermediate',
          materials: [
            Material(name: 'Yarn', details: 'Light weight (3), 150g total'),
            Material(name: 'Hook Size', details: '3.5mm (E-4)'),
            Material(name: 'Colors', details: 'Main: Pink, Accent: White'),
            Material(name: 'Other', details: 'Stuffing, safety eyes, tapestry needle'),
          ],
          instructions: [
            Instruction(
              sectionTitle: 'Head',
              steps: [
                'Magic ring, 6 sc into ring.',
                'Rnd 1: 2 sc in each sc around. (12 sc)',
                'Rnd 2: *Sc in next sc, 2 sc in next sc; repeat from * around. (18 sc)',
              ],
            ),
            Instruction(
              sectionTitle: 'Body',
              steps: [
                'Magic ring, 6 sc into ring.',
                'Rnd 1: 2 sc in each sc around. (12 sc)',
                'Rnd 2: *Sc in next sc, 2 sc in next sc; repeat from * around. (18 sc)',
                'Rnd 3: *Sc in next 2 sc, 2 sc in next sc; repeat from * around. (24 sc)',
              ],
            ),
          ],
          stitchAbbreviations: {
            'sc': 'single crochet',
            'rnd': 'round',
            'st(s)': 'stitch(es)',
          },
        ),
        savedDate: DateTime.now().subtract(const Duration(days: 2)),
        progress: 0.3,
        tags: ['amigurumi', 'gift'],
        completedSteps: List.generate(7, (index) => index < 2),
        yarnSuggestions: [
          YarnSuggestion(
            brandName: 'Caron',
            yarnName: 'Simply Soft',
            colors: ['Soft Pink', 'White', 'Baby Pink'],
            storeUrl: 'https://www.yarnspirations.com/caron-simply-soft-yarn/H97003.html',
          ),
          YarnSuggestion(
            brandName: 'Red Heart',
            yarnName: 'Super Saver',
            colors: ['Pretty Pink', 'White', 'Baby Pink'],
            storeUrl: 'https://www.yarnspirations.com/red-heart-super-saver-yarn/E300.html',
          ),
        ],
      ),
      SavedProject(
        id: '3',
        pattern: CrochetPattern(
          title: 'Summer Tote Bag',
          skillLevel: 'Beginner',
          materials: [
            Material(name: 'Yarn', details: 'Cotton, medium weight (4), 300g total'),
            Material(name: 'Hook Size', details: '5.0mm (H-8)'),
            Material(name: 'Colors', details: 'Main: Teal, Accent: Cream'),
            Material(name: 'Other', details: 'Tapestry needle, optional lining fabric'),
          ],
          instructions: [
            Instruction(
              sectionTitle: 'Base',
              steps: [
                'Ch 31.',
                'Row 1: Sc in 2nd ch from hook and in each ch across. (30 sc)',
                'Rows 2-15: Ch 1, turn, sc in each sc across. (30 sc)',
              ],
            ),
            Instruction(
              sectionTitle: 'Sides',
              steps: [
                'Round 1: Continue working around the rectangle. Work 1 sc in each stitch along the short side, 30 sc along the long side, 1 sc in each stitch along the other short side, and 30 sc along the remaining long side. Join with sl st to first sc. (64 sc)',
                'Rounds 2-20: Ch 1, sc in each sc around. Join with sl st to first sc. (64 sc)',
              ],
            ),
            Instruction(
              sectionTitle: 'Handles',
              steps: [
                'Ch 50, skip 10 sc on the bag, sl st in next sc. Ch 1, turn, sc in each ch back to bag. Continue sc around bag until 10 sc before starting point of first handle. Ch 50, skip 10 sc on bag, sl st in next sc. Ch 1, turn, sc in each ch back to bag. Continue sc around to starting point. Join with sl st to first sc.',
              ],
            ),
          ],
          stitchAbbreviations: {
            'ch': 'chain',
            'sc': 'single crochet',
            'sl st': 'slip stitch',
          },
        ),
        savedDate: DateTime.now().subtract(const Duration(days: 14)),
        progress: 0.5,
        tags: ['bag', 'seasonal', 'summer'],
        completedSteps: List.generate(6, (index) => index < 3),
        yarnSuggestions: [
          YarnSuggestion(
            brandName: 'Lily Sugar n Cream',
            yarnName: 'Cotton Yarn',
            colors: ['Teal', 'Ecru', 'Sage Green'],
            storeUrl: 'https://www.yarnspirations.com/lily-sugarn-cream-the-original-yarn/102001.html',
          ),
          YarnSuggestion(
            brandName: 'Bernat',
            yarnName: 'Handicrafter Cotton',
            colors: ['Aqua', 'Off White', 'Sage'],
            storeUrl: 'https://www.yarnspirations.com/bernat-handicrafter-cotton-yarn/10775.html',
          ),
          YarnSuggestion(
            brandName: 'Lion Brand',
            yarnName: '24/7 Cotton',
            colors: ['Jade', 'Ecru', 'Mint'],
            storeUrl: 'https://www.lionbrand.com/products/24-7-cotton-yarn',
          ),
        ],
      ),
    ];
  }
}
