import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_theme.dart';
import '../../../core/services/booking_service_interface.dart';
import '../../../shared/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../../get_it.dart';
import '../../../config/app_text_styles.dart';

class BookingFormPage extends StatefulWidget {
  final Map<String, dynamic> artist;
  const BookingFormPage({super.key, required this.artist});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _dateController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      // Get current user from AuthBloc
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        throw Exception('You must be signed in to book an artist.');
      }
      final UserModel user = authState.user;

      // Prepare booking data
      final artist = widget.artist;
      final artistId = artist['id'] ?? artist['artistId'] ?? '';
      final artistName = artist['name'] ?? artist['artistName'] ?? '';
      final price = (artist['price'] is num)
          ? (artist['price'] as num).toDouble()
          : double.tryParse(artist['price']?.toString() ?? '') ?? 0.0;
      final eventTitle = 'Booking with $artistName';
      final location = artist['location'] ?? '';
      final message = _detailsController.text.trim();
      final proposedDate = _selectedDate!;

      final IBookingService bookingService = getIt<IBookingService>();
      await bookingService.createBookingRequest(
        jobId: '',
        clientId: user.id,
        clientName: user.displayName,
        artistId: artistId,
        artistName: artistName,
        message: message,
        proposedDate: proposedDate,
        proposedRate: price,
        eventTitle: eventTitle,
        location: location,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking request submitted!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit booking: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book ${widget.artist['name'] ?? 'Artist'}',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Category: ${widget.artist['category'] ?? ''}',
                style: AppTextStyles.body,
              ),
              SizedBox(height: 12.h),
              Text(
                'Price: \u20b9${widget.artist['price'] ?? ''}',
                style: AppTextStyles.body,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Event Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                style: AppTextStyles.body,
                onTap: _pickDate,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select a date' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Event Details',
                  prefixIcon: Icon(Icons.description),
                ),
                style: AppTextStyles.body,
                minLines: 2,
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter event details'
                    : null,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Submit Booking',
                        style: AppTextStyles.title.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
