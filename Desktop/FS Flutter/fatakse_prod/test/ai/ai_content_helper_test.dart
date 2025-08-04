import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:mockito/annotations.dart';

@GenerateMocks([AIService])
import 'package:fatakse_prod/features/ai/ai_content_helper.dart';
import 'package:fatakse_prod/core/services/ai_service.dart';
import 'ai_content_helper_test.mocks.dart';

void main() {
  group('AIContentHelper', () {
    late MockAIService mockAIService;
    late AIContentHelper helper;

    setUp(() {
      mockAIService = MockAIService();
      helper = AIContentHelper(mockAIService);
    });

    test('generateBio returns AI-generated bio', () async {
      when(mockAIService.completePrompt(prompt: anyNamed('prompt'))).thenAnswer(
        (invocation) async => 'Professional artist with 10+ years experience.',
      );

      final bio = await helper.generateBio(
        userType: 'artist',
        details: '10 years, Mumbai, singer',
      );
      expect(bio, contains('artist'));
    });

    test('suggestHashtags returns list of hashtags', () async {
      when(mockAIService.completePrompt(prompt: anyNamed('prompt'))).thenAnswer(
        (invocation) async => '#music, #artist, #performance, #live, #event',
      );

      final hashtags = await helper.suggestHashtags(
        postContent: 'Live music event in Mumbai',
      );
      expect(hashtags.length, 5);
      expect(hashtags[0], contains('#'));
    });
  });
}
