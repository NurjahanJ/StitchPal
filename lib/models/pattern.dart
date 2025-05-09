class CrochetPattern {
  final String? description; // Optional description of the pattern
  final String title;
  final String skillLevel; // Beginner, Intermediate, Advanced
  final List<Material> materials;
  final List<Instruction> instructions;
  final Map<String, String> stitchAbbreviations;

  CrochetPattern({
    this.description,
    required this.title,
    required this.skillLevel,
    required this.materials,
    required this.instructions,
    required this.stitchAbbreviations,
  });

  // Sample pattern for development and testing
  static CrochetPattern getSamplePattern({String title = 'Cozy Winter Scarf'}) {
    return CrochetPattern(
      title: title,
      skillLevel: 'Beginner',
      materials: [
        Material(name: 'Yarn', details: 'Medium weight (4), 400g total'),
        Material(name: 'Hook Size', details: '5.5mm (I-9)'),
        Material(name: 'Colors', details: 'Main color: Soft Blue, Accent: Cream'),
        Material(name: 'Other', details: 'Tapestry needle for weaving in ends'),
      ],
      instructions: [
        Instruction(
          sectionTitle: 'Foundation',
          steps: [
            'Ch 30 (chain 30 stitches).',
            'Row 1: Sc in 2nd ch from hook, sc in each ch across. (29 sc)',
          ],
        ),
        Instruction(
          sectionTitle: 'Main Pattern',
          steps: [
            'Row 2: Ch 1, turn, sc in each sc across. (29 sc)',
            'Row 3: Ch 1, turn, *sc in next sc, dc in next sc; repeat from * across, ending with sc in last sc. (29 sts)',
            'Row 4: Ch 1, turn, sc in each st across. (29 sc)',
            'Row 5: Ch 1, turn, *dc in next sc, sc in next sc; repeat from * across, ending with dc in last sc. (29 sts)',
            'Rows 6-100: Repeat Rows 2-5 for pattern.',
          ],
        ),
        Instruction(
          sectionTitle: 'Border',
          steps: [
            'Round 1: Ch 1, sc evenly around entire scarf, working 3 sc in each corner; join with sl st to first sc.',
            'Round 2: Ch 1, sc in each sc around, working 3 sc in each corner sc; join with sl st to first sc. Fasten off.',
          ],
        ),
        Instruction(
          sectionTitle: 'Finishing',
          steps: [
            'Weave in all ends using tapestry needle.',
            'Block lightly if desired to even out stitches.',
          ],
        ),
      ],
      stitchAbbreviations: {
        'ch': 'chain',
        'sc': 'single crochet',
        'dc': 'double crochet',
        'st(s)': 'stitch(es)',
        'sl st': 'slip stitch',
      },
    );
  }
}

class Material {
  final String name;
  final String details;

  Material({
    required this.name,
    required this.details,
  });
}

class Instruction {
  final String sectionTitle;
  final List<String> steps;

  Instruction({
    required this.sectionTitle,
    required this.steps,
  });
}
