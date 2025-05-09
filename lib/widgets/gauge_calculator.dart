import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stitchpal/theme.dart';

class GaugeCalculator extends StatefulWidget {
  const GaugeCalculator({super.key});

  @override
  State<GaugeCalculator> createState() => _GaugeCalculatorState();
}

class _GaugeCalculatorState extends State<GaugeCalculator> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for pattern gauge
  final _patternRowsController = TextEditingController();
  final _patternStitchesController = TextEditingController();
  final _patternHeightController = TextEditingController();
  final _patternWidthController = TextEditingController();
  
  // Controllers for your gauge
  final _yourRowsController = TextEditingController();
  final _yourStitchesController = TextEditingController();
  final _yourHeightController = TextEditingController();
  final _yourWidthController = TextEditingController();
  
  // Results
  double? _rowAdjustment;
  double? _stitchAdjustment;
  
  @override
  void dispose() {
    _patternRowsController.dispose();
    _patternStitchesController.dispose();
    _patternHeightController.dispose();
    _patternWidthController.dispose();
    _yourRowsController.dispose();
    _yourStitchesController.dispose();
    _yourHeightController.dispose();
    _yourWidthController.dispose();
    super.dispose();
  }
  
  void _calculateGauge() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Calculate row adjustment
        if (_patternRowsController.text.isNotEmpty && 
            _yourRowsController.text.isNotEmpty) {
          double patternRows = double.parse(_patternRowsController.text);
          double yourRows = double.parse(_yourRowsController.text);
          _rowAdjustment = patternRows / yourRows;
        }
        
        // Calculate stitch adjustment
        if (_patternStitchesController.text.isNotEmpty && 
            _yourStitchesController.text.isNotEmpty) {
          double patternStitches = double.parse(_patternStitchesController.text);
          double yourStitches = double.parse(_yourStitchesController.text);
          _stitchAdjustment = patternStitches / yourStitches;
        }
      });
    }
  }
  
  void _resetForm() {
    _patternRowsController.clear();
    _patternStitchesController.clear();
    _patternHeightController.clear();
    _patternWidthController.clear();
    _yourRowsController.clear();
    _yourStitchesController.clear();
    _yourHeightController.clear();
    _yourWidthController.clear();
    
    setState(() {
      _rowAdjustment = null;
      _stitchAdjustment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Gauge Calculator', 
              'Compare your gauge with the pattern gauge to adjust your project accordingly.'),
            
            const SizedBox(height: 24),
            
            // Pattern Gauge Section
            _buildGaugeSection(
              context,
              title: 'Pattern Gauge',
              subtitle: 'Enter the gauge information from your pattern',
              rowsController: _patternRowsController,
              stitchesController: _patternStitchesController,
              heightController: _patternHeightController,
              widthController: _patternWidthController,
            ),
            
            const SizedBox(height: 24),
            
            // Your Gauge Section
            _buildGaugeSection(
              context,
              title: 'Your Gauge',
              subtitle: 'Enter your actual gauge from your swatch',
              rowsController: _yourRowsController,
              stitchesController: _yourStitchesController,
              heightController: _yourHeightController,
              widthController: _yourWidthController,
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calculateGauge,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Results Section
            if (_rowAdjustment != null || _stitchAdjustment != null)
              _buildResultsSection(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: StitchPalTheme.textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  Widget _buildGaugeSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required TextEditingController rowsController,
    required TextEditingController stitchesController,
    required TextEditingController heightController,
    required TextEditingController widthController,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StitchPalTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: StitchPalTheme.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: StitchPalTheme.textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          
          // Rows and Stitches
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  controller: rowsController,
                  labelText: 'Rows',
                  hintText: 'e.g., 20',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  controller: stitchesController,
                  labelText: 'Stitches',
                  hintText: 'e.g., 24',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Height and Width
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  controller: heightController,
                  labelText: 'Height (inches)',
                  hintText: 'e.g., 4',
                  optional: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  controller: widthController,
                  labelText: 'Width (inches)',
                  hintText: 'e.g., 4',
                  optional: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool optional = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixText: optional ? '(optional)' : null,
        suffixStyle: TextStyle(
          fontSize: 12,
          color: StitchPalTheme.textColor.withOpacity(0.5),
          fontStyle: FontStyle.italic,
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
      validator: optional 
          ? null 
          : (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
    );
  }
  
  Widget _buildResultsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StitchPalTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: StitchPalTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: StitchPalTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Gauge Adjustment Results',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_rowAdjustment != null)
            _buildResultItem(
              context,
              label: 'Row Adjustment:',
              value: _formatAdjustment(_rowAdjustment!),
              explanation: _getRowExplanation(_rowAdjustment!),
            ),
            
          if (_stitchAdjustment != null)
            _buildResultItem(
              context,
              label: 'Stitch Adjustment:',
              value: _formatAdjustment(_stitchAdjustment!),
              explanation: _getStitchExplanation(_stitchAdjustment!),
            ),
            
          const SizedBox(height: 16),
          
          Text(
            'What does this mean?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'If the adjustment factor is greater than 1.0, you need to increase your count. '
            'If it\'s less than 1.0, you need to decrease your count. '
            'Multiply your pattern\'s row and stitch counts by these factors to adjust your project.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildResultItem(
    BuildContext context, {
    required String label,
    required String value,
    required String explanation,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: StitchPalTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            explanation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: StitchPalTheme.textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatAdjustment(double adjustment) {
    return adjustment.toStringAsFixed(2) + 'x';
  }
  
  String _getRowExplanation(double adjustment) {
    if (adjustment > 1.05) {
      return 'Your rows are too tall. Try using a smaller hook or tighter tension.';
    } else if (adjustment < 0.95) {
      return 'Your rows are too short. Try using a larger hook or looser tension.';
    } else {
      return 'Your row gauge is good! No significant adjustment needed.';
    }
  }
  
  String _getStitchExplanation(double adjustment) {
    if (adjustment > 1.05) {
      return 'Your stitches are too wide. Try using a smaller hook or tighter tension.';
    } else if (adjustment < 0.95) {
      return 'Your stitches are too narrow. Try using a larger hook or looser tension.';
    } else {
      return 'Your stitch gauge is good! No significant adjustment needed.';
    }
  }
}
