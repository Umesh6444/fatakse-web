import '../../core/services/ai_service.dart';

/// AI-powered support bot for onboarding, troubleshooting, and FAQs.
class AISupportBotHelper {
  final AIService aiService;

  AISupportBotHelper(this.aiService);

  /// Answers user questions about the app or platform.
  Future<String> answerQuestion(String question) async {
    final prompt =
        '''
You are a helpful support bot for the StageLink app. Answer the following user question clearly and concisely:
$question
''';
    return await aiService.completePrompt(prompt: prompt);
  }

  /// Guides users through a specific app flow.
  Future<String> guideUser({
    required String flowName,
    required String context,
  }) async {
    final prompt =
        '''
Guide the user through the "$flowName" flow in the StageLink app. Context: $context
''';
    return await aiService.completePrompt(prompt: prompt);
  }
}
