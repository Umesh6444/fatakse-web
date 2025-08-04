part of 'artist_profile_bloc.dart';

abstract class ArtistProfileEvent {}

class UpdateProfile extends ArtistProfileEvent {
  final dynamic updatedUser;
  UpdateProfile(this.updatedUser);
}
