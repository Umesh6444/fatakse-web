import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class CallSheetsPage extends StatefulWidget {
  final OpenAIService openAIService;
  const CallSheetsPage({super.key, required this.openAIService});

  @override
  State<CallSheetsPage> createState() => _CallSheetsPageState();
}

class _CallSheetsPageState extends State<CallSheetsPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _generateCallSheet() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI production coordinator. Given the following project details, generate a detailed call sheet, brief, and daily plan.\nProject details: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Automated Call Sheets & Briefs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your project for call sheets...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _generateCallSheet,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Call Sheet'),
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
