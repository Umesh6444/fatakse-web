import 'package:flutter_test/flutter_test.dart';
import 'package:fatakse_prod/features/artist/bloc/artist_availability_bloc.dart';

void main() {
  group('ArtistAvailabilityBloc', () {
    late ArtistAvailabilityBloc bloc;
    setUp(() {
      bloc = ArtistAvailabilityBloc();
    });

    test('initial state is ArtistAvailabilityInitial', () {
      expect(bloc.state, isA<ArtistAvailabilityInitial>());
    });

    test('emits loading and success on availability update', () async {
      final expected = [
        isA<ArtistAvailabilityLoading>(),
        isA<ArtistAvailabilitySuccess>(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(UpdateAvailability(['Monday', 'Tuesday']));
    });

    test('emits error on exception', () async {
      // To simulate error, inject a mock repo that throws
      // For now, forcibly throw in the bloc (edit bloc for DI in real code)
      // This is a placeholder for error scenario
      // expectLater(...)
    });
  });
}
