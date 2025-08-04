import 'package:firebase_core/firebase_core.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/artist/bloc/artist_availability_bloc.dart';
import 'package:fatakse_prod/features/artist/pages/availability_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp();
    // Optionally, set up FakeFirebaseFirestore or mockito mocks here if you inject them into your widgets
  });
  testWidgets('Artist can update availability', (tester) async {
    final bloc = ArtistAvailabilityBloc();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: bloc, child: AvailabilityPage()),
      ),
    );
    // Enter available days
    await tester.enterText(find.byKey(Key('daysField')), 'Monday,Tuesday');
    // Tap save button
    await tester.tap(find.byKey(Key('saveButton')));
    await tester.pump();
    // Should show loading indicator
    expect(find.byKey(Key('loadingIndicator')), findsOneWidget);
    // Wait for update to complete
    await tester.pumpAndSettle();
    // Should show success message
    expect(find.byKey(Key('successText')), findsOneWidget);
  });
}
