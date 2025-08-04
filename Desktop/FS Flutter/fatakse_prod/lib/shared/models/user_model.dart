import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// UserModel represents a user profile in the system, including role, contact, and profile details.
@JsonSerializable()
class UserModel extends Equatable {
  /// Unique user ID (matches Firebase Auth UID).
  final String id;

  /// User's email address.
  final String email;

  /// Optional phone number.
  final String? phoneNumber;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// User role (artist, client, vendor, etc.).
  final String role;

  /// Optional profile image URL.
  final String? profileImageUrl;

  /// Optional user bio.
  final String? bio;

  /// Account creation timestamp.
  final DateTime createdAt;

  /// Last profile update timestamp.
  final DateTime updatedAt;

  /// Whether the user is verified.
  final bool isVerified;

  /// Whether the user is active.
  final bool isActive;

  /// List of categories/interests.
  final List<String> categories;

  /// Optional location details.
  final LocationModel? location;

  /// Optional social links.
  final SocialLinksModel? socialLinks;

  /// Optional role-specific data (artist, vendor, etc.).
  final RoleSpecificDataModel? roleSpecificData;

  const UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.profileImageUrl,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
    this.categories = const [],
    this.location,
    this.socialLinks,
    this.roleSpecificData,
  });

  /// Returns the user's full name.
  String get fullName => '$firstName $lastName';

  /// Returns the display name (full name or email if name is empty).
  String get displayName => fullName.trim().isEmpty ? email : fullName;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? role,
    String? profileImageUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
    List<String>? categories,
    LocationModel? location,
    SocialLinksModel? socialLinks,
    RoleSpecificDataModel? roleSpecificData,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      categories: categories ?? this.categories,
      location: location ?? this.location,
      socialLinks: socialLinks ?? this.socialLinks,
      roleSpecificData: roleSpecificData ?? this.roleSpecificData,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    phoneNumber,
    firstName,
    lastName,
    role,
    profileImageUrl,
    bio,
    createdAt,
    updatedAt,
    isVerified,
    isActive,
    categories,
    location,
    socialLinks,
    roleSpecificData,
  ];
}

/// LocationModel represents a user's address and geolocation.
@JsonSerializable()
class LocationModel extends Equatable {
  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final double? latitude;
  final double? longitude;

  const LocationModel({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    this.latitude,
    this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  @override
  List<Object?> get props => [
    address,
    city,
    state,
    country,
    pincode,
    latitude,
    longitude,
  ];
}

/// SocialLinksModel holds links to a user's social media profiles.
@JsonSerializable()
class SocialLinksModel extends Equatable {
  final String? instagram;
  final String? facebook;
  final String? youtube;
  final String? twitter;
  final String? linkedin;
  final String? website;

  const SocialLinksModel({
    this.instagram,
    this.facebook,
    this.youtube,
    this.twitter,
    this.linkedin,
    this.website,
  });

  factory SocialLinksModel.fromJson(Map<String, dynamic> json) =>
      _$SocialLinksModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLinksModelToJson(this);

  @override
  List<Object?> get props => [
    instagram,
    facebook,
    youtube,
    twitter,
    linkedin,
    website,
  ];
}

/// RoleSpecificDataModel holds additional data for specific user roles (artist, vendor, etc.).
@JsonSerializable()
class RoleSpecificDataModel extends Equatable {
  RoleSpecificDataModel copyWith({
    ArtistDataModel? artistData,
    VendorDataModel? vendorData,
    EventPlannerDataModel? eventPlannerData,
    ProductionHouseDataModel? productionHouseData,
  }) {
    return RoleSpecificDataModel(
      artistData: artistData ?? this.artistData,
      vendorData: vendorData ?? this.vendorData,
      eventPlannerData: eventPlannerData ?? this.eventPlannerData,
      productionHouseData: productionHouseData ?? this.productionHouseData,
    );
  }

  final ArtistDataModel? artistData;
  final VendorDataModel? vendorData;
  final EventPlannerDataModel? eventPlannerData;
  final ProductionHouseDataModel? productionHouseData;

  const RoleSpecificDataModel({
    this.artistData,
    this.vendorData,
    this.eventPlannerData,
    this.productionHouseData,
  });

  factory RoleSpecificDataModel.fromJson(Map<String, dynamic> json) =>
      _$RoleSpecificDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleSpecificDataModelToJson(this);

  @override
  List<Object?> get props => [
    artistData,
    vendorData,
    eventPlannerData,
    productionHouseData,
  ];
}

/// ArtistDataModel holds artist-specific profile data and verification status.
@JsonSerializable()
class ArtistDataModel extends Equatable {
  final String kycStatus; // 'pending', 'approved', 'rejected'
  final String skillStatus; // 'pending', 'approved', 'rejected'
  ArtistDataModel copyWith({
    int? experienceYears,
    List<String>? specializations,
    PricingModel? pricing,
    List<String>? portfolioUrls,
    double? rating,
    int? totalBookings,
    bool? isAvailableForTravel,
    List<String>? languages,
    bool? isSkillVerified,
    bool? isKycVerified,
    String? kycStatus,
    String? skillStatus,
  }) {
    return ArtistDataModel(
      experienceYears: experienceYears ?? this.experienceYears,
      specializations: specializations ?? this.specializations,
      pricing: pricing ?? this.pricing,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      rating: rating ?? this.rating,
      totalBookings: totalBookings ?? this.totalBookings,
      isAvailableForTravel: isAvailableForTravel ?? this.isAvailableForTravel,
      languages: languages ?? this.languages,
      isSkillVerified: isSkillVerified ?? this.isSkillVerified,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      kycStatus: kycStatus ?? this.kycStatus,
      skillStatus: skillStatus ?? this.skillStatus,
    );
  }

  final int experienceYears;
  final List<String> specializations;
  final PricingModel pricing;
  final List<String> portfolioUrls;
  final double rating;
  final int totalBookings;
  final bool isAvailableForTravel;
  final List<String> languages;
  final bool isSkillVerified;
  final bool isKycVerified;

  const ArtistDataModel({
    required this.experienceYears,
    required this.specializations,
    required this.pricing,
    this.portfolioUrls = const [],
    this.rating = 0.0,
    this.totalBookings = 0,
    this.isAvailableForTravel = false,
    this.languages = const [],
    this.isSkillVerified = false,
    this.isKycVerified = false,
    this.kycStatus = 'pending',
    this.skillStatus = 'pending',
  });

  factory ArtistDataModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistDataModelToJson(this);

  @override
  List<Object?> get props => [
    experienceYears,
    specializations,
    pricing,
    portfolioUrls,
    rating,
    totalBookings,
    isAvailableForTravel,
    languages,
    isSkillVerified,
    isKycVerified,
    kycStatus,
    skillStatus,
  ];
}

/// VendorDataModel holds vendor-specific business and equipment data.
@JsonSerializable()
class VendorDataModel extends Equatable {
  final String businessName;
  final String businessType;
  final List<String> serviceCategories;
  final String description;
  final List<String> equipmentImages;
  final double rating;
  final int totalRentals;
  final bool isDeliveryAvailable;
  final DeliveryInfoModel? deliveryInfo;

  const VendorDataModel({
    required this.businessName,
    required this.businessType,
    required this.serviceCategories,
    required this.description,
    this.equipmentImages = const [],
    this.rating = 0.0,
    this.totalRentals = 0,
    this.isDeliveryAvailable = false,
    this.deliveryInfo,
  });

  factory VendorDataModel.fromJson(Map<String, dynamic> json) =>
      _$VendorDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorDataModelToJson(this);

  @override
  List<Object?> get props => [
    businessName,
    businessType,
    serviceCategories,
    description,
    equipmentImages,
    rating,
    totalRentals,
    isDeliveryAvailable,
    deliveryInfo,
  ];
}

/// EventPlannerDataModel holds event planner-specific company and event data.
@JsonSerializable()
class EventPlannerDataModel extends Equatable {
  final String companyName;
  final int teamSize;
  final List<String> eventTypes;
  final int eventsOrganized;
  final double rating;
  final List<String> clientTestimonials;

  const EventPlannerDataModel({
    required this.companyName,
    required this.teamSize,
    required this.eventTypes,
    this.eventsOrganized = 0,
    this.rating = 0.0,
    this.clientTestimonials = const [],
  });

  factory EventPlannerDataModel.fromJson(Map<String, dynamic> json) =>
      _$EventPlannerDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventPlannerDataModelToJson(this);

  @override
  List<Object?> get props => [
    companyName,
    teamSize,
    eventTypes,
    eventsOrganized,
    rating,
    clientTestimonials,
  ];
}

/// ProductionHouseDataModel holds production house-specific data and project history.
@JsonSerializable()
class ProductionHouseDataModel extends Equatable {
  final String companyName;
  final List<String> productionTypes;
  final List<String> pastProjects;
  final String equipment;
  final int teamSize;

  const ProductionHouseDataModel({
    required this.companyName,
    required this.productionTypes,
    this.pastProjects = const [],
    required this.equipment,
    required this.teamSize,
  });

  factory ProductionHouseDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionHouseDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionHouseDataModelToJson(this);

  @override
  List<Object?> get props => [
    companyName,
    productionTypes,
    pastProjects,
    equipment,
    teamSize,
  ];
}

/// PricingModel represents pricing details for a service or artist.
@JsonSerializable()
class PricingModel extends Equatable {
  final double basePrice;
  final String pricingType; // 'per_hour', 'per_day', 'per_event', 'fixed'
  final double? minPrice;
  final double? maxPrice;
  final String currency;

  const PricingModel({
    required this.basePrice,
    required this.pricingType,
    this.minPrice,
    this.maxPrice,
    this.currency = 'INR',
  });

  factory PricingModel.fromJson(Map<String, dynamic> json) =>
      _$PricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PricingModelToJson(this);

  @override
  List<Object?> get props => [
    basePrice,
    pricingType,
    minPrice,
    maxPrice,
    currency,
  ];
}

/// DeliveryInfoModel holds delivery-related information for vendors.
@JsonSerializable()
class DeliveryInfoModel extends Equatable {
  final double deliveryCharge;
  final int maxDeliveryDistance; // in kilometers
  final String deliveryTime; // e.g., "Same day", "Next day"

  const DeliveryInfoModel({
    required this.deliveryCharge,
    required this.maxDeliveryDistance,
    required this.deliveryTime,
  });

  factory DeliveryInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryInfoModelToJson(this);

  @override
  List<Object?> get props => [
    deliveryCharge,
    maxDeliveryDistance,
    deliveryTime,
  ];
}
