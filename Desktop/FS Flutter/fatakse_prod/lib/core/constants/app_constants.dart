// Core constants for the Fatakse application
class AppConstants {
  // App Information
  static const String appName = 'Fatakse';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'The backstage platform powering the show';

  // User Roles
  static const String roleArtist = 'artist';
  static const String roleHouseholdClient = 'household_client';
  static const String roleCorporateClient = 'corporate_client';
  static const String roleVendor = 'vendor';
  static const String roleEventPlanner = 'event_planner';
  static const String roleProductionHouse = 'production_house';
  static const String roleAdmin = 'admin';

  // Artist Categories
  static const List<String> artistCategories = [
    'Singer',
    'Dancer',
    'DJ',
    'Band',
    'Comedian',
    'Magician',
    'Anchor/Host',
    'Musician',
    'Actor',
    'Photographer',
    'Videographer',
    'Makeup Artist',
    'Mehendi Artist',
    'Decorative Artist',
    'Sound Engineer',
    'Lighting Technician',
  ];

  // Vendor Categories
  static const List<String> vendorCategories = [
    'Sound Equipment',
    'Lighting Equipment',
    'Photography Equipment',
    'Video Equipment',
    'Stage & Backdrop',
    'Seating & Furniture',
    'Catering Equipment',
    'Transportation',
    'Generator & Power',
    'Decoration Items',
    'Costumes & Props',
    'Musical Instruments',
  ];

  // Event Types
  static const List<String> eventTypes = [
    'Wedding',
    'Birthday Party',
    'Corporate Event',
    'Concert',
    'Festival',
    'Product Launch',
    'Conference',
    'Workshop',
    'Cultural Event',
    'Religious Event',
    'Film/TV Production',
    'Advertisement Shoot',
    'Music Video',
    'Documentary',
  ];

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String bookingsCollection = 'bookings';
  static const String vendorsCollection = 'vendors';
  static const String messagesCollection = 'messages';
  static const String eventsCollection = 'events';
  static const String reviewsCollection = 'reviews';
  static const String categoriesCollection = 'categories';
  static const String notificationsCollection = 'notifications';

  // Booking Status
  static const String bookingPending = 'pending';
  static const String bookingConfirmed = 'confirmed';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';
  static const String bookingRejected = 'rejected';

  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentCompleted = 'completed';
  static const String paymentFailed = 'failed';
  static const String paymentRefunded = 'refunded';

  // Commission Rates
  static const double artistCommissionRate = 0.12; // 12%
  static const double vendorCommissionRate = 0.08; // 8%
  static const double eventPlannerCommissionRate = 0.15; // 15%

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxBioLength = 500;
  static const int maxDescriptionLength = 1000;
  static const int minAge = 16;
  static const int maxAge = 80;

  // File Upload
  static const int maxImageSizeMB = 5;
  static const int maxVideoSizeMB = 50;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];

  // Location
  static const double defaultLatitude = 28.6139; // Delhi
  static const double defaultLongitude = 77.2090;
  static const double searchRadiusKm = 50.0;

  // API Endpoints
  static const String razorpayKeyId =
      'rzp_test_your_key_here'; // Replace with actual key
  static const String razorpayKeySecret =
      'your_secret_here'; // Replace with actual secret

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String unknownError = 'Something went wrong. Please try again.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String permissionError =
      'Permission denied. Please check your permissions.';
}
