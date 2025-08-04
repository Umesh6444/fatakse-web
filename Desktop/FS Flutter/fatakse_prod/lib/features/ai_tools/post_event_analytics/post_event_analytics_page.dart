import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class PostEventAnalyticsPage extends StatefulWidget {
  final OpenAIService openAIService;
  const PostEventAnalyticsPage({super.key, required this.openAIService});

  @override
  State<PostEventAnalyticsPage> createState() => _PostEventAnalyticsPageState();
}

class _PostEventAnalyticsPageState extends State<PostEventAnalyticsPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _analyzeEvent() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI event analyst. Given the following event feedback, attendance, and engagement data, summarize the event and suggest improvements for future events.\nEvent data: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Post-Event Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Paste event feedback, attendance, etc...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _analyzeEvent,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Analyze Event'),
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
