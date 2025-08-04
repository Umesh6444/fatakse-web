import 'package:flutter/material.dart';
import '../../../core/services/openai_service.dart';

class MediaAssetManagementPage extends StatefulWidget {
  final OpenAIService openAIService;
  const MediaAssetManagementPage({super.key, required this.openAIService});

  @override
  State<MediaAssetManagementPage> createState() =>
      _MediaAssetManagementPageState();
}

class _MediaAssetManagementPageState extends State<MediaAssetManagementPage> {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _loading = false;

  Future<void> _manageAssets() async {
    setState(() => _loading = true);
    final prompt =
        '''You are an AI media asset manager. Given the following video/photo asset descriptions, tag, organize, and summarize them for easy retrieval and sharing.\nAsset descriptions: ${_controller.text}''';
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
      appBar: AppBar(title: const Text('Media Asset Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Describe your video/photo assets...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _manageAssets,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Manage Assets'),
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
