import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class StitchCounter extends StatefulWidget {
  final int initialCount;
  final Function(int)? onCountChanged;

  const StitchCounter({
    super.key,
    this.initialCount = 0,
    this.onCountChanged,
  });

  @override
  State<StitchCounter> createState() => _StitchCounterState();
}

class _StitchCounterState extends State<StitchCounter> {
  late int _count;
  List<String> _counters = ['Main Counter'];
  int _selectedCounterIndex = 0;
  List<int> _counterValues = [0];

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
    _counterValues[0] = _count;
  }

  void _increment() {
    setState(() {
      _count++;
      _counterValues[_selectedCounterIndex] = _count;
    });
    widget.onCountChanged?.call(_count);
  }

  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
        _counterValues[_selectedCounterIndex] = _count;
      });
      widget.onCountChanged?.call(_count);
    }
  }

  void _reset() {
    setState(() {
      _count = 0;
      _counterValues[_selectedCounterIndex] = 0;
    });
    widget.onCountChanged?.call(_count);
  }
  
  void _addCounter() {
    setState(() {
      _counters.add('Counter ${_counters.length + 1}');
      _counterValues.add(0);
    });
  }
  
  void _selectCounter(int index) {
    setState(() {
      _selectedCounterIndex = index;
      _count = _counterValues[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stitch Counter',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: StitchPalTheme.primaryColor,
                ),
                onPressed: _addCounter,
                tooltip: 'Add Counter',
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Keep track of your stitches, rows, or repeats with multiple counters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: StitchPalTheme.textColor.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Counter tabs
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _counters.length,
              itemBuilder: (context, index) {
                bool isSelected = index == _selectedCounterIndex;
                return GestureDetector(
                  onTap: () => _selectCounter(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? StitchPalTheme.primaryColor 
                          : StitchPalTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected 
                            ? StitchPalTheme.primaryColor 
                            : StitchPalTheme.dividerColor,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _counters[index],
                      style: TextStyle(
                        color: isSelected 
                            ? Colors.white 
                            : StitchPalTheme.textColor,
                        fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Counter display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              color: StitchPalTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: StitchPalTheme.primaryColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _count.toString(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: StitchPalTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _counters[_selectedCounterIndex],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: StitchPalTheme.textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Decrement button
              _buildControlButton(
                icon: Icons.remove,
                onPressed: _decrement,
                backgroundColor: StitchPalTheme.accentColor.withOpacity(0.2),
                size: 72,
              ),
              
              // Reset button
              _buildControlButton(
                icon: Icons.refresh,
                onPressed: _reset,
                backgroundColor: StitchPalTheme.secondaryColor.withOpacity(0.2),
                size: 56,
              ),
              
              // Increment button
              _buildControlButton(
                icon: Icons.add,
                onPressed: _increment,
                backgroundColor: StitchPalTheme.primaryColor.withOpacity(0.2),
                size: 72,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Tips
          Container(
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
                      Icons.lightbulb_outline,
                      color: StitchPalTheme.accentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Counter Tips',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Use multiple counters to track different parts of your project\n'
                  '• Count rows with one counter and pattern repeats with another\n'
                  '• Tap the counter tabs above to switch between counters',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required double size,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Icon(
            icon,
            color: StitchPalTheme.textColor,
            size: size / 2.5,
          ),
        ),
      ),
    );
  }
}
