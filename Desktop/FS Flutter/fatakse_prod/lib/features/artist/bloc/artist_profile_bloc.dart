import 'package:flutter_bloc/flutter_bloc.dart';

part 'artist_profile_event.dart';
part 'artist_profile_state.dart';

class ArtistProfileBloc extends Bloc<ArtistProfileEvent, ArtistProfileState> {
  ArtistProfileBloc() : super(ArtistProfileInitial()) {
    on<UpdateProfile>((event, emit) async {
      emit(ArtistProfileLoading());
      try {
        // Simulate save (replace with real repo call)
        await Future.delayed(Duration(milliseconds: 100));
        emit(ArtistProfileSuccess(event.updatedUser));
      } catch (e) {
        emit(ArtistProfileError('Failed to update profile'));
      }
    });
  }
}
