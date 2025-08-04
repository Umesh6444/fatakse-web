// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentModel _$EquipmentModelFromJson(Map<String, dynamic> json) =>
    EquipmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pricing:
          EquipmentPricing.fromJson(json['pricing'] as Map<String, dynamic>),
      specifications: EquipmentSpecifications.fromJson(
          json['specifications'] as Map<String, dynamic>),
      availability: EquipmentAvailability.fromJson(
          json['availability'] as Map<String, dynamic>),
      deliveryOptions: DeliveryOptions.fromJson(
          json['deliveryOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EquipmentModelToJson(EquipmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'pricing': instance.pricing.toJson(),
      'specifications': instance.specifications.toJson(),
      'availability': instance.availability.toJson(),
      'deliveryOptions': instance.deliveryOptions.toJson(),
    };

EquipmentPricing _$EquipmentPricingFromJson(Map<String, dynamic> json) =>
    EquipmentPricing(
      tiers: (json['tiers'] as List<dynamic>)
          .map((e) => PricingTier.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EquipmentPricingToJson(EquipmentPricing instance) =>
    <String, dynamic>{
      'tiers': instance.tiers,
    };

PricingTier _$PricingTierFromJson(Map<String, dynamic> json) => PricingTier(
      label: json['label'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PricingTierToJson(PricingTier instance) =>
    <String, dynamic>{
      'label': instance.label,
      'price': instance.price,
    };

EquipmentSpecifications _$EquipmentSpecificationsFromJson(
        Map<String, dynamic> json) =>
    EquipmentSpecifications(
      brand: json['brand'] as String,
      model: json['model'] as String,
      details: json['details'] as String,
    );

Map<String, dynamic> _$EquipmentSpecificationsToJson(
        EquipmentSpecifications instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'model': instance.model,
      'details': instance.details,
    };

EquipmentAvailability _$EquipmentAvailabilityFromJson(
        Map<String, dynamic> json) =>
    EquipmentAvailability(
      availablePeriods: (json['availablePeriods'] as List<dynamic>)
          .map((e) => RentalPeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EquipmentAvailabilityToJson(
        EquipmentAvailability instance) =>
    <String, dynamic>{
      'availablePeriods': instance.availablePeriods,
    };

RentalPeriod _$RentalPeriodFromJson(Map<String, dynamic> json) => RentalPeriod(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$RentalPeriodToJson(RentalPeriod instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      day: json['day'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
    };

DeliveryOptions _$DeliveryOptionsFromJson(Map<String, dynamic> json) =>
    DeliveryOptions(
      deliveryAvailable: json['deliveryAvailable'] as bool,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
    );

Map<String, dynamic> _$DeliveryOptionsToJson(DeliveryOptions instance) =>
    <String, dynamic>{
      'deliveryAvailable': instance.deliveryAvailable,
      'deliveryFee': instance.deliveryFee,
    };

RentalRequest _$RentalRequestFromJson(Map<String, dynamic> json) =>
    RentalRequest(
      userId: json['userId'] as String,
      duration:
          RentalDuration.fromJson(json['duration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RentalRequestToJson(RentalRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'duration': instance.duration,
    };

RentalDuration _$RentalDurationFromJson(Map<String, dynamic> json) =>
    RentalDuration(
      days: (json['days'] as num).toInt(),
    );

Map<String, dynamic> _$RentalDurationToJson(RentalDuration instance) =>
    <String, dynamic>{
      'days': instance.days,
    };
