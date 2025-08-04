part of 'artist_profile_bloc.dart';

abstract class ArtistProfileState {}

class ArtistProfileInitial extends ArtistProfileState {}

class ArtistProfileLoading extends ArtistProfileState {}

class ArtistProfileSuccess extends ArtistProfileState {
  final dynamic user;
  ArtistProfileSuccess(this.user);
}

class ArtistProfileError extends ArtistProfileState {
  final String message;
  ArtistProfileError(this.message);
}
