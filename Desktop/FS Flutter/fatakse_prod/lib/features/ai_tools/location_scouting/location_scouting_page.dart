import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class LocationScoutingPage extends StatefulWidget {
  final OpenAIService openAIService;
  const LocationScoutingPage({super.key, required this.openAIService});

  @override
  State<LocationScoutingPage> createState() => _LocationScoutingPageState();
}

class _LocationScoutingPageState extends State<LocationScoutingPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _scoutLocation() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI location and equipment scout. Given the following scene or requirement, suggest suitable locations and equipment from the available vendor pool.\nScene/requirement: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Location & Equipment Scouting')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your scene or requirement...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _scoutLocation,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Scout Location/Equipment'),
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
