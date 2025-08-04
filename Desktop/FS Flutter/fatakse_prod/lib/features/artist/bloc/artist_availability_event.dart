part of 'artist_availability_bloc.dart';

abstract class ArtistAvailabilityEvent {}

class UpdateAvailability extends ArtistAvailabilityEvent {
  final List<String> availableDays;
  UpdateAvailability(this.availableDays);
}
