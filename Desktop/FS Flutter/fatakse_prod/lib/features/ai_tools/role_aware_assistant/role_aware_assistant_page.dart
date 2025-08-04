import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class RoleAwareAssistantPage extends StatefulWidget {
  final String userRole;
  final OpenAIService openAIService;
  const RoleAwareAssistantPage({
    super.key,
    required this.userRole,
    required this.openAIService,
  });

  @override
  State<RoleAwareAssistantPage> createState() => _RoleAwareAssistantPageState();
}

class _RoleAwareAssistantPageState extends State<RoleAwareAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _askAI() async {
    setState(() => _loading = true);
    final prompt =
        'You are a helpful assistant for a ${widget.userRole}. ${_controller.text}';
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
      appBar: AppBar(title: Text('AI Assistant (${widget.userRole})')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Ask something...'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _askAI,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Ask AI'),
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
