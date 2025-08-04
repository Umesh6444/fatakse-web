import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class PortfolioBuilderPage extends StatefulWidget {
  final OpenAIService openAIService;
  const PortfolioBuilderPage({super.key, required this.openAIService});

  @override
  State<PortfolioBuilderPage> createState() => _PortfolioBuilderPageState();
}

class _PortfolioBuilderPageState extends State<PortfolioBuilderPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _buildPortfolio() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI portfolio builder. Given the following uploaded content and reviews, generate a beautiful, AI-curated portfolio for an artist or vendor.\nContent and reviews: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Automated Portfolio Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Paste content and reviews...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _buildPortfolio,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Build Portfolio'),
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
