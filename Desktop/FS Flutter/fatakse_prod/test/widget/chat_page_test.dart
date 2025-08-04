import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fatakse_prod/features/chat/chat_page.dart';

void main() {
  testWidgets('User can send a message', (tester) async {
    await tester.pumpWidget(MaterialApp(home: ChatPage()));
    // Enter a message
    await tester.enterText(find.byKey(Key('messageField')), 'Hello!');
    // Tap send button
    await tester.tap(find.byKey(Key('sendButton')));
    await tester.pump();
    // Should show the message in the list
    expect(find.text('Hello!'), findsOneWidget);
  });
}
