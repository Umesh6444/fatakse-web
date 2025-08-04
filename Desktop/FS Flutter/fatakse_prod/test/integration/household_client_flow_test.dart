import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/auth/login_page.dart';
import 'package:fatakse_prod/features/bookings/booking_page.dart';
import 'package:fatakse_prod/features/payments/payment_page.dart';
import 'package:fatakse_prod/features/chat/chat_page.dart';
import 'package:fatakse_prod/features/auth/bloc/auth_bloc.dart';
import 'package:fatakse_prod/features/bookings/bloc/booking_bloc.dart';
import 'package:fatakse_prod/features/payments/bloc/payment_bloc.dart';

void main() {
  group('Household Client End-to-End Flow', () {
    testWidgets('Client can login, book artist, make payment, and chat', (
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
        'client1@example.com',
      );
      await tester.enterText(find.byKey(Key('passwordField')), 'password123');
      await tester.tap(find.byKey(Key('signInButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('successText')), findsOneWidget);

      // Booking
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => BookingBloc(),
            child: BookingPage(),
          ),
        ),
      );
      await tester.enterText(
        find.byKey(Key('detailsField')),
        'Book artist for party',
      );
      await tester.tap(find.byKey(Key('createBookingButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('successText')), findsOneWidget);

      // Payment
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => PaymentBloc(),
            child: PaymentPage(),
          ),
        ),
      );
      await tester.enterText(find.byKey(Key('amountField')), '2000');
      await tester.tap(find.byKey(Key('payButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('successText')), findsOneWidget);

      // Chat
      await tester.pumpWidget(MaterialApp(home: ChatPage()));
      await tester.enterText(find.byKey(Key('messageField')), 'Hi, artist!');
      await tester.tap(find.byKey(Key('sendButton')));
      await tester.pump();
      expect(find.text('Hi, artist!'), findsOneWidget);
    });
  });
}
