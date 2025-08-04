import 'package:flutter_bloc/flutter_bloc.dart';

part 'artist_pricing_event.dart';
part 'artist_pricing_state.dart';

class ArtistPricingBloc extends Bloc<ArtistPricingEvent, ArtistPricingState> {
  ArtistPricingBloc() : super(ArtistPricingInitial()) {
    on<UpdatePricing>((event, emit) async {
      emit(ArtistPricingLoading());
      try {
        // Simulate save (replace with real repo call)
        await Future.delayed(Duration(milliseconds: 100));
        emit(ArtistPricingSuccess(event.price));
      } catch (e) {
        emit(ArtistPricingError('Failed to update pricing'));
      }
    });
  }
}
