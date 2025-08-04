import '../../core/services/ai_service.dart';

/// AI-powered moderation helper for content, chat, and reviews.
class AIModerationHelper {
  final AIService aiService;

  AIModerationHelper(this.aiService);

  /// Checks if content is appropriate and flags issues.
  Future<String> moderateContent(String content) async {
    final prompt =
        '''
Review the following content for inappropriate language, spam, or policy violations. If any issues, list them. If safe, reply 'OK'.
$content
''';
    return await aiService.completePrompt(prompt: prompt);
  }

  /// Analyzes sentiment of a review or message.
  Future<String> analyzeSentiment(String text) async {
    final prompt =
        '''
Analyze the sentiment of this text (positive, neutral, negative):
$text
''';
    return await aiService.completePrompt(prompt: prompt);
  }
}
