import 'package:flutter_bloc/flutter_bloc.dart';

part 'artist_availability_event.dart';
part 'artist_availability_state.dart';

class ArtistAvailabilityBloc
    extends Bloc<ArtistAvailabilityEvent, ArtistAvailabilityState> {
  ArtistAvailabilityBloc() : super(ArtistAvailabilityInitial()) {
    on<UpdateAvailability>((event, emit) async {
      emit(ArtistAvailabilityLoading());
      try {
        // Simulate save (replace with real repo call)
        await Future.delayed(Duration(milliseconds: 100));
        emit(ArtistAvailabilitySuccess(event.availableDays));
      } catch (e) {
        emit(ArtistAvailabilityError('Failed to update availability'));
      }
    });
  }
}
