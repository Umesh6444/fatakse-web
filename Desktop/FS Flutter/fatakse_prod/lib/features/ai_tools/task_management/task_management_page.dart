import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class TaskManagementPage extends StatefulWidget {
  final OpenAIService openAIService;
  const TaskManagementPage({super.key, required this.openAIService});

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _generateTasks() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI event project manager. Given the following event details, create a shared event board with tasks, assignments, and deadlines. Suggest AI-powered reminders or risk alerts.\nEvent details: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Collaboration & Task Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your event for task planning...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _generateTasks,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Tasks'),
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
