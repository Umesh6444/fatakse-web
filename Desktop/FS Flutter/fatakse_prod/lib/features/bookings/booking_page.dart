import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/booking_bloc.dart';

class BookingPage extends StatefulWidget {
  @override
  final Key? key;
  const BookingPage({this.key}) : super(key: key);
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BookingLoading) {
            return Center(
              child: CircularProgressIndicator(key: Key('loadingIndicator')),
            );
          }
          if (state is BookingSuccess) {
            return Center(
              child: Text(
                'Booking created!',
                key: Key('successText'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          }
          if (state is BookingCancelled) {
            return Center(
              child: Text(
                'Booking cancelled!',
                key: Key('cancelText'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          if (state is BookingError) {
            return Center(
              child: Text(
                state.message,
                key: Key('errorText'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 360),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        key: Key('detailsField'),
                        controller: _detailsController,
                        decoration: InputDecoration(
                          labelText: 'Booking Details',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        key: Key('createBookingButton'),
                        onPressed: () {
                          context.read<BookingBloc>().add(
                            CreateBooking(_detailsController.text),
                          );
                        },
                        child: Text(
                          'Create Booking',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        key: Key('cancelBookingButton'),
                        onPressed: () {
                          context.read<BookingBloc>().add(
                            CancelBooking('booking1'),
                          );
                        },
                        child: Text(
                          'Cancel Booking',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
