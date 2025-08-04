import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/artist/bloc/artist_pricing_bloc.dart';
import 'package:fatakse_prod/features/artist/pages/pricing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class FakeUser implements User {
  @override
  String get uid => 'test-user-id';
  // Implement other members as needed with throw UnimplementedError or return null
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Artist can update pricing', (tester) async {
    final bloc = ArtistPricingBloc();
    final fakeFirestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth();
    final fakeUser = FakeUser();
    when(mockAuth.currentUser).thenReturn(fakeUser);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: PricingPage(firestore: fakeFirestore, auth: mockAuth),
        ),
      ),
    );
    // Enter price
    // (You may need to add Key('priceField') to the relevant TextField in PricingPage for this to work)
    // await tester.enterText(find.byKey(Key('priceField')), '150');
    // Tap save button
    // await tester.tap(find.byKey(Key('saveButton')));
    // await tester.pump();
    // Should show loading indicator
    // expect(find.byKey(Key('loadingIndicator')), findsOneWidget);
    // Wait for update to complete
    // await tester.pumpAndSettle();
    // Should show success message
    // expect(find.byKey(Key('successText')), findsOneWidget);
  });
}
