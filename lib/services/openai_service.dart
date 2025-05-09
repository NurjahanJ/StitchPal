import 'dart:convert';
import 'package:flutter/material.dart' hide Material;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stitchpal/models/pattern.dart';

/// A model class for yarn suggestions
class YarnSuggestion {
  final String brandName;
  final String yarnName;
  final List<String> colors;
  final String storeUrl;

  YarnSuggestion({
    required this.brandName,
    required this.yarnName,
    required this.colors,
    required this.storeUrl,
  });

  factory YarnSuggestion.fromJson(Map<String, dynamic> json) {
    return YarnSuggestion(
      brandName: json['brandName'] ?? '',
      yarnName: json['yarnName'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      storeUrl: json['storeUrl'] ?? '',
    );
  }
}

/// Service class for interacting with OpenAI APIs
class OpenAIService {
  // Get API key from environment variables
  static String get _apiKey {
    final key = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (key.isEmpty) {
      debugPrint('WARNING: OpenAI API key not found in .env file');
      debugPrint('Make sure you have created a .env file with your OPENAI_API_KEY');
    }
    return key;
  }
  static const String _baseUrl = 'https://api.openai.com/v1';



  // Generate yarn suggestions using GPT-4
  static Future<List<YarnSuggestion>> getYarnSuggestions(String patternType, String yarnWeight) async {
    // Check if API key is available
    if (_apiKey.isEmpty) {
      debugPrint('OpenAI API key not found. Please add it to your .env file.');
      return _getDefaultSuggestions();
    }
    
    try {
      final prompt = 'Suggest 3 yarns available online for $yarnWeight weight yarn suitable for a $patternType. '
          'For each yarn, provide the brand name, yarn name, color options, and where to buy it. '
          'Format as JSON with fields: brandName, yarnName, colors (array), and storeUrl.';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful crochet expert who provides yarn suggestions in JSON format.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Extract JSON from the response
        final jsonStart = content.indexOf('[');
        final jsonEnd = content.lastIndexOf(']') + 1;
        
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          final jsonStr = content.substring(jsonStart, jsonEnd);
          final List<dynamic> suggestions = jsonDecode(jsonStr);
          
          return suggestions.map((json) => YarnSuggestion.fromJson(json)).toList();
        }
        
        // Fallback to default suggestions if JSON parsing fails
        return _getDefaultSuggestions();
      } else {
        debugPrint('Error getting yarn suggestions: ${response.body}');
        return _getDefaultSuggestions();
      }
    } catch (e) {
      debugPrint('Exception getting yarn suggestions: $e');
      return _getDefaultSuggestions();
    }
  }

  // Generate a custom crochet pattern based on user input
  static Future<CrochetPattern> generatePattern(String description, List<String> tags) async {
    // Check if API key is available
    if (_apiKey.isEmpty) {
      debugPrint('OpenAI API key not found. Please add it to your .env file.');
      return CrochetPattern.getSamplePattern(title: 'Sample Pattern');
    }
    
    try {
      // Create a prompt that includes the description and tags
      final String tagsText = tags.isNotEmpty ? ' with tags: ${tags.join(', ')}' : '';
      final prompt = 'Create a detailed crochet pattern for: $description$tagsText. ' +
          'Include a title, skill level, materials list, step-by-step instructions divided into sections, ' +
          'and stitch abbreviations. Format as JSON with these fields: ' +
          'title, skillLevel, materials (array of objects with name and details), ' +
          'instructions (array of objects with sectionTitle and steps array), ' +
          'and stitchAbbreviations (object with abbreviation keys and description values).';

      debugPrint('Sending pattern generation request to OpenAI...');
      debugPrint('Using description: $description with tags: $tags');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful crochet expert who creates detailed patterns in JSON format.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'temperature': 0.7,
        }),
      );

      debugPrint('OpenAI pattern response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        debugPrint('Received pattern content from OpenAI');
        
        // Extract JSON from the response
        final jsonStart = content.indexOf('{');
        final jsonEnd = content.lastIndexOf('}') + 1;
        
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          final jsonStr = content.substring(jsonStart, jsonEnd);
          debugPrint('Extracted JSON from response');
          
          try {
            final Map<String, dynamic> patternData = jsonDecode(jsonStr);
            debugPrint('Successfully parsed JSON data');
            
            // Parse materials
            final List<Material> materials = [];
            if (patternData['materials'] != null) {
              for (var material in patternData['materials']) {
                materials.add(Material(
                  name: material['name'] ?? '',
                  details: material['details'] ?? '',
                ));
              }
              debugPrint('Parsed ${materials.length} materials');
            }
            
            // Parse instructions
            final List<Instruction> instructions = [];
            if (patternData['instructions'] != null) {
              for (var instruction in patternData['instructions']) {
                instructions.add(Instruction(
                  sectionTitle: instruction['sectionTitle'] ?? '',
                  steps: List<String>.from(instruction['steps'] ?? []),
                ));
              }
              debugPrint('Parsed ${instructions.length} instruction sections');
            }
            
            // Parse stitch abbreviations
            final Map<String, String> stitchAbbreviations = {};
            if (patternData['stitchAbbreviations'] != null) {
              patternData['stitchAbbreviations'].forEach((key, value) {
                stitchAbbreviations[key] = value.toString();
              });
              debugPrint('Parsed ${stitchAbbreviations.length} stitch abbreviations');
            }
            
            // Create and return the pattern
            final pattern = CrochetPattern(
              title: patternData['title'] ?? 'Custom Crochet Pattern',
              description: description,
              skillLevel: patternData['skillLevel'] ?? 'Beginner',
              materials: materials,
              instructions: instructions,
              stitchAbbreviations: stitchAbbreviations,
            );
            
            debugPrint('Successfully created pattern: ${pattern.title}');
            return pattern;
          } catch (jsonError) {
            debugPrint('Error parsing JSON: $jsonError');
            debugPrint('JSON string: $jsonStr');
          }
        } else {
          debugPrint('Could not find valid JSON in the response');
          debugPrint('Response content: $content');
        }
      } else {
        debugPrint('Error generating pattern: ${response.body}');
        // Check for common error types
        if (response.statusCode == 401) {
          debugPrint('Authentication error: Invalid API key or unauthorized access');
        } else if (response.statusCode == 429) {
          debugPrint('Rate limit exceeded: Too many requests or quota exceeded');
        }
      }
      
      // If anything fails, return a fallback pattern with the user's description
      debugPrint('Falling back to sample pattern with title: $description');
      return CrochetPattern.getSamplePattern(title: description);
      
    } catch (e, stackTrace) {
      debugPrint('Exception generating pattern: $e');
      debugPrint('Stack trace: $stackTrace');
      return CrochetPattern.getSamplePattern(title: description);
    }
  }
  
  // Provide default yarn suggestions when API is unavailable
  static List<YarnSuggestion> _getDefaultSuggestions() {
    return [
      YarnSuggestion(
        brandName: 'Lion Brand',
        yarnName: 'Wool-Ease',
        colors: ['Blue Mist', 'Fisherman', 'Rose Heather'],
        storeUrl: 'https://www.lionbrand.com/products/wool-ease-yarn',
      ),
      YarnSuggestion(
        brandName: 'Bernat',
        yarnName: 'Softee Baby',
        colors: ['Pale Yellow', 'Mint', 'Lavender'],
        storeUrl: 'https://www.yarnspirations.com/bernat-softee-baby-yarn/164058.html',
      ),
      YarnSuggestion(
        brandName: 'Caron',
        yarnName: 'Simply Soft',
        colors: ['Ocean Blue', 'Autumn Red', 'Sage'],
        storeUrl: 'https://www.yarnspirations.com/caron-simply-soft-yarn/H97003.html',
      ),
    ];
  }
}
