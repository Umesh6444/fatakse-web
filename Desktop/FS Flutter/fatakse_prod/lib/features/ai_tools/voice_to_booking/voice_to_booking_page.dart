import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class VoiceToBookingPage extends StatefulWidget {
  final OpenAIService openAIService;
  const VoiceToBookingPage({super.key, required this.openAIService});

  @override
  State<VoiceToBookingPage> createState() => _VoiceToBookingPageState();
}

class _VoiceToBookingPageState extends State<VoiceToBookingPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _processBooking() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI booking assistant. Given the following user request (transcribed from voice), turn it into a structured booking or inquiry.\nUser request: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Voice-to-Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Paste or dictate your booking request...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _processBooking,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Process Booking'),
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
