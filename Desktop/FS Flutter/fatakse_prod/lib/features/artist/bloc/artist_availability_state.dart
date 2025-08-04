part of 'artist_availability_bloc.dart';

abstract class ArtistAvailabilityState {}

class ArtistAvailabilityInitial extends ArtistAvailabilityState {}

class ArtistAvailabilityLoading extends ArtistAvailabilityState {}

class ArtistAvailabilitySuccess extends ArtistAvailabilityState {
  final List<String> availableDays;
  ArtistAvailabilitySuccess(this.availableDays);
}

class ArtistAvailabilityError extends ArtistAvailabilityState {
  final String message;
  ArtistAvailabilityError(this.message);
}
