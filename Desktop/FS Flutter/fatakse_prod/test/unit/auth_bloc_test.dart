import 'package:fatakse_prod/core/services/error_service.dart';

import 'package:get_it/get_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fatakse_prod/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import '../mocks/mock_firebase.dart';
import '../mocks/mock_firestore_collections.mocks.dart';
import '../mocks/mock_services.mocks.dart';
import 'package:fatakse_prod/core/services/cache_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as crashlytics;

class MockCrashlytics extends Mock implements crashlytics.FirebaseCrashlytics {}

final getIt = GetIt.instance;

// A simple fake User implementation for tests
class FakeUser implements firebase_auth.User {
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? phoneNumber;
  // Add any other required fields with dummy values
  FakeUser({required this.uid, this.email, this.displayName, this.phoneNumber});
  // Implement all other members as no-op or dummy
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCacheService implements CacheService {
  @override
  Future<void> initialize() async {}

  @override
  void setMemoryCache(String key, dynamic value, {Duration? expiry}) {}

  @override
  T? getMemoryCache<T>(String key) => null;

  @override
  Future<void> setPersistentCache(
    String key,
    dynamic value, {
    Duration? expiry,
  }) async {}

  @override
  Future<T?> getPersistentCache<T>(String key) async => null;

  @override
  Future<void> removePersistentCache(String key) async {}

  @override
  void clearMemoryCache() {}

  @override
  Future<void> clearPersistentCache() async {}

  @override
  Future<void> cacheUserProfile(Map<String, dynamic> profile) async {}

  @override
  Future<Map<String, dynamic>?> getCachedUserProfile(String userId) async =>
      <String, dynamic>{};

  @override
  Future<String?> getCachedUserRole(String userId) async => null;

  @override
  void cacheSearchResults(
    String query,
    String userRole,
    List<Map<String, dynamic>> results,
  ) {}

  @override
  List<Map<String, dynamic>>? getCachedSearchResults(
    String query,
    String userRole,
  ) => null;

  @override
  Future<void> cacheAppSettings(Map<String, dynamic> settings) async {}

  @override
  Future<Map<String, dynamic>?> getCachedAppSettings() async => null;

  @override
  void cacheNetworkResponse(
    String endpoint,
    Map<String, dynamic> response, {
    Duration? expiry,
  }) {}

  @override
  Map<String, dynamic>? getCachedNetworkResponse(String endpoint) => null;

  @override
  Map<String, dynamic> getCacheStats() => {};

  @override
  Future<void> preloadCriticalData() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    getIt.reset();
    getIt.registerLazySingleton<ErrorService>(
      () => ErrorService(crashlytics: MockCrashlytics()),
    );
  });
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseFirestore mockFirestore;
    late FakeCacheService fakeCacheService;
    late MockSecurityService mockSecurityService;
    late MockErrorService mockErrorService;
    late MockPerformanceService mockPerformanceService;
    late MockLoggerService mockLoggerService;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirestore = MockFirebaseFirestore();
      fakeCacheService = FakeCacheService();
      mockSecurityService = MockSecurityService();
      mockErrorService = MockErrorService();
      mockPerformanceService = MockPerformanceService();
      mockLoggerService = MockLoggerService();
      final fakeUser = FakeUser(
        uid: 'testuid',
        email: 'test@example.com',
        displayName: 'Test User',
        phoneNumber: '',
      );
      when(mockFirebaseAuth.currentUser).thenReturn(fakeUser);
      // Default to valid email
      when(mockSecurityService.isValidEmail(any)).thenReturn(true);
      when(
        mockSecurityService.sanitizeInput(any),
      ).thenAnswer((i) => i.positionalArguments[0]);
      authBloc = AuthBloc(
        firebaseAuth: mockFirebaseAuth,
        firestore: mockFirestore,
        securityService: mockSecurityService,
        errorService: mockErrorService,
        performanceService: mockPerformanceService,
        cacheService: fakeCacheService,
        loggerService: mockLoggerService,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    test(
      'emits [AuthLoading, AuthAuthenticated] on successful sign in',
      () async {
        // Arrange
        final mockUserCredential = MockUserCredential();
        final fakeUser = FakeUser(
          uid: 'testuid',
          email: 'test@example.com',
          displayName: 'Test User',
          phoneNumber: '',
        );
        when(mockUserCredential.user).thenReturn(fakeUser);
        when(mockFirebaseAuth.currentUser).thenReturn(fakeUser);
        mockFirebaseAuth.signInWithEmailAndPasswordHandler =
            ({required email, required password}) async {
              return mockUserCredential;
            };

        // Mock Firestore user document
        final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({
          'id': 'testuid',
          'email': 'test@example.com',
          'firstName': 'Test',
          'lastName': 'User',
          'role': 'artist',
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-01T00:00:00.000Z',
        });
        final mockCollection = MockCollectionReference<Map<String, dynamic>>();
        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        when(mockCollection.doc('testuid')).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockFirestore.collection(any)).thenReturn(mockCollection);

        // Act & Assert
        final expectedStates = [isA<AuthLoading>(), isA<AuthAuthenticated>()];
        expectLater(authBloc.stream, emitsInOrder(expectedStates));
        authBloc.add(
          AuthSignInRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        );
      },
    );
  });
}
