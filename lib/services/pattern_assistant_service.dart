import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stitchpal/models/chat_message.dart';
import 'package:stitchpal/models/pattern.dart';

class PatternAssistantService {
  static final PatternAssistantService _instance = PatternAssistantService._internal();
  factory PatternAssistantService() => _instance;
  PatternAssistantService._internal();

  final String _baseUrl = 'https://api.openai.com/v1';
  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  Future<ChatMessage> getPatternAssistance({
    required String userQuery,
    required CrochetPattern pattern,
    required List<ChatMessage> previousMessages,
  }) async {
    try {
      // Create system message with pattern context
      final systemMessage = {
        'role': 'system',
        'content': '''
You are a helpful crochet assistant. You provide guidance, tips, and clarification about crochet patterns.
The current pattern the user is working with is:

Title: ${pattern.title}
Description: ${pattern.description}
Skill Level: ${pattern.skillLevel}
Materials: ${pattern.materials.join(', ')}

Instructions:
${pattern.instructions.join('\n')}

Answer the user's questions about this pattern in a friendly, helpful manner. If they ask about something not related to this pattern or crochet, politely redirect them to crochet-related topics.
'''
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
