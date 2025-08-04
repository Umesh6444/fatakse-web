import 'package:flutter_test/flutter_test.dart';
import 'package:fatakse_prod/features/artist/bloc/artist_profile_bloc.dart';
import '../mocks/test_user_data.dart'; // Ensure this import is present for TestUserData

void main() {
  group('ArtistProfileBloc', () {
    late ArtistProfileBloc bloc;
    setUp(() {
      bloc = ArtistProfileBloc();
    });

    test('initial state is ArtistProfileInitial', () {
      expect(bloc.state, isA<ArtistProfileInitial>());
    });

    test('emits loading and success on profile update', () async {
      final expected = [
        isA<ArtistProfileLoading>(),
        isA<ArtistProfileSuccess>(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(UpdateProfile(TestUserData.artist));
    });

    test('emits error on exception', () async {
      // To simulate error, you would inject a mock repo that throws
      // For now, forcibly throw in the bloc (edit bloc for DI in real code)
      // This is a placeholder for error scenario
      // expectLater(...)
    });
  });
}
