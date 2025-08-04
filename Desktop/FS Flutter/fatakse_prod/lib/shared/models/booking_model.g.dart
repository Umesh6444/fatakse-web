// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerType: json['providerType'] as String,
      eventTitle: json['eventTitle'] as String,
      eventDescription: json['eventDescription'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      eventStartTime: DateTime.parse(json['eventStartTime'] as String),
      eventEndTime: DateTime.parse(json['eventEndTime'] as String),
      eventLocation: LocationDetails.fromJson(
          json['eventLocation'] as Map<String, dynamic>),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      paymentDetails: PaymentDetails.fromJson(
          json['paymentDetails'] as Map<String, dynamic>),
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      specialInstructions: json['specialInstructions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      review: json['review'] == null
          ? null
          : ReviewModel.fromJson(json['review'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'providerType': instance.providerType,
      'eventTitle': instance.eventTitle,
      'eventDescription': instance.eventDescription,
      'eventDate': instance.eventDate.toIso8601String(),
      'eventStartTime': instance.eventStartTime.toIso8601String(),
      'eventEndTime': instance.eventEndTime.toIso8601String(),
      'eventLocation': instance.eventLocation,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'paymentDetails': instance.paymentDetails,
      'requirements': instance.requirements,
      'specialInstructions': instance.specialInstructions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'attachments': instance.attachments,
      'review': instance.review,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.inProgress: 'in_progress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.rejected: 'rejected',
};

LocationDetails _$LocationDetailsFromJson(Map<String, dynamic> json) =>
    LocationDetails(
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      landmark: json['landmark'] as String?,
    );

Map<String, dynamic> _$LocationDetailsToJson(LocationDetails instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'landmark': instance.landmark,
    };

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      advanceAmount: (json['advanceAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      razorpayOrderId: json['razorpayOrderId'] as String?,
      razorpayPaymentId: json['razorpayPaymentId'] as String?,
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map(
                  (e) => PaymentTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'totalAmount': instance.totalAmount,
      'advanceAmount': instance.advanceAmount,
      'remainingAmount': instance.remainingAmount,
      'currency': instance.currency,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'razorpayOrderId': instance.razorpayOrderId,
      'razorpayPaymentId': instance.razorpayPaymentId,
      'paymentDate': instance.paymentDate?.toIso8601String(),
      'transactions': instance.transactions,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.partial: 'partial',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};

PaymentTransaction _$PaymentTransactionFromJson(Map<String, dynamic> json) =>
    PaymentTransaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      razorpayPaymentId: json['razorpayPaymentId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PaymentTransactionToJson(PaymentTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'razorpayPaymentId': instance.razorpayPaymentId,
      'notes': instance.notes,
    };

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      id: json['id'] as String,
      reviewerId: json['reviewerId'] as String,
      reviewerName: json['reviewerName'] as String,
      revieweeId: json['revieweeId'] as String,
      revieweeName: json['revieweeName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewerId': instance.reviewerId,
      'reviewerName': instance.reviewerName,
      'revieweeId': instance.revieweeId,
      'revieweeName': instance.revieweeName,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'images': instance.images,
    };
