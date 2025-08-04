import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class EventConceptGeneratorPage extends StatefulWidget {
  final OpenAIService openAIService;
  const EventConceptGeneratorPage({super.key, required this.openAIService});

  @override
  State<EventConceptGeneratorPage> createState() =>
      _EventConceptGeneratorPageState();
}

class _EventConceptGeneratorPageState extends State<EventConceptGeneratorPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _generateConcept() async {
    setState(() => _loading = true);
    final prompt =
        'You are an expert event planner. Given the following goals or themes, suggest creative event concepts, schedules, and vendor/artist matches: ${_controller.text}';
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
      appBar: AppBar(title: const Text('AI Event Concept Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your event goals or themes...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _generateConcept,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Concept'),
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
