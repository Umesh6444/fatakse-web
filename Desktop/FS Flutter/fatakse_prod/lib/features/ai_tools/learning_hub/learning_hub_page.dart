import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class LearningHubPage extends StatefulWidget {
  final OpenAIService openAIService;
  const LearningHubPage({super.key, required this.openAIService});

  @override
  State<LearningHubPage> createState() => _LearningHubPageState();
}

class _LearningHubPageState extends State<LearningHubPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _getLearningTips() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI learning and upskilling coach. Given the following user profile or goals, offer micro-courses, tips, or feedback to improve their skills, negotiation, or event management abilities.\nProfile/goals: ${_controller.text}''';
    try {
      final result = await widget.openAIService.getChatCompletion(
        prompt: prompt,
      );
      setState(() => _response = result);
    } catch (e) {
      setState(() => _response = 'Error: $e');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning & Upskilling Hub')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your profile or learning goals...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _getLearningTips,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Get Learning Tips'),
            ),
            const SizedBox(height: 24),
            if (_response != null)
              Expanded(child: SingleChildScrollView(child: Text(_response!))),
          ],
        ),
      ),
    );
  }
}
