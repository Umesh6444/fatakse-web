import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:mockito/annotations.dart';

@GenerateMocks([AIService])
import 'package:fatakse_prod/features/ai/ai_chat_helper.dart';
import 'package:fatakse_prod/core/services/ai_service.dart';
import 'ai_chat_helper_test.mocks.dart';

void main() {
  group('AIChatHelper', () {
    late MockAIService mockAIService;
    late AIChatHelper helper;

    setUp(() {
      mockAIService = MockAIService();
      helper = AIChatHelper(mockAIService);
    });

    test('suggestReply returns AI reply', () async {
      when(
        mockAIService.completePrompt(prompt: anyNamed('prompt')),
      ).thenAnswer((invocation) async => 'Thank you for your message!');

      final reply = await helper.suggestReply(
        conversation: 'Hi\nHow are you?',
        lastMessage: 'How are you?',
      );
      expect(reply, contains('Thank'));
    });

    test('summarizeChat returns summary', () async {
      when(mockAIService.completePrompt(prompt: anyNamed('prompt'))).thenAnswer(
        (invocation) async => 'The chat was about booking an artist.',
      );

      final summary = await helper.summarizeChat(
        'User: Hi\nArtist: Hello!\nUser: I want to book you.',
      );
      expect(summary, contains('booking'));
    });

    test('translateMessage returns translation', () async {
      when(
        mockAIService.completePrompt(prompt: anyNamed('prompt')),
      ).thenAnswer((invocation) async => 'Hola!');

      final translation = await helper.translateMessage(
        message: 'Hello!',
        targetLanguage: 'Spanish',
      );
      expect(translation, contains('Hola'));
    });
  });
}
