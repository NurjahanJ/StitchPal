import 'dart:async';
import 'package:flutter/material.dart';

// This is a stub implementation of the notification service that doesn't use the problematic package
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  Timer? _breakTimer;
  bool _isTimerActive = false;
  
  // Cute break reminder messages
  final List<String> _cuteMessages = [
    "Time for a yarn break! Your crochet project will be waiting for you 🧶",
    "Your fingers deserve a little stretch! Take 5 minutes to relax 💕",
    "Crochet pause! Give your hands a break and your project will thank you 🌸",
    "Stitch time-out! Rest your hands and come back refreshed ✨",
    "Hook it up later! Time for a quick break to keep your creativity flowing 🧠",
    "Even the best crocheters need breaks! Time to rest those crafty fingers 🧤",
    "Your yarn is taking a nap, maybe you should too! Just 5 minutes 😴",
    "Crochet break alert! Your WIP (Work In Progress) will be patient 🧵",
  ];
  
  String get _randomCuteMessage {
    _cuteMessages.shuffle();
    return _cuteMessages.first;
  }

  Future<void> initialize() async {
    // Stub implementation
    debugPrint('Notifications disabled for compatibility');
  }
  
  Future<void> _requestPermissions() async {
    // Stub implementation
    debugPrint('Permissions request disabled');
  }

  // Start the break timer
  void startBreakTimer() {
    if (_isTimerActive) {
      return; // Already running
    }
    
    _isTimerActive = true;
    
    // Schedule a notification every 30 minutes
    _breakTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      // Instead of showing a notification, just print to console
      debugPrint('Break time: ${_randomCuteMessage}');
    });
    
    debugPrint('Break timer started (notifications disabled)');
  }
  
  // Stop the break timer
  void stopBreakTimer() {
    _breakTimer?.cancel();
    _breakTimer = null;
    _isTimerActive = false;
    debugPrint('Break timer stopped');
  }
  
  // Check if timer is active
  bool get isTimerActive => _isTimerActive;
  
  // Show a break notification
  Future<void> _showBreakNotification() async {
    // Stub implementation
    debugPrint('Break notification (disabled): ${_randomCuteMessage}');
  }
  
  // Show a test notification immediately
  Future<void> showTestNotification() async {
    // Stub implementation
    debugPrint('Test notification (disabled): This is a test notification from StitchPal! 🧶');
  }
}
