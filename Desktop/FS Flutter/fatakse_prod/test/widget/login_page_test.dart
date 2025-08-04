import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/auth/bloc/auth_bloc.dart';
import 'package:fatakse_prod/features/auth/login_page.dart';

void main() {
  testWidgets('User can sign in and sign out', (tester) async {
    final bloc = AuthBloc();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: bloc, child: LoginPage()),
      ),
    );
    // Enter email and password
    await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'password123');
    // Tap sign in button
    await tester.tap(find.byKey(Key('signInButton')));
    await tester.pump();
    // Should show loading indicator
    expect(find.byKey(Key('loadingIndicator')), findsOneWidget);
    // Wait for sign in to complete
    await tester.pumpAndSettle();
    // Should show welcome message
    expect(find.byKey(Key('successText')), findsOneWidget);

    // Tap sign out button
    await tester.tap(find.byKey(Key('signOutButton')));
    await tester.pump();
    expect(find.byKey(Key('loadingIndicator')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('signOutText')), findsOneWidget);
  });
}
