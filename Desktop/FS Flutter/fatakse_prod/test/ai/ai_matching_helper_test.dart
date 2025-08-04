import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fatakse_prod/features/ai/ai_matching_helper.dart';
import 'package:fatakse_prod/core/services/ai_service.dart';
import 'ai_matching_helper_test.mocks.dart';

@GenerateMocks([AIService])
void main() {
  group('AIMatchingHelper', () {
    late MockAIService mockAIService;
    late AIMatchingHelper helper;

    setUp(() {
      mockAIService = MockAIService();
      helper = AIMatchingHelper(mockAIService);
    });

    test('suggestMatches returns AI suggestions', () async {
      when(mockAIService.completePrompt(prompt: anyNamed('prompt'))).thenAnswer(
        (_) async =>
            '1. Artist A - Best fit for weddings.\n2. Artist B - Experienced in corporate events.\n3. Artist C - Local and affordable.',
      );

      final result = await helper.suggestMatches(
        eventDetails: 'Wedding, Mumbai, 200 guests',
        userRole: 'client',
        candidates: ['Artist A', 'Artist B', 'Artist C'],
      );

      expect(result.length, 3);
      expect(result[0], contains('Artist A'));
    });
  });
}
