abstract class IBookingService {
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
  });
  Future<List<Map<String, dynamic>>> getJobOpportunities({
    String? location,

    /// Abstract interface for booking-related operations.
    ///
    /// Implement this interface to provide booking creation, retrieval, and management logic.
    double? minBudget,
    double? maxBudget,
  });
  // Add other methods as needed
}
