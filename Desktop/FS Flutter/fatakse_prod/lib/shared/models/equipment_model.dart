import 'package:json_annotation/json_annotation.dart';

part 'equipment_model.g.dart';

/// EquipmentModel represents a vendor's equipment or service listing, including pricing, specs, and availability.
@JsonSerializable(explicitToJson: true)
class EquipmentModel {
  final String id;
  final String name;
  final String description;
  final EquipmentPricing pricing;
  final EquipmentSpecifications specifications;
  final EquipmentAvailability availability;
  final DeliveryOptions deliveryOptions;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pricing,
    required this.specifications,
    required this.availability,
    required this.deliveryOptions,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      _$EquipmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentModelToJson(this);
}

/// EquipmentPricing holds pricing tiers for equipment rental.
@JsonSerializable()
class EquipmentPricing {
  final List<PricingTier> tiers;
  EquipmentPricing({required this.tiers});
  factory EquipmentPricing.fromJson(Map<String, dynamic> json) =>
      _$EquipmentPricingFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentPricingToJson(this);
}

/// PricingTier represents a single pricing option for equipment rental.
@JsonSerializable()
class PricingTier {
  final String label;
  final double price;
  PricingTier({required this.label, required this.price});
  factory PricingTier.fromJson(Map<String, dynamic> json) =>
      _$PricingTierFromJson(json);
  Map<String, dynamic> toJson() => _$PricingTierToJson(this);
}

/// EquipmentSpecifications describes the brand, model, and details of equipment.
@JsonSerializable()
class EquipmentSpecifications {
  final String brand;
  final String model;
  final String details;
  EquipmentSpecifications({
    required this.brand,
    required this.model,
    required this.details,
  });
  factory EquipmentSpecifications.fromJson(Map<String, dynamic> json) =>
      _$EquipmentSpecificationsFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentSpecificationsToJson(this);
}

/// EquipmentAvailability lists available rental periods for equipment.
@JsonSerializable()
class EquipmentAvailability {
  final List<RentalPeriod> availablePeriods;
  EquipmentAvailability({required this.availablePeriods});
  factory EquipmentAvailability.fromJson(Map<String, dynamic> json) =>
      _$EquipmentAvailabilityFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentAvailabilityToJson(this);
}

/// RentalPeriod defines a start and end date for equipment availability.
@JsonSerializable()
class RentalPeriod {
  final DateTime start;
  final DateTime end;
  RentalPeriod({required this.start, required this.end});
  factory RentalPeriod.fromJson(Map<String, dynamic> json) =>
      _$RentalPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$RentalPeriodToJson(this);
}

/// TimeSlot represents a specific day and time for equipment rental.
@JsonSerializable()
class TimeSlot {
  final String day;
  final String time;
  TimeSlot({required this.day, required this.time});
  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}

/// DeliveryOptions specifies delivery availability and fees for equipment.
@JsonSerializable()
class DeliveryOptions {
  final bool deliveryAvailable;
  final double deliveryFee;
  DeliveryOptions({required this.deliveryAvailable, required this.deliveryFee});
  factory DeliveryOptions.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryOptionsToJson(this);
}

/// RentalRequest represents a user's request to rent equipment for a duration.
@JsonSerializable()
class RentalRequest {
  final String userId;
  final RentalDuration duration;
  RentalRequest({required this.userId, required this.duration});
  factory RentalRequest.fromJson(Map<String, dynamic> json) =>
      _$RentalRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RentalRequestToJson(this);
}

/// RentalDuration specifies the number of days for a rental request.
@JsonSerializable()
class RentalDuration {
  final int days;
  RentalDuration({required this.days});
  factory RentalDuration.fromJson(Map<String, dynamic> json) =>
      _$RentalDurationFromJson(json);
  Map<String, dynamic> toJson() => _$RentalDurationToJson(this);
}

enum RentalStatus { available, booked, maintenance }

enum RentalPeriodType { hourly, daily, weekly }
