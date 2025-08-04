import '../../core/services/ai_service.dart';

/// AI-powered chat assistant for smart replies, summarization, and translation.
class AIChatHelper {
  final AIService aiService;

  AIChatHelper(this.aiService);

  /// Suggests a smart reply for a given message context.
  Future<String> suggestReply({
    required String conversation,
    required String lastMessage,
  }) async {
    final prompt =
        '''
Given the conversation so far:
$conversation
User's last message: $lastMessage
Suggest a polite, relevant reply.
''';
    return await aiService.completePrompt(prompt: prompt);
  }

  /// Summarizes a chat conversation.
  Future<String> summarizeChat(String conversation) async {
    final prompt =
        '''
Summarize the following chat in 2-3 sentences:
$conversation
''';
    return await aiService.completePrompt(prompt: prompt);
  }

  /// Translates a message to the target language.
  Future<String> translateMessage({
    required String message,
    required String targetLanguage,
  }) async {
    final prompt =
        '''
Translate this message to $targetLanguage:
$message
''';
    return await aiService.completePrompt(prompt: prompt);
  }
}
