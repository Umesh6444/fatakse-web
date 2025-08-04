part of 'artist_pricing_bloc.dart';

abstract class ArtistPricingState {}

class ArtistPricingInitial extends ArtistPricingState {}

class ArtistPricingLoading extends ArtistPricingState {}

class ArtistPricingSuccess extends ArtistPricingState {
  final double price;
  ArtistPricingSuccess(this.price);
}

class ArtistPricingError extends ArtistPricingState {
  final String message;
  ArtistPricingError(this.message);
}
