import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stitchpal/models/chat_message.dart';
import 'package:stitchpal/models/pattern.dart';

class GlobalAssistantService {
  static final GlobalAssistantService _instance = GlobalAssistantService._internal();
  factory GlobalAssistantService() => _instance;
  GlobalAssistantService._internal();

  final String _baseUrl = 'https://api.openai.com/v1';
  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  
  // Current pattern context - can be null if not viewing a pattern
  CrochetPattern? _currentPattern;
  
  // Set the current pattern context
  void setPatternContext(CrochetPattern? pattern) {
    _currentPattern = pattern;
  }

  Future<ChatMessage> getAssistance({
    required String userQuery,
    required List<ChatMessage> previousMessages,
  }) async {
    try {
      // Create system message with or without pattern context
      String systemContent = '''
You are StitchPal, a helpful crochet assistant. You provide guidance, tips, and clarification about crochet techniques, patterns, and best practices.
''';
      
      // Add pattern context if available
      if (_currentPattern != null) {
        systemContent += '''
The user is currently viewing this pattern:

Title: ${_currentPattern!.title}
Description: ${_currentPattern!.description}
Skill Level: ${_currentPattern!.skillLevel}
Materials: ${_currentPattern!.materials.join(', ')}

Instructions:
${_currentPattern!.instructions.join('\n')}

If the user asks about this pattern, provide specific guidance based on these details.
''';
      }
      
      final systemMessage = {
        'role': 'system',
        'content': systemContent
      };

      // Convert previous messages to the format expected by the API
      final messages = [
        systemMessage,
        ...previousMessages.map((msg) => {
              'role': msg.isFromUser ? 'user' : 'assistant',
              'content': msg.text,
            }),
        {
          'role': 'user',
          'content': userQuery,
        }
      ];

      // Make the API request
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assistantResponse = data['choices'][0]['message']['content'];
        return ChatMessage(
          text: assistantResponse,
          sender: MessageSender.assistant,
        );
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        return ChatMessage(
          text: 'Sorry, I had trouble understanding that. Could you try asking in a different way?',
          sender: MessageSender.assistant,
        );
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return ChatMessage(
        text: 'Sorry, there was an error processing your request. Please try again later.',
        sender: MessageSender.assistant,
      );
    }
  }
}
