import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class ResourceAllocationPage extends StatefulWidget {
  final OpenAIService openAIService;
  const ResourceAllocationPage({super.key, required this.openAIService});

  @override
  State<ResourceAllocationPage> createState() => _ResourceAllocationPageState();
}

class _ResourceAllocationPageState extends State<ResourceAllocationPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _allocateResources() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an expert event resource planner. Given the following event details, recommend the optimal mix of talent, equipment, and vendors. Consider event type, budget, and best practices from past events.\nEvent details: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Smart Resource Allocation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your event (type, budget, etc.)...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _allocateResources,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Allocate Resources'),
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
