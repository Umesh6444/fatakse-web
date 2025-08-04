import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:mockito/annotations.dart';

@GenerateMocks([AIService])
import 'package:fatakse_prod/features/ai/ai_support_bot_helper.dart';
import 'package:fatakse_prod/core/services/ai_service.dart';
import 'ai_support_bot_helper_test.mocks.dart';

void main() {
  group('AISupportBotHelper', () {
    late MockAIService mockAIService;
    late AISupportBotHelper helper;

    setUp(() {
      mockAIService = MockAIService();
      helper = AISupportBotHelper(mockAIService);
    });

    test('answerQuestion returns AI answer', () async {
      when(mockAIService.completePrompt(prompt: anyNamed('prompt'))).thenAnswer(
        (invocation) async =>
            'You can reset your password from the settings page.',
      );

      final answer = await helper.answerQuestion('How do I reset my password?');
      expect(answer, contains('reset your password'));
    });

    test('guideUser returns AI guidance', () async {
      when(mockAIService.completePrompt(prompt: anyNamed('prompt'))).thenAnswer(
        (invocation) async =>
            'To book an artist, go to the bookings tab and follow the steps.',
      );

      final guidance = await helper.guideUser(
        flowName: 'Booking',
        context: 'User wants to book an artist',
      );
      expect(guidance, contains('book an artist'));
    });
  });
}
