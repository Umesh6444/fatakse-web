part of 'booking_bloc.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final dynamic booking;
  BookingSuccess(this.booking);
}

class BookingCancelled extends BookingState {}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
