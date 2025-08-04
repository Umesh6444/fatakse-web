import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;
  final String apiUrl;

  OpenAIService({
    required this.apiKey,
    this.apiUrl = 'https://api.openai.com/v1/chat/completions',
  });

  Future<String> getChatCompletion({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    List<Map<String, String>>? messages,
    int maxTokens = 512,
    double temperature = 0.7,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      'model': model,
      'messages':
          messages ??
          [
            {'role': 'user', 'content': prompt},
          ],
      'max_tokens': maxTokens,
      'temperature': temperature,
    });
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('OpenAI API error: ${response.body}');
    }
  }
}
