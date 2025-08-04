import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/auth/login_page.dart';
import 'package:fatakse_prod/features/bookings/booking_page.dart';
import 'package:fatakse_prod/features/chat/chat_page.dart';
import 'package:fatakse_prod/features/auth/bloc/auth_bloc.dart';
import 'package:fatakse_prod/features/bookings/bloc/booking_bloc.dart';

void main() {
  group('Event Planner End-to-End Flow', () {
    testWidgets(
      'Event planner can login, source talent, manage event, and chat',
      (tester) async {
        // Login
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(create: (_) => AuthBloc(), child: LoginPage()),
          ),
        );
        await tester.enterText(
          find.byKey(Key('emailField')),
          'planner1@example.com',
        );
        await tester.enterText(find.byKey(Key('passwordField')), 'password123');
        await tester.tap(find.byKey(Key('signInButton')));
        await tester.pumpAndSettle();
        expect(find.byKey(Key('successText')), findsOneWidget);

        // Source Talent/Booking
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
          'Source artist for event',
        );
        await tester.tap(find.byKey(Key('createBookingButton')));
        await tester.pumpAndSettle();
        expect(find.byKey(Key('successText')), findsOneWidget);

        // Chat
        await tester.pumpWidget(MaterialApp(home: ChatPage()));
        await tester.enterText(
          find.byKey(Key('messageField')),
          'Let’s coordinate!',
        );
        await tester.tap(find.byKey(Key('sendButton')));
        await tester.pump();
        expect(find.text('Let’s coordinate!'), findsOneWidget);
      },
    );
  });
}
