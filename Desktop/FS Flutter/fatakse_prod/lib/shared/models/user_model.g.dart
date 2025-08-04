// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      socialLinks: json['socialLinks'] == null
          ? null
          : SocialLinksModel.fromJson(
              json['socialLinks'] as Map<String, dynamic>),
      roleSpecificData: json['roleSpecificData'] == null
          ? null
          : RoleSpecificDataModel.fromJson(
              json['roleSpecificData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': instance.role,
      'profileImageUrl': instance.profileImageUrl,
      'bio': instance.bio,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'categories': instance.categories,
      'location': instance.location,
      'socialLinks': instance.socialLinks,
      'roleSpecificData': instance.roleSpecificData,
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      pincode: json['pincode'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'pincode': instance.pincode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

SocialLinksModel _$SocialLinksModelFromJson(Map<String, dynamic> json) =>
    SocialLinksModel(
      instagram: json['instagram'] as String?,
      facebook: json['facebook'] as String?,
      youtube: json['youtube'] as String?,
      twitter: json['twitter'] as String?,
      linkedin: json['linkedin'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$SocialLinksModelToJson(SocialLinksModel instance) =>
    <String, dynamic>{
      'instagram': instance.instagram,
      'facebook': instance.facebook,
      'youtube': instance.youtube,
      'twitter': instance.twitter,
      'linkedin': instance.linkedin,
      'website': instance.website,
    };

RoleSpecificDataModel _$RoleSpecificDataModelFromJson(
        Map<String, dynamic> json) =>
    RoleSpecificDataModel(
      artistData: json['artistData'] == null
          ? null
          : ArtistDataModel.fromJson(
              json['artistData'] as Map<String, dynamic>),
      vendorData: json['vendorData'] == null
          ? null
          : VendorDataModel.fromJson(
              json['vendorData'] as Map<String, dynamic>),
      eventPlannerData: json['eventPlannerData'] == null
          ? null
          : EventPlannerDataModel.fromJson(
              json['eventPlannerData'] as Map<String, dynamic>),
      productionHouseData: json['productionHouseData'] == null
          ? null
          : ProductionHouseDataModel.fromJson(
              json['productionHouseData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoleSpecificDataModelToJson(
        RoleSpecificDataModel instance) =>
    <String, dynamic>{
      'artistData': instance.artistData,
      'vendorData': instance.vendorData,
      'eventPlannerData': instance.eventPlannerData,
      'productionHouseData': instance.productionHouseData,
    };

ArtistDataModel _$ArtistDataModelFromJson(Map<String, dynamic> json) =>
    ArtistDataModel(
      experienceYears: (json['experienceYears'] as num).toInt(),
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pricing: PricingModel.fromJson(json['pricing'] as Map<String, dynamic>),
      portfolioUrls: (json['portfolioUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalBookings: (json['totalBookings'] as num?)?.toInt() ?? 0,
      isAvailableForTravel: json['isAvailableForTravel'] as bool? ?? false,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isSkillVerified: json['isSkillVerified'] as bool? ?? false,
      isKycVerified: json['isKycVerified'] as bool? ?? false,
      kycStatus: json['kycStatus'] as String? ?? 'pending',
      skillStatus: json['skillStatus'] as String? ?? 'pending',
    );

Map<String, dynamic> _$ArtistDataModelToJson(ArtistDataModel instance) =>
    <String, dynamic>{
      'kycStatus': instance.kycStatus,
      'skillStatus': instance.skillStatus,
      'experienceYears': instance.experienceYears,
      'specializations': instance.specializations,
      'pricing': instance.pricing,
      'portfolioUrls': instance.portfolioUrls,
      'rating': instance.rating,
      'totalBookings': instance.totalBookings,
      'isAvailableForTravel': instance.isAvailableForTravel,
      'languages': instance.languages,
      'isSkillVerified': instance.isSkillVerified,
      'isKycVerified': instance.isKycVerified,
    };

VendorDataModel _$VendorDataModelFromJson(Map<String, dynamic> json) =>
    VendorDataModel(
      businessName: json['businessName'] as String,
      businessType: json['businessType'] as String,
      serviceCategories: (json['serviceCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      equipmentImages: (json['equipmentImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRentals: (json['totalRentals'] as num?)?.toInt() ?? 0,
      isDeliveryAvailable: json['isDeliveryAvailable'] as bool? ?? false,
      deliveryInfo: json['deliveryInfo'] == null
          ? null
          : DeliveryInfoModel.fromJson(
              json['deliveryInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VendorDataModelToJson(VendorDataModel instance) =>
    <String, dynamic>{
      'businessName': instance.businessName,
      'businessType': instance.businessType,
      'serviceCategories': instance.serviceCategories,
      'description': instance.description,
      'equipmentImages': instance.equipmentImages,
      'rating': instance.rating,
      'totalRentals': instance.totalRentals,
      'isDeliveryAvailable': instance.isDeliveryAvailable,
      'deliveryInfo': instance.deliveryInfo,
    };

EventPlannerDataModel _$EventPlannerDataModelFromJson(
        Map<String, dynamic> json) =>
    EventPlannerDataModel(
      companyName: json['companyName'] as String,
      teamSize: (json['teamSize'] as num).toInt(),
      eventTypes: (json['eventTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      eventsOrganized: (json['eventsOrganized'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      clientTestimonials: (json['clientTestimonials'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$EventPlannerDataModelToJson(
        EventPlannerDataModel instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'teamSize': instance.teamSize,
      'eventTypes': instance.eventTypes,
      'eventsOrganized': instance.eventsOrganized,
      'rating': instance.rating,
      'clientTestimonials': instance.clientTestimonials,
    };

ProductionHouseDataModel _$ProductionHouseDataModelFromJson(
        Map<String, dynamic> json) =>
    ProductionHouseDataModel(
      companyName: json['companyName'] as String,
      productionTypes: (json['productionTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pastProjects: (json['pastProjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      equipment: json['equipment'] as String,
      teamSize: (json['teamSize'] as num).toInt(),
    );

Map<String, dynamic> _$ProductionHouseDataModelToJson(
        ProductionHouseDataModel instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'productionTypes': instance.productionTypes,
      'pastProjects': instance.pastProjects,
      'equipment': instance.equipment,
      'teamSize': instance.teamSize,
    };

PricingModel _$PricingModelFromJson(Map<String, dynamic> json) => PricingModel(
      basePrice: (json['basePrice'] as num).toDouble(),
      pricingType: json['pricingType'] as String,
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'INR',
    );

Map<String, dynamic> _$PricingModelToJson(PricingModel instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'pricingType': instance.pricingType,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'currency': instance.currency,
    };

DeliveryInfoModel _$DeliveryInfoModelFromJson(Map<String, dynamic> json) =>
    DeliveryInfoModel(
      deliveryCharge: (json['deliveryCharge'] as num).toDouble(),
      maxDeliveryDistance: (json['maxDeliveryDistance'] as num).toInt(),
      deliveryTime: json['deliveryTime'] as String,
    );

Map<String, dynamic> _$DeliveryInfoModelToJson(DeliveryInfoModel instance) =>
    <String, dynamic>{
      'deliveryCharge': instance.deliveryCharge,
      'maxDeliveryDistance': instance.maxDeliveryDistance,
      'deliveryTime': instance.deliveryTime,
    };
