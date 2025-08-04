import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';

/// BookingManagementPage allows clients to manage their event bookings and requests.
///
/// Integrates with Firestore for CRUD operations on bookings.
class BookingManagementPage extends StatefulWidget {
  /// Creates a BookingManagementPage.
  const BookingManagementPage({super.key});

  @override
  State<BookingManagementPage> createState() => _BookingManagementPageState();
}

/// State for [BookingManagementPage]. Handles loading, creating, and updating bookings.
class _BookingManagementPageState extends State<BookingManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  /// Loads the client's bookings from Firestore.
  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('bookings')
            .where('clientId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        setState(() {
          _bookings = querySnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading bookings: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Shows a dialog to create a new booking request.
  Future<void> _createBooking() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _BookingDialog(),
    );

    if (result != null) {
      await _saveBooking(result);
    }
  }

  /// Saves a new booking request to Firestore.
  Future<void> _saveBooking(Map<String, dynamic> booking) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('bookings').add({
          'clientId': user.uid,
          'artistName': booking['artistName'],
          'eventType': booking['eventType'],
          'eventDate': booking['eventDate'],
          'venue': booking['venue'],
          'budget': booking['budget'],
          'status': 'pending',
          'description': booking['description'],
          'createdAt': Timestamp.now(),
        });

        await _loadBookings();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking request sent successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating booking: $e')));
    }
  }

  /// Updates the status of a booking in Firestore.
  Future<void> _updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': Timestamp.now(),
      });

      await _loadBookings();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking $status successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating booking: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Manage your event bookings and requests',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: _bookings.isEmpty
                      ? _buildEmptyState()
                      : _buildBookingsList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: "booking_management_fab",
        onPressed: _createBooking,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Builds the empty state widget when no bookings exist.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64.sp, color: AppTheme.textSecondary),
          SizedBox(height: 16.h),
          Text(
            'No bookings yet',
            style: AppTextStyles.title.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first booking request',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of bookings.
  Widget _buildBookingsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        booking['artistName'] ?? 'Unknown Artist',
                        style: AppTextStyles.title.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          booking['status'],
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        booking['status']?.toUpperCase() ?? 'PENDING',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(booking['status']),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildBookingDetail(
                  Icons.event,
                  'Event Type',
                  booking['eventType'],
                ),
                _buildBookingDetail(
                  Icons.calendar_today,
                  'Event Date',
                  booking['eventDate'],
                ),
                _buildBookingDetail(
                  Icons.location_on,
                  'Venue',
                  booking['venue'],
                ),
                _buildBookingDetail(
                  Icons.currency_rupee,
                  'Budget',
                  '₹${booking['budget']}',
                ),
                if (booking['description'] != null &&
                    booking['description'].isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'Description:',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    booking['description'],
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
                if (booking['status'] == 'pending') ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _updateBookingStatus(booking['id'], 'cancelled'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.errorColor,
                            side: BorderSide(color: AppTheme.errorColor),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.title.copyWith(
                              color: AppTheme.errorColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _updateBookingStatus(booking['id'], 'confirmed'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                          ),
                          child: Text(
                            'Confirm',
                            style: AppTextStyles.title.copyWith(
                              color: AppTheme.successColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a row for a booking detail (icon, label, value).
  Widget _buildBookingDetail(IconData icon, String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: AppTheme.textSecondary),
          SizedBox(width: 8.w),
          Text(
            '$label: ',
            style: AppTextStyles.body.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: AppTextStyles.body.copyWith(
                fontSize: 14.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the color for a booking status.
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      case 'completed':
        return AppTheme.primaryColor;
      default:
        return Colors.orange;
    }
  }
}

/// Dialog for creating a new booking request.
class _BookingDialog extends StatefulWidget {
  @override
  _BookingDialogState createState() => _BookingDialogState();
}

/// State for [_BookingDialog]. Handles form input for booking details.
class _BookingDialogState extends State<_BookingDialog> {
  final _artistNameController = TextEditingController();
  final _venueController = TextEditingController();
  final _budgetController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedEventType = 'Wedding';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _eventTypes = [
    'Wedding',
    'Corporate Event',
    'Birthday Party',
    'Concert',
    'Festival',
    'Private Party',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Booking Request', style: AppTextStyles.headline),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _artistNameController,
              decoration: const InputDecoration(
                labelText: 'Artist/Performer Name',
                hintText: 'Enter artist name',
              ),
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<String>(
              value: _selectedEventType,
              decoration: const InputDecoration(labelText: 'Event Type'),
              items: _eventTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type, style: AppTextStyles.body),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedEventType = value!);
              },
            ),
            SizedBox(height: 16.h),
            ListTile(
              title: const Text('Event Date'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: AppTextStyles.caption,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            TextField(
              controller: _venueController,
              decoration: const InputDecoration(
                labelText: 'Venue',
                hintText: 'Enter event venue',
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Budget (₹)',
                hintText: 'Enter your budget',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Additional details about the event',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppTextStyles.title),
        ),
        ElevatedButton(
          onPressed: () {
            if (_artistNameController.text.isNotEmpty &&
                _venueController.text.isNotEmpty &&
                _budgetController.text.isNotEmpty) {
              Navigator.pop(context, {
                'artistName': _artistNameController.text,
                'eventType': _selectedEventType,
                'eventDate':
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                'venue': _venueController.text,
                'budget': double.tryParse(_budgetController.text) ?? 0,
                'description': _descriptionController.text,
              });
            }
          },
          child: Text('Create', style: AppTextStyles.title),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _artistNameController.dispose();
    _venueController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
