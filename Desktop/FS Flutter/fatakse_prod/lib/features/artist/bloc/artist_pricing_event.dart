part of 'artist_pricing_bloc.dart';

abstract class ArtistPricingEvent {}

class UpdatePricing extends ArtistPricingEvent {
  final double price;
  UpdatePricing(this.price);
}
