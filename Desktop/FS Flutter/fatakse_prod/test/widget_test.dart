import 'mocks/mock_query_snapshot.dart';
import 'mocks/mock_query.mocks.dart' as querymocks;
import 'mocks/mock_firestore_collections.mocks.dart' as firemocks;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get_it/get_it.dart';
import 'mocks/mock_booking_service.dart';
import 'mocks/mock_saved_jobs_service.dart';
import 'package:fatakse_prod/core/services/booking_service_interface.dart';
import 'mocks/always_mock_collection_firestore.dart';
// import 'mocks/mock_collection_reference.dart'; // Removed because file does not exist
import 'package:mockito/mockito.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
// TODO: Update import if HomePage is moved. For now, keep as is or fix path if needed.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fatakse_prod/shared/models/user_model.dart';
import 'package:fatakse_prod/features/home/pages/home_page.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  // Mock BookingsPage to avoid disposal errors in widget tests
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    // Replace BookingsPage with a dummy widget
    // ignore: invalid_use_of_internal_member
  });
  // Setup mocks
  final mockQuery = querymocks.MockQuery<Map<String, dynamic>>();
  final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
  final mockCollection =
      firemocks.MockCollectionReference<Map<String, dynamic>>();
  // Stub where on the mockCollection to return the mockQuery
  when(
    mockCollection.where(
      any,
      isNull: anyNamed('isNull'),
      isEqualTo: anyNamed('isEqualTo'),
      isNotEqualTo: anyNamed('isNotEqualTo'),
      isLessThan: anyNamed('isLessThan'),
      isLessThanOrEqualTo: anyNamed('isLessThanOrEqualTo'),
      isGreaterThan: anyNamed('isGreaterThan'),
      isGreaterThanOrEqualTo: anyNamed('isGreaterThanOrEqualTo'),
      arrayContains: anyNamed('arrayContains'),
      arrayContainsAny: anyNamed('arrayContainsAny'),
      whereIn: anyNamed('whereIn'),
      whereNotIn: anyNamed('whereNotIn'),
    ),
  ).thenReturn(mockQuery);
  // Allow chained where calls on the mockQuery
  when(
    mockQuery.where(
      any,
      isNull: anyNamed('isNull'),
      isEqualTo: anyNamed('isEqualTo'),
      isNotEqualTo: anyNamed('isNotEqualTo'),
      isLessThan: anyNamed('isLessThan'),
      isLessThanOrEqualTo: anyNamed('isLessThanOrEqualTo'),
      isGreaterThan: anyNamed('isGreaterThan'),
      isGreaterThanOrEqualTo: anyNamed('isGreaterThanOrEqualTo'),
      arrayContains: anyNamed('arrayContains'),
      arrayContainsAny: anyNamed('arrayContainsAny'),
      whereIn: anyNamed('whereIn'),
      whereNotIn: anyNamed('whereNotIn'),
    ),
  ).thenReturn(mockQuery);
  when(mockQuery.snapshots()).thenAnswer(
    (_) => Stream<QuerySnapshot<Map<String, dynamic>>>.fromIterable([
      mockQuerySnapshot,
    ]),
  );
  when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
  when(mockCollection.snapshots()).thenAnswer(
    (_) => Stream<QuerySnapshot<Map<String, dynamic>>>.fromIterable([
      mockQuerySnapshot,
    ]),
  );

  testWidgets('HomePage renders welcome text', (WidgetTester tester) async {
    // Register mock IBookingService with GetIt
    final getIt = GetIt.instance;
    getIt.reset();
    getIt.registerLazySingleton<IBookingService>(() => MockBookingService());
    final testUser = UserModel(
      id: 'test',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      role: 'testrole', // Not handled by switch, triggers default dashboard
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final mockAuthBloc = MockAuthBloc();
    whenListen(
      mockAuthBloc,
      Stream<AuthState>.fromIterable([AuthAuthenticated(testUser)]),
      initialState: AuthAuthenticated(testUser),
    );

    final mockFirestore = AlwaysMockCollectionFirestore(mockCollection);
    final mockSavedJobsService = MockSavedJobsService();

    // Dummy BookingsPage to avoid disposal errors
    Widget dummyBookingsPageBuilder(String role) => const SizedBox.shrink();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: MaterialApp(
              home: HomePage(
                firestore: mockFirestore,
                savedJobsService: mockSavedJobsService,
                bookingsPageBuilder: dummyBookingsPageBuilder,
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Fatakse!'), findsOneWidget);
  });
}
