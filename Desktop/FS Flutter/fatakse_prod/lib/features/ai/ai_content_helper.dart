import '../../core/services/ai_service.dart';

/// AI-powered content creation and enhancement helper.
class AIContentHelper {
  final AIService aiService;

  AIContentHelper(this.aiService);

  /// Generates or enhances a user bio or description.
  Future<String> generateBio({
    required String userType,
    required String details,
  }) async {
    final prompt =
        '''
Write a compelling $userType bio for the following details:
$details
Make it concise, professional, and engaging.
''';
    return await aiService.completePrompt(prompt: prompt);
  }

  /// Suggests hashtags or social media captions for a post.
  Future<List<String>> suggestHashtags({required String postContent}) async {
    final prompt =
        '''
Suggest 5 relevant hashtags for this post:
$postContent
Return as a comma-separated list.
''';
    final result = await aiService.completePrompt(prompt: prompt);
    return result
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
