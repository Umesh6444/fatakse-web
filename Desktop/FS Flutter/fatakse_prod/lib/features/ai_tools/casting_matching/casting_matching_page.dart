import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class CastingMatchingPage extends StatefulWidget {
  final OpenAIService openAIService;
  const CastingMatchingPage({super.key, required this.openAIService});

  @override
  State<CastingMatchingPage> createState() => _CastingMatchingPageState();
}

class _CastingMatchingPageState extends State<CastingMatchingPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _matchCasting() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI casting director. Given the following project details, match the best-fit talent and crew based on skills, availability, and requirements.\nProject details: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('AI Casting & Crew Matching')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your project for casting...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _matchCasting,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Match Talent & Crew'),
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
