import 'package:flutter/material.dart';
import 'package:stitchpal/models/pattern.dart';
import 'package:stitchpal/theme.dart';

class InstructionPanel extends StatefulWidget {
  final Instruction instruction;

  const InstructionPanel({
    super.key,
    required this.instruction,
  });

  @override
  State<InstructionPanel> createState() => _InstructionPanelState();
}

class _InstructionPanelState extends State<InstructionPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: StitchPalTheme.accentColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Yarn ball decoration
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: StitchPalTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Section title
                  Expanded(
                    child: Text(
                      widget.instruction.sectionTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  
                  // Expand/collapse icon
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: StitchPalTheme.textColor.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
          
          // Collapsible content
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: _buildInstructionSteps(),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionSteps() {
    return Container(
      padding: const EdgeInsets.only(
        left: 36,
        right: 16,
        bottom: 16,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.instruction.steps.map((step) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: StitchPalTheme.accentColor,
                    shape: BoxShape.circle,
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
      ),
    );
  }
}
