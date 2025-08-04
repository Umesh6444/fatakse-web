import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/payment_bloc.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PaymentLoading) {
            return Center(
              child: CircularProgressIndicator(key: Key('loadingIndicator')),
            );
          }
          if (state is PaymentSuccess) {
            return Center(
              child: Text(
                'Payment successful!',
                key: Key('successText'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          }
          if (state is PaymentError) {
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
                        key: Key('amountField'),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Amount'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        key: Key('payButton'),
                        onPressed: () {
                          final amount =
                              double.tryParse(_amountController.text) ?? 0;
                          context.read<PaymentBloc>().add(
                            InitiatePayment(amount),
                          );
                        },
                        child: Text(
                          'Pay',
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
