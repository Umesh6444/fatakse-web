import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  const SendMessage(this.message);
  @override
  List<Object?> get props => [message];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<String> messages;
  const ChatLoaded(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String error;
  const ChatError(this.error);
  @override
  List<Object?> get props => [error];
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<String> _messages = [];
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>((event, emit) async {
      emit(ChatLoading());
      try {
        await Future.delayed(const Duration(milliseconds: 100));
        _messages.add(event.message);
        emit(ChatLoaded(List.from(_messages)));
      } catch (e) {
        emit(ChatError('Failed to send message'));
      }
    });
  }
}
