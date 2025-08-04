import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class TimelineOptimizerPage extends StatefulWidget {
  final OpenAIService openAIService;
  const TimelineOptimizerPage({super.key, required this.openAIService});

  @override
  State<TimelineOptimizerPage> createState() => _TimelineOptimizerPageState();
}

class _TimelineOptimizerPageState extends State<TimelineOptimizerPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _optimizeTimeline() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI production timeline optimizer. Given the following project elements, suggest the most efficient shooting schedule and flag any conflicts or bottlenecks.\nProject elements: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Production Timeline Optimizer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your project elements...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _optimizeTimeline,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Optimize Timeline'),
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
