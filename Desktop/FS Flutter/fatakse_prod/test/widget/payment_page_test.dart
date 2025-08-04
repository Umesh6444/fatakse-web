import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/payments/bloc/payment_bloc.dart';

import 'package:fatakse_prod/features/payments/payment_page.dart';

void main() {
  testWidgets('User can initiate payment', (tester) async {
    final bloc = PaymentBloc();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: bloc, child: PaymentPage()),
      ),
    );
    // Enter amount
    await tester.enterText(find.byKey(Key('amountField')), '100');
    // Tap pay button
    await tester.tap(find.byKey(Key('payButton')));
    await tester.pump();
    // Should show loading indicator
    expect(find.byKey(Key('loadingIndicator')), findsOneWidget);
    // Wait for payment to complete
    await tester.pumpAndSettle();
    // Should show success message
    expect(find.byKey(Key('successText')), findsOneWidget);
  });
}
