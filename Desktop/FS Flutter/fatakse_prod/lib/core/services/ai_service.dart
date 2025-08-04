import 'dart:convert';
import 'package:http/http.dart' as http;

/// Centralized service for OpenAI API calls.
class AIService {
  final String apiKey;
  final String baseUrl;

  AIService({required this.apiKey, this.baseUrl = 'https://api.openai.com/v1'});

  /// Generic method to call OpenAI's completion endpoint.
  Future<String> completePrompt({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    int maxTokens = 256,
    double temperature = 0.7,
  }) async {
    final url = Uri.parse('$baseUrl/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': maxTokens,
        'temperature': temperature,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('OpenAI API error: ${response.body}');
    }
  }
}
