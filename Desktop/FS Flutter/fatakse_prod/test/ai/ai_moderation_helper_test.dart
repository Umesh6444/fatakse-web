import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:mockito/annotations.dart';

@GenerateMocks([AIService])
import 'package:fatakse_prod/features/ai/ai_moderation_helper.dart';
import 'package:fatakse_prod/core/services/ai_service.dart';
import 'ai_moderation_helper_test.mocks.dart';

void main() {
  group('AIModerationHelper', () {
    late MockAIService mockAIService;
    late AIModerationHelper helper;

    setUp(() {
      mockAIService = MockAIService();
      helper = AIModerationHelper(mockAIService);
    });

    test('moderateContent returns OK for safe content', () async {
      when(
        mockAIService.completePrompt(prompt: anyNamed('prompt')),
      ).thenAnswer((invocation) async => 'OK');

      final result = await helper.moderateContent('This is a safe message.');
      expect(result, 'OK');
    });

    test('analyzeSentiment returns sentiment', () async {
      when(
        mockAIService.completePrompt(prompt: anyNamed('prompt')),
      ).thenAnswer((invocation) async => 'positive');

      final sentiment = await helper.analyzeSentiment('Great job!');
      expect(sentiment, 'positive');
    });
  });
}
