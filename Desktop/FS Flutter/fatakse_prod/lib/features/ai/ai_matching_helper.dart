import '../../core/services/ai_service.dart';

/// AI-powered talent and vendor matching helper.
class AIMatchingHelper {
  final AIService aiService;

  AIMatchingHelper(this.aiService);

  /// Suggests best matches for a client based on event details and preferences.
  Future<List<String>> suggestMatches({
    required String eventDetails,
    required String userRole,
    required List<String> candidates,
  }) async {
    final prompt =
        '''
Given the following event details: $eventDetails
User role: $userRole
Candidates: ${candidates.join(", ")}
Suggest the top 3 most relevant candidates for this user and event, with a short reason for each.
Return as a numbered list.
''';
    final result = await aiService.completePrompt(prompt: prompt);
    return result.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }
}
