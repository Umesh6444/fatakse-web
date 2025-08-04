import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_service_interface.dart';
import 'package:flutter/foundation.dart';
import '../../shared/models/booking_model.dart';

class BookingService implements IBookingService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  BookingService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  // Create a new booking request
  @override
  Future<String> createBookingRequest({
    required String jobId,
    required String clientId,
    required String clientName,
    required String artistId,
    required String artistName,
    required String message,
    required DateTime proposedDate,
    required double proposedRate,
    required String eventTitle,
    required String location,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      /// Create a new booking request.
      ///
      /// [jobId]: The job or event identifier.
      /// [clientId]: The client user ID.
      /// [clientName]: The client's display name.
      /// [artistId]: The artist user ID.
      /// [artistName]: The artist's display name.
      /// [message]: Message or event description.
      /// [proposedDate]: Proposed date for the event.
      /// [proposedRate]: Proposed payment amount.
      /// [eventTitle]: Title of the event.
      /// [location]: Event location (address).
      ///
      /// Returns the Firestore document ID for the created booking.
      final booking = BookingModel(
        id: '',
        clientId: clientId,
        clientName: clientName,
        providerId: artistId,
        providerName: artistName,
        providerType: 'artist',
        eventTitle: eventTitle,
        eventDescription: message,
        eventDate: proposedDate,
        eventStartTime: proposedDate,
        eventEndTime: proposedDate.add(const Duration(hours: 4)),
        eventLocation: LocationDetails(
          address: location,
          city: location.split(',').first.trim(),
          state: location.split(',').length > 1
              ? location.split(',').last.trim()
              : '',
          pincode: '000000',
        ),
        status: BookingStatus.pending,
        paymentDetails: PaymentDetails(
          totalAmount: proposedRate,
          advanceAmount: proposedRate * 0.3,
          remainingAmount: proposedRate * 0.7,
          paymentStatus: PaymentStatus.pending,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        requirements: [],
      );

      final docRef = await _firestore
          .collection('bookings')
          .add(booking.toJson());

      // Send notification to client
      await _sendBookingNotification(
        clientId: clientId,
        artistId: artistId,
        bookingId: docRef.id,
        type: 'new_application',
      );

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create booking request: $e');
    }
  }

  // Get jobs/opportunities
  @override
  Future<List<Map<String, dynamic>>> getJobOpportunities({
    String? location,
    String? eventType,
    double? minBudget,
    double? maxBudget,
  }) async {
    try {
      Query query = _firestore.collection('job_postings');

      if (location != null && location.isNotEmpty) {
        query = query.where('location', isEqualTo: location);
      }

      if (eventType != null && eventType.isNotEmpty) {
        query = query.where('eventType', isEqualTo: eventType);
      }

      if (minBudget != null) {
        query = query.where('budget', isGreaterThanOrEqualTo: minBudget);
      }

      if (maxBudget != null) {
        query = query.where('budget', isLessThanOrEqualTo: maxBudget);
      }

      final snapshot = await query.orderBy('createdAt', descending: true).get();

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
      rethrow;
    }
  }

  // Removed _seedJobData and all mock job seeding logic

  // Send notification for booking events
  Future<void> _sendBookingNotification({
    required String clientId,
    required String artistId,
    required String bookingId,
    required String type,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'recipientId': clientId,
        'senderId': artistId,
        'bookingId': bookingId,
        'type': type,
        'title': 'New Job Application',
        'message': 'An artist has applied for your job posting',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Failed to send notification: $e');
    }
  }

  // Removed _getMockJobs and all mock job data
}
