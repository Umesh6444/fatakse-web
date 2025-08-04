import 'package:fatakse_prod/features/booking/domain/entities/booking.dart';

class BookingRepository {
  Future<Booking> createBooking(Booking booking) async {
    // Simulate booking creation
    await Future.delayed(Duration(milliseconds: 100));
    return booking;
  }

  Future<List<Booking>> fetchBookings() async {
    // Simulate fetching bookings
    await Future.delayed(Duration(milliseconds: 100));
    return [];
  }
}
