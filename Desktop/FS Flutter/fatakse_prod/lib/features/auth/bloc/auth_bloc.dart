import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await Future.delayed(Duration(milliseconds: 100));
        emit(Authenticated({'email': event.email}));
      } catch (e) {
        emit(AuthError('Failed to sign in'));
      }
    });
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await Future.delayed(Duration(milliseconds: 50));
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError('Failed to sign out'));
      }
    });
  }
}
