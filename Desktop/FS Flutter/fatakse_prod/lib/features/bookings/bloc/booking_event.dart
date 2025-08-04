part of 'booking_bloc.dart';

abstract class BookingEvent {}

class CreateBooking extends BookingEvent {
  final dynamic booking;
  CreateBooking(this.booking);
}

class CancelBooking extends BookingEvent {
  final String bookingId;
  CancelBooking(this.bookingId);
}
