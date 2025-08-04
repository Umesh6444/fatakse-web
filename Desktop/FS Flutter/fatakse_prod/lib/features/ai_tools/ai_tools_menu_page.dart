import 'package:flutter/material.dart';
import '../../core/services/openai_service.dart';
import '../../config/theme/app_theme.dart';
import 'event_concept_generator/event_concept_generator_page.dart';
import 'role_aware_assistant/role_aware_assistant_page.dart';
import 'collaboration_rooms/collaboration_room_page.dart';
import 'contract_automation/contract_automation_page.dart';
import 'event_blueprint/event_blueprint_page.dart';
import 'matchmaking/matchmaking_page.dart';
import 'sentiment_trends/sentiment_trends_page.dart';
import 'portfolio_builder/portfolio_builder_page.dart';
import 'voice_to_booking/voice_to_booking_page.dart';
import 'accessibility/accessibility_tools_page.dart';
import 'learning_hub/learning_hub_page.dart';
// Add more imports as you implement more features

class AIToolsMenuPage extends StatelessWidget {
  final OpenAIService openAIService;
  final String userRole;
  const AIToolsMenuPage({
    super.key,
    required this.openAIService,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // Sensible mapping of tools per role
    final Map<String, List<String>> roleToTools = {
      'artist': [
        'Portfolio Builder',
        'Event Concept Generator',
        'Role-Aware AI Assistant',
        'Learning & Upskilling Hub',
        'Sentiment & Trend Analysis',
        'Accessibility Tools',
      ],
      'household_client': [
        'Matchmaking',
        'Event Concept Generator',
        'Role-Aware AI Assistant',
        'Voice-to-Booking',
        'Accessibility Tools',
      ],
      'corporate_client': [
        'Matchmaking',
        'Event Concept Generator',
        'Role-Aware AI Assistant',
        'Voice-to-Booking',
        'Accessibility Tools',
      ],
      'vendor': [
        'Contract & Payment Automation',
        'Role-Aware AI Assistant',
        'Sentiment & Trend Analysis',
        'Accessibility Tools',
      ],
      'event_planner': [
        'Collaboration Room',
        'Event Blueprint Generator',
        'Role-Aware AI Assistant',
        'Contract & Payment Automation',
        'Learning & Upskilling Hub',
        'Accessibility Tools',
      ],
      'production_house': [
        'Collaboration Room',
        'Contract & Payment Automation',
        'Event Blueprint Generator',
        'Role-Aware AI Assistant',
        'Sentiment & Trend Analysis',
        'Accessibility Tools',
      ],
    };

    final allTools = [
      _AIToolMenuItem(
        title: 'Event Concept Generator',
        page: EventConceptGeneratorPage(openAIService: openAIService),
      ),
      _AIToolMenuItem(
        title: 'Role-Aware AI Assistant',
        page: RoleAwareAssistantPage(
          userRole: userRole,
          openAIService: openAIService,
        ),
      ),
      _AIToolMenuItem(
        title: 'Collaboration Room',
        page: const CollaborationRoomPage(),
      ),
      _AIToolMenuItem(
        title: 'Contract & Payment Automation',
        page: const ContractAutomationPage(),
      ),
      _AIToolMenuItem(
        title: 'Event Blueprint Generator',
        page: const EventBlueprintPage(),
      ),
      _AIToolMenuItem(title: 'Matchmaking', page: const MatchmakingPage()),
      _AIToolMenuItem(
        title: 'Sentiment & Trend Analysis',
        page: SentimentTrendsPage(openAIService: openAIService),
      ),
      _AIToolMenuItem(
        title: 'Portfolio Builder',
        page: PortfolioBuilderPage(openAIService: openAIService),
      ),
      _AIToolMenuItem(
        title: 'Voice-to-Booking',
        page: VoiceToBookingPage(openAIService: openAIService),
      ),
      _AIToolMenuItem(
        title: 'Accessibility Tools',
        page: AccessibilityToolsPage(openAIService: openAIService),
      ),
      _AIToolMenuItem(
        title: 'Learning & Upskilling Hub',
        page: LearningHubPage(openAIService: openAIService),
      ),
    ];

    // Normalize userRole for mapping
    final normalizedRole = userRole.toLowerCase().replaceAll(' ', '_');
    final allowedTitles = roleToTools[normalizedRole] ?? [];
    final tools = allTools
        .where((tool) => allowedTitles.contains(tool.title))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Tools',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: tools.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) => ListTile(
          title: Text(
            tools[i].title,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => tools[i].page),
          ),
        ),
      ),
    );
  }
}

class _AIToolMenuItem {
  final String title;
  final Widget page;
  _AIToolMenuItem({required this.title, required this.page});
}
