import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/bookings/bloc/booking_bloc.dart';
import 'package:fatakse_prod/features/bookings/booking_page.dart';

void main() {
  testWidgets('User can create and cancel booking', (tester) async {
    final bloc = BookingBloc();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: bloc, child: BookingPage()),
      ),
    );
    // Enter booking details
    await tester.enterText(find.byKey(Key('detailsField')), 'Test booking');
    // Tap create booking button
    await tester.tap(find.byKey(Key('createBookingButton')));
    await tester.pump();
    // Should show loading indicator
    expect(find.byKey(Key('loadingIndicator')), findsOneWidget);
    // Wait for booking to complete
    await tester.pumpAndSettle();
    // Should show success message
    expect(find.byKey(Key('successText')), findsOneWidget);

    // Tap cancel booking button
    await tester.tap(find.byKey(Key('cancelBookingButton')));
    await tester.pump();
    expect(find.byKey(Key('loadingIndicator')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('cancelText')), findsOneWidget);
  });
}
