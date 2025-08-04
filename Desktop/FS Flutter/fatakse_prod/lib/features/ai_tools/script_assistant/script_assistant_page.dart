import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class ScriptAssistantPage extends StatefulWidget {
  final OpenAIService openAIService;
  const ScriptAssistantPage({super.key, required this.openAIService});

  @override
  State<ScriptAssistantPage> createState() => _ScriptAssistantPageState();
}

class _ScriptAssistantPageState extends State<ScriptAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _assistScript() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI script and storyboard assistant. Given the following script or project details, generate, review, or summarize scripts and storyboards. Suggest shot lists and schedules if relevant.\nScript/project details: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Script/Storyboard Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Paste script or describe your project...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _assistScript,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Get Script Help'),
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
