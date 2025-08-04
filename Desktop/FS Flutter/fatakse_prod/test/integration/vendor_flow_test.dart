import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/auth/login_page.dart';
import 'package:fatakse_prod/features/payments/payment_page.dart';
import 'package:fatakse_prod/features/chat/chat_page.dart';
import 'package:fatakse_prod/features/auth/bloc/auth_bloc.dart';
import 'package:fatakse_prod/features/payments/bloc/payment_bloc.dart';

void main() {
  group('Vendor End-to-End Flow', () {
    testWidgets('Vendor can login, manage rentals, receive payment, and chat', (
      tester,
    ) async {
      // Login
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(create: (_) => AuthBloc(), child: LoginPage()),
        ),
      );
      await tester.enterText(
        find.byKey(Key('emailField')),
        'vendor1@example.com',
      );
      await tester.enterText(find.byKey(Key('passwordField')), 'password123');
      await tester.tap(find.byKey(Key('signInButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('successText')), findsOneWidget);

      // Manage Rentals (simulate with chat for now)
      await tester.pumpWidget(MaterialApp(home: ChatPage()));
      await tester.enterText(
        find.byKey(Key('messageField')),
        'Rental confirmed!',
      );
      await tester.tap(find.byKey(Key('sendButton')));
      await tester.pump();
      expect(find.text('Rental confirmed!'), findsOneWidget);

      // Payment
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => PaymentBloc(),
            child: PaymentPage(),
          ),
        ),
      );
      await tester.enterText(find.byKey(Key('amountField')), '3000');
      await tester.tap(find.byKey(Key('payButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('successText')), findsOneWidget);
    });
  });
}
