import 'package:flutter_test/flutter_test.dart';
import 'package:fatakse_prod/features/artist/bloc/artist_pricing_bloc.dart';

void main() {
  group('ArtistPricingBloc', () {
    late ArtistPricingBloc bloc;
    setUp(() {
      bloc = ArtistPricingBloc();
    });

    test('initial state is ArtistPricingInitial', () {
      expect(bloc.state, isA<ArtistPricingInitial>());
    });

    test('emits loading and success on pricing update', () async {
      final expected = [
        isA<ArtistPricingLoading>(),
        isA<ArtistPricingSuccess>(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(UpdatePricing(100.0));
    });

    test('emits error on exception', () async {
      // To simulate error, inject a mock repo that throws
      // For now, forcibly throw in the bloc (edit bloc for DI in real code)
      // This is a placeholder for error scenario
      // expectLater(...)
    });
  });
}
