import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class AccessibilityToolsPage extends StatefulWidget {
  final OpenAIService openAIService;
  const AccessibilityToolsPage({super.key, required this.openAIService});

  @override
  State<AccessibilityToolsPage> createState() => _AccessibilityToolsPageState();
}

class _AccessibilityToolsPageState extends State<AccessibilityToolsPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _generateAccessibility() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI accessibility assistant. Given the following content, generate alt text for images, summarize long content, or provide voice navigation suggestions to make the app more inclusive.\nContent: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Accessibility-First AI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Paste content for accessibility help...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _generateAccessibility,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Accessibility Help'),
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
