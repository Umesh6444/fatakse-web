import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class SentimentTrendsPage extends StatefulWidget {
  final OpenAIService openAIService;
  const SentimentTrendsPage({super.key, required this.openAIService});

  @override
  State<SentimentTrendsPage> createState() => _SentimentTrendsPageState();
}

class _SentimentTrendsPageState extends State<SentimentTrendsPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _analyzeTrends() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI analyst. Given the following chat, reviews, and booking data, analyze and surface trending artists, popular event types, or satisfaction insights for both users and admins.\nData: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Sentiment & Trend Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Paste chat, reviews, or booking data...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _analyzeTrends,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Analyze Trends'),
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
