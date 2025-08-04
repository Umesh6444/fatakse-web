import 'package:mockito/mockito.dart';

import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  Future<UserCredential> Function({
    required String email,
    required String password,
  })?
  signInWithEmailAndPasswordHandler;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // ignore: avoid_print
    print(
      '[MockFirebaseAuth] signInWithEmailAndPassword called with email: '
      '\u001b[35m$email\u001b[0m, password: \u001b[35m$password\u001b[0m',
    );
    if (signInWithEmailAndPasswordHandler != null) {
      return signInWithEmailAndPasswordHandler!(
        email: email,
        password: password,
      );
    }
    return super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [], {
            #email: email,
            #password: password,
          }),
          returnValue: Future.value(MockUserCredential()),
          returnValueForMissingStub: Future.value(MockUserCredential()),
        )
        as Future<UserCredential>;
  }
}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}
