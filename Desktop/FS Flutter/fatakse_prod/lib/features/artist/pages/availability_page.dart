import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../config/theme/app_theme.dart';
import 'package:fatakse_prod/config/app_text_styles.dart';

/// AvailabilityPage allows artists to manage their available time slots for bookings.
///
/// Integrates with Firestore to save and load availability data.

class AvailabilityPage extends StatefulWidget {
  /// Creates an AvailabilityPage.
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  AvailabilityPage({Key? key, FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance,
      super(key: key);

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

/// State for [AvailabilityPage]. Handles loading, saving, and editing availability slots.
class _AvailabilityPageState extends State<AvailabilityPage> {
  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;

  bool _isLoading = false;
  List<Map<String, dynamic>> _availabilitySlots = [];

  @override
  void initState() {
    super.initState();
    _firestore = widget.firestore;
    _auth = widget.auth;
    _loadAvailability();
  }

  /// Loads the user's availability slots from Firestore.
  Future<void> _loadAvailability() async {
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('availability')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _availabilitySlots = List<Map<String, dynamic>>.from(
              doc.data()?['slots'] ?? [],
            );
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading availability: $e',
            style: AppTextStyles.caption.copyWith(color: Colors.red),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Shows a dialog to add a new availability slot.
  Future<void> _addAvailabilitySlot() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AvailabilityDialog(),
    );

    if (result != null) {
      setState(() {
        _availabilitySlots.add(result);
      });
      await _saveAvailability();
    }
  }

  /// Saves the current availability slots to Firestore.
  Future<void> _saveAvailability() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('availability').doc(user.uid).set({
          'slots': _availabilitySlots,
          'updatedAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Availability saved successfully!',
              style: AppTextStyles.caption.copyWith(color: Colors.green),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving availability: $e',
            style: AppTextStyles.caption.copyWith(color: Colors.red),
          ),
        ),
      );
    }
  }

  /// Removes an availability slot at the given index and saves changes.
  void _removeSlot(int index) {
    setState(() {
      _availabilitySlots.removeAt(index);
    });
    _saveAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Manage Availability', style: AppTextStyles.headline),
        backgroundColor: AppTheme.artistColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Set your available time slots for bookings',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: _availabilitySlots.isEmpty
                      ? _buildEmptyState()
                      : _buildAvailabilityList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: "availability_fab",
        onPressed: _addAvailabilitySlot,
        backgroundColor: AppTheme.artistColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Builds the empty state widget when no slots are set.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64.sp,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No availability slots set',
            style: AppTextStyles.title.copyWith(color: AppTheme.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your available time slots to start receiving bookings',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of availability slots.
  Widget _buildAvailabilityList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _availabilitySlots.length,
      itemBuilder: (context, index) {
        final slot = _availabilitySlots[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.artistColor.withValues(alpha: 0.1),
              child: Icon(Icons.access_time, color: AppTheme.artistColor),
            ),
            title: Text('${slot['dayOfWeek']}', style: AppTextStyles.title),
            subtitle: Text(
              '${slot['startTime']} - ${slot['endTime']}',
              style: AppTextStyles.caption.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: AppTheme.errorColor),
              onPressed: () => _removeSlot(index),
            ),
          ),
        );
      },
    );
  }
}

/// Dialog for adding a new availability slot.
class _AvailabilityDialog extends StatefulWidget {
  @override
  _AvailabilityDialogState createState() => _AvailabilityDialogState();
}

/// State for [_AvailabilityDialog]. Handles form input for slot details.
class _AvailabilityDialogState extends State<_AvailabilityDialog> {
  String _selectedDay = 'Monday';
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Availability Slot', style: AppTextStyles.headline),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedDay,
            decoration: const InputDecoration(labelText: 'Day of Week'),
            items: _daysOfWeek.map((day) {
              return DropdownMenuItem(
                value: day,
                child: Text(day, style: AppTextStyles.body),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedDay = value!);
            },
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Start Time', style: AppTextStyles.body),
                  subtitle: Text(
                    _startTime.format(context),
                    style: AppTextStyles.caption,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _startTime,
                    );
                    if (time != null) {
                      setState(() => _startTime = time);
                    }
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('End Time', style: AppTextStyles.body),
                  subtitle: Text(
                    _endTime.format(context),
                    style: AppTextStyles.caption,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _endTime,
                    );
                    if (time != null) {
                      setState(() => _endTime = time);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppTextStyles.body),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'dayOfWeek': _selectedDay,
              'startTime': _startTime.format(context),
              'endTime': _endTime.format(context),
            });
          },
          child: Text('Add', style: AppTextStyles.title),
        ),
      ],
    );
  }
}
