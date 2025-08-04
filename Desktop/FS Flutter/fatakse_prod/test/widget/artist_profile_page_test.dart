import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fatakse_prod/features/artist/pages/profile_page.dart';

class FakeUser implements User {
  @override
  String get uid => 'test-user-id';
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockFirebaseAuth extends Fake implements FirebaseAuth {
  final User? _user;
  MockFirebaseAuth(this._user);
  @override
  User? get currentUser => _user;
}

void main() {
  testWidgets('ArtistProfilePage loads without errors', (tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    final fakeUser = FakeUser();
    final mockAuth = MockFirebaseAuth(fakeUser);

    // Insert a fake user document
    await fakeFirestore.collection('users').doc(fakeUser.uid).set({
      'id': fakeUser.uid,
      'email': 'test@example.com',
      'firstName': 'Test',
      'lastName': 'Artist',
      'role': 'artist',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'isVerified': true,
      'isActive': true,
      'categories': [],
      'roleSpecificData': {
        'artistData': {
          'experienceYears': 1,
          'specializations': [],
          'pricing': {
            'basePrice': 1000.0,
            'pricingType': 'per_event',
            'currency': 'INR',
            'minPrice': 1000.0,
            'maxPrice': 2000.0,
          },
          'portfolioUrls': [],
          'rating': 5.0,
          'totalBookings': 0,
          'isAvailableForTravel': true,
          'languages': ['English'],
          'isSkillVerified': true,
          'isKycVerified': true,
          'kycStatus': 'approved',
          'skillStatus': 'verified',
        },
      },
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: ArtistProfilePage(firestore: fakeFirestore, auth: mockAuth),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Name: Test Artist'), findsOneWidget);
  });
}
