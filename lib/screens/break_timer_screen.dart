import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stitchpal/services/notification_service.dart';
import 'package:stitchpal/theme.dart';

class BreakTimerScreen extends StatefulWidget {
  const BreakTimerScreen({super.key});

  @override
  State<BreakTimerScreen> createState() => _BreakTimerScreenState();
}

class _BreakTimerScreenState extends State<BreakTimerScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isTimerActive = false;
  bool _remindersEnabled = true;
  
  // Timer variables
  Timer? _uiTimer;
  int _secondsElapsed = 0;
  int _minutesUntilBreak = 30;
  
  @override
  void initState() {
    super.initState();
    _isTimerActive = _notificationService.isTimerActive;
    
    // Initialize the UI timer if the notification timer is already active
    if (_isTimerActive) {
      _startUiTimer();
    }
  }
  
  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }
  
  void _toggleTimer() {
    setState(() {
      _isTimerActive = !_isTimerActive;
      
      if (_isTimerActive) {
        // Start the notification timer if reminders are enabled
        if (_remindersEnabled) {
          _notificationService.startBreakTimer();
        }
        
        // Reset and start the UI timer
        _secondsElapsed = 0;
        _minutesUntilBreak = 30;
        _startUiTimer();
      } else {
        // Stop the notification timer
        _notificationService.stopBreakTimer();
        
        // Stop the UI timer
        _uiTimer?.cancel();
        _uiTimer = null;
      }
    });
  }
  
  void _startUiTimer() {
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        
        // Calculate minutes and seconds until next break
        int totalSecondsUntilBreak = (30 * 60) - (_secondsElapsed % (30 * 60));
        _minutesUntilBreak = totalSecondsUntilBreak ~/ 60;
        
        // If we've reached a 30-minute mark, show a UI reminder
        if (_secondsElapsed % (30 * 60) == 0 && _secondsElapsed > 0) {
          _showBreakDialog();
        }
      });
    });
  }
  
  void _toggleReminders() {
    setState(() {
      _remindersEnabled = !_remindersEnabled;
      
      // If the timer is active and reminders were just enabled, start the notification timer
      if (_isTimerActive && _remindersEnabled) {
        _notificationService.startBreakTimer();
      }
      
      // If the timer is active and reminders were just disabled, stop the notification timer
      if (_isTimerActive && !_remindersEnabled) {
        _notificationService.stopBreakTimer();
      }
    });
  }
  
  void _showBreakDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: StitchPalTheme.primaryColor,
              ),
              const SizedBox(width: 10),
              const Text('Break Time!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Time to take a short break and stretch!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/yarn_break.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.self_improvement,
                    size: 80,
                    color: StitchPalTheme.primaryColor.withOpacity(0.7),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Your crochet project will be waiting for you! 🧶',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: StitchPalTheme.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Skip Break'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Take Break'),
            ),
          ],
        );
      },
    );
  }
  
  String _formatTimeRemaining() {
    int minutes = _minutesUntilBreak;
    int seconds = 59 - (_secondsElapsed % 60);
    
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchPalTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Crochet Break Timer'),
        backgroundColor: StitchPalTheme.surfaceColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero header with illustration
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: StitchPalTheme.surfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: StitchPalTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: StitchPalTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            size: 28,
                            color: StitchPalTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Take care of your hands',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: StitchPalTheme.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Regular breaks help prevent repetitive strain injuries while crocheting. We\'ll remind you to take a 5-minute break every 30 minutes.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: StitchPalTheme.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Timer display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: StitchPalTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: StitchPalTheme.primaryColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isTimerActive ? 'Next break in:' : 'Timer not active',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: StitchPalTheme.textColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isTimerActive ? _formatTimeRemaining() : '--:--',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: StitchPalTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _toggleTimer,
                            icon: Icon(
                              _isTimerActive ? Icons.pause : Icons.play_arrow,
                              size: 24,
                            ),
                            label: Text(
                              _isTimerActive ? 'Pause Timer' : 'Start Timer',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Notification settings
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: StitchPalTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: StitchPalTheme.primaryColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Enable Notifications'),
                            subtitle: const Text('Receive push notifications when it\'s time to take a break'),
                            value: _remindersEnabled,
                            onChanged: (value) {
                              _toggleReminders();
                            },
                            activeColor: StitchPalTheme.primaryColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Test Notification'),
                            subtitle: const Text('Send a test notification to check if they\'re working'),
                            trailing: IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () {
                                _notificationService.showTestNotification();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Test notification sent!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Tips section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: StitchPalTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: StitchPalTheme.accentColor.withOpacity(0.3),
                          width: 1,
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
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Crocheter\'s Tip',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: StitchPalTheme.textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'During your breaks, try these hand exercises:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTipItem('Gently stretch your fingers and wrists'),
                          _buildTipItem('Rotate your wrists in both directions'),
                          _buildTipItem('Make fists, then spread your fingers wide'),
                          _buildTipItem('Massage the palm of your hand with your thumb'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: StitchPalTheme.accentColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
