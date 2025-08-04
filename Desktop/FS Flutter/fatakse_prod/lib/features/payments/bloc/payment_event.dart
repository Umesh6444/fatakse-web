part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class InitiatePayment extends PaymentEvent {
  final double amount;
  InitiatePayment(this.amount);
}

class PaymentCompleted extends PaymentEvent {}
