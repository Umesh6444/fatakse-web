import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<InitiatePayment>((event, emit) async {
      emit(PaymentLoading());
      try {
        await Future.delayed(Duration(milliseconds: 100));
        emit(PaymentSuccess());
      } catch (e) {
        emit(PaymentError('Payment failed'));
      }
    });
  }
}
