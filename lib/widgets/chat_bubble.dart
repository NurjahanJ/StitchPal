import 'package:flutter/material.dart';
import 'package:stitchpal/models/chat_message.dart';
import 'package:stitchpal/theme.dart';
import 'package:intl/intl.dart' as intl;

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isFromUser = message.isFromUser;
    final timeFormat = intl.DateFormat('h:mm a');
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromUser) _buildAvatar(isFromUser),
          
          const SizedBox(width: 8),
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isFromUser 
                    ? StitchPalTheme.primaryColor
                    : StitchPalTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isFromUser ? Colors.white : StitchPalTheme.textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeFormat.format(message.timestamp),
                    style: TextStyle(
                      color: isFromUser 
                          ? Colors.white.withOpacity(0.7) 
                          : StitchPalTheme.textColor.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          if (isFromUser) _buildAvatar(isFromUser),
        ],
      ),
    );
  }
  
  Widget _buildAvatar(bool isUser) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser 
          ? StitchPalTheme.primaryColor.withOpacity(0.2)
          : StitchPalTheme.accentColor.withOpacity(0.2),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 18,
        color: isUser ? StitchPalTheme.primaryColor : StitchPalTheme.accentColor,
      ),
    );
  }
}
