import 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        await Future.delayed(Duration(milliseconds: 100));
        emit(BookingSuccess(event.booking));
      } catch (e) {
        emit(BookingError('Failed to create booking'));
      }
    });
    on<CancelBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        await Future.delayed(Duration(milliseconds: 100));
        emit(BookingCancelled());
      } catch (e) {
        emit(BookingError('Failed to cancel booking'));
      }
    });
  }
}
