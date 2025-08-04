import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class ProposalBuilderPage extends StatefulWidget {
  final OpenAIService openAIService;
  const ProposalBuilderPage({super.key, required this.openAIService});

  @override
  State<ProposalBuilderPage> createState() => _ProposalBuilderPageState();
}

class _ProposalBuilderPageState extends State<ProposalBuilderPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _generateProposal() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an expert event proposal writer. Given the following event details, generate a professional, branded proposal for a client. Include a creative description, timeline, and cost breakdown.\nEvent details: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Automated Proposal Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your event for the proposal...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _generateProposal,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Proposal'),
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
