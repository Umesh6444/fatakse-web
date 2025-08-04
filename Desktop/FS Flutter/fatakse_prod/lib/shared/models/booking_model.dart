import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

/// BookingModel represents a booking request or confirmation between a client and a provider (artist or vendor).
@JsonSerializable()
class BookingModel extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String providerId; // Artist or Vendor ID
  final String providerName;
  final String providerType; // 'artist' or 'vendor'
  final String eventTitle;
  final String eventDescription;
  final DateTime eventDate;
  final DateTime eventStartTime;
  final DateTime eventEndTime;
  final LocationDetails eventLocation;
  final BookingStatus status;
  final PaymentDetails paymentDetails;
  final List<String> requirements;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> attachments;
  final ReviewModel? review;

  const BookingModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.providerId,
    required this.providerName,
    required this.providerType,
    required this.eventTitle,
    required this.eventDescription,
    required this.eventDate,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.eventLocation,
    required this.status,
    required this.paymentDetails,
    this.requirements = const [],
    this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
    this.attachments = const [],
    this.review,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  BookingModel copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? providerId,
    String? providerName,
    String? providerType,
    String? eventTitle,
    String? eventDescription,
    DateTime? eventDate,
    DateTime? eventStartTime,
    DateTime? eventEndTime,
    LocationDetails? eventLocation,
    BookingStatus? status,
    PaymentDetails? paymentDetails,
    List<String>? requirements,
    String? specialInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attachments,
    ReviewModel? review,
  }) {
    return BookingModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerType: providerType ?? this.providerType,
      eventTitle: eventTitle ?? this.eventTitle,
      eventDescription: eventDescription ?? this.eventDescription,
      eventDate: eventDate ?? this.eventDate,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventEndTime: eventEndTime ?? this.eventEndTime,
      eventLocation: eventLocation ?? this.eventLocation,
      status: status ?? this.status,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      requirements: requirements ?? this.requirements,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      review: review ?? this.review,
    );
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    clientName,
    providerId,
    providerName,
    providerType,
    eventTitle,
    eventDescription,
    eventDate,
    eventStartTime,
    eventEndTime,
    eventLocation,
    status,
    paymentDetails,
    requirements,
    specialInstructions,
    createdAt,
    updatedAt,
    attachments,
    review,
  ];
}

/// LocationDetails holds address and geolocation information for an event.
@JsonSerializable()
class LocationDetails extends Equatable {
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final String? landmark;

  const LocationDetails({
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    this.landmark,
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) =>
      _$LocationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDetailsToJson(this);

  @override
  List<Object?> get props => [
    address,
    city,
    state,
    pincode,
    latitude,
    longitude,
    landmark,
  ];
}

/// PaymentDetails contains payment breakdown, status, and transaction info for a booking.
@JsonSerializable()
class PaymentDetails extends Equatable {
  final double totalAmount;
  final double advanceAmount;
  final double remainingAmount;
  final String currency;
  final PaymentStatus paymentStatus;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final DateTime? paymentDate;
  final List<PaymentTransaction> transactions;

  const PaymentDetails({
    required this.totalAmount,
    required this.advanceAmount,
    required this.remainingAmount,
    this.currency = 'INR',
    required this.paymentStatus,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.paymentDate,
    this.transactions = const [],
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailsToJson(this);

  @override
  List<Object?> get props => [
    totalAmount,
    advanceAmount,
    remainingAmount,
    currency,
    paymentStatus,
    razorpayOrderId,
    razorpayPaymentId,
    paymentDate,
    transactions,
  ];
}

/// PaymentTransaction represents a single payment or refund transaction for a booking.
@JsonSerializable()
class PaymentTransaction extends Equatable {
  final String id;
  final double amount;
  final String type; // 'advance', 'remaining', 'refund'
  final PaymentStatus status;
  final DateTime timestamp;
  final String? razorpayPaymentId;
  final String? notes;

  const PaymentTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
    this.razorpayPaymentId,
    this.notes,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTransactionToJson(this);

  @override
  List<Object?> get props => [
    id,
    amount,
    type,
    status,
    timestamp,
    razorpayPaymentId,
    notes,
  ];
}

/// ReviewModel represents a user review and rating for a booking or service.
@JsonSerializable()
class ReviewModel extends Equatable {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String revieweeId;
  final String revieweeName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> images;

  const ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.revieweeId,
    required this.revieweeName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images = const [],
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    reviewerId,
    reviewerName,
    revieweeId,
    revieweeName,
    rating,
    comment,
    createdAt,
    images,
  ];
}

// Enums
enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('rejected')
  rejected,
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('partial')
  partial,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
}
