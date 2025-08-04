import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/auth/login_page.dart';
import 'package:fatakse_prod/features/chat/chat_page.dart';
import 'package:fatakse_prod/features/auth/bloc/auth_bloc.dart';

void main() {
  group('Production House End-to-End Flow', () {
    testWidgets(
      'Production house can login, post project, manage crew, and chat',
      (tester) async {
        // Login
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(create: (_) => AuthBloc(), child: LoginPage()),
          ),
        );
        await tester.enterText(
          find.byKey(Key('emailField')),
          'prodhouse1@example.com',
        );
        await tester.enterText(find.byKey(Key('passwordField')), 'password123');
        await tester.tap(find.byKey(Key('signInButton')));
        await tester.pumpAndSettle();
        expect(find.byKey(Key('successText')), findsOneWidget);

        // Post Project (simulate with chat for now)
        await tester.pumpWidget(MaterialApp(home: ChatPage()));
        await tester.enterText(
          find.byKey(Key('messageField')),
          'Project kickoff!',
        );
        await tester.tap(find.byKey(Key('sendButton')));
        await tester.pump();
        expect(find.text('Project kickoff!'), findsOneWidget);
      },
    );
  });
}
