import 'package:flutter/material.dart';
import 'package:fatakse_prod/config/app_text_styles.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat', style: AppTextStyles.headline)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                SizedBox(
                  height: 400, // Adjust as needed for your layout
                  child: ListView.builder(
                    key: Key('messagesList'),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        _messages[index],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: Key('messageField'),
                          controller: _messageController,
                          decoration: InputDecoration(
                            labelText: 'Type a message',
                          ),
                        ),
                      ),
                      IconButton(
                        key: Key('sendButton'),
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            setState(() {
                              _messages.add(_messageController.text);
                              _messageController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
