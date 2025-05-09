import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/services/notification_service.dart';
import 'package:stitchpal/widgets/hand_stretch_guide.dart';

class CrochetTimer extends StatefulWidget {
  const CrochetTimer({super.key});

  @override
  State<CrochetTimer> createState() => _CrochetTimerState();
}

class _CrochetTimerState extends State<CrochetTimer> {
  int _seconds = 0;
  bool _isRunning = false;
  bool _notificationsEnabled = false;
  Timer? _timer;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_notificationsEnabled) {
      _notificationService.stopBreakTimer();
    }
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });

      // Start break notifications if enabled
      if (_notificationsEnabled) {
        _notificationService.startBreakTimer();
      }
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
      
      // Stop break notifications if enabled
      if (_notificationsEnabled) {
        _notificationService.stopBreakTimer();
      }
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
    
    // Stop break notifications if enabled
    if (_notificationsEnabled) {
      _notificationService.stopBreakTimer();
    }
  }

  void _toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
    
    if (_notificationsEnabled && _isRunning) {
      _notificationService.startBreakTimer();
    } else {
      _notificationService.stopBreakTimer();
    }
  }
  
  void _showHandStretchGuide() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HandStretchGuide()),
    );
  }

  String _formatTime() {
    final hours = (_seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Project Timer',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Track the time you spend on your crochet projects',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: StitchPalTheme.textColor.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Notification toggle
          SwitchListTile(
            title: const Text('Break Reminders'),
            subtitle: const Text('Get notified every 30 minutes to take a break'),
            value: _notificationsEnabled,
            onChanged: (value) => _toggleNotifications(),
            activeColor: StitchPalTheme.primaryColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          ),
          
          const SizedBox(height: 16),
          
          // Timer display
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
            child: Text(
              _formatTime(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: StitchPalTheme.primaryColor,
                fontFamily: 'monospace',
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!_isRunning) ...[
                // Start button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: StitchPalTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ] else ...[
                // Stop button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _stopTimer,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: StitchPalTheme.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(width: 12),
              
              // Reset button
              OutlinedButton.icon(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Hand stretch guide button
          OutlinedButton.icon(
            onPressed: _showHandStretchGuide,
            icon: const Icon(Icons.fitness_center),
            label: const Text('Hand Stretch Guide'),
            style: OutlinedButton.styleFrom(
              foregroundColor: StitchPalTheme.accentColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
          
          const SizedBox(height: 16),
          
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
                      'Timer Tips',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\u2022 Use the timer to track how long your projects take\n'
                  '\u2022 Take regular breaks to prevent hand fatigue\n'
                  '\u2022 Enable notifications to get break reminders\n'
                  '\u2022 Check the hand stretch guide for helpful exercises',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
