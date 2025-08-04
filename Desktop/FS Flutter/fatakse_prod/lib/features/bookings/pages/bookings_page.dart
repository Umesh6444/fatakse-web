import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/extensions/string_extensions.dart';
import 'package:fatakse_prod/config/app_text_styles.dart';
import 'booking_form_page.dart';

/// BookingsPage displays and manages bookings for the current user.
///
/// Shows bookings in tabs by status, supports filtering, and provides actions for accepting, rejecting, and reviewing bookings.
class BookingsPage extends StatefulWidget {
  /// The user whose bookings are displayed and managed.
  final UserModel user;

  const BookingsPage({super.key, required this.user});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

/// State for [BookingsPage]. Handles tab navigation, filtering, and booking actions.
class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  // Filter state
  String? _filterStatus;
  DateTimeRange? _filterDateRange;
  String? _filterType;
  String? _filterProviderOrClient;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getTabCount(), vsync: this);
    // Optionally, load persisted filters here
  }

  @override
  void dispose() {
    _fetchBookings(
      _tabController.index,
    ); // Ensure _fetchBookings is called on init
    _tabController.dispose();
    super.dispose();
  }

  /// Returns the number of tabs based on user role.
  int _getTabCount() {
    // Different tabs for different roles
    switch (widget.user.role) {
      case AppConstants.roleArtist:
      case AppConstants.roleVendor:
        return 4; // Pending, Confirmed, Completed, Cancelled
      default:
        return 4; // All, Pending, Active, History
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle(), style: AppTextStyles.headline),
        backgroundColor: AppTheme.getRoleColor(widget.user.role),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: _buildTabs(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withAlpha((0.7 * 255).toInt()),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_hasActiveFilters()) _buildFilterChips(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          ),
        ],
      ),
      floatingActionButton: _shouldShowFAB()
          ? FloatingActionButton(
              heroTag: "bookings_fab",
              onPressed: () {
                _createNewBooking();
              },
              backgroundColor: AppTheme.getRoleColor(widget.user.role),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  /// Returns true if any filters are active.
  bool _hasActiveFilters() {
    return _filterStatus != null ||
        _filterDateRange != null ||
        _filterType != null ||
        _filterProviderOrClient != null;
  }

  /// Builds filter chips for active filters.
  Widget _buildFilterChips() {
    List<Widget> chips = [];
    if (_filterStatus != null) {
      chips.add(
        _buildChip(
          'Status: ${_filterStatus!}',
          () => setState(() => _filterStatus = null),
        ),
      );
    }
    if (_filterDateRange != null) {
      chips.add(
        _buildChip(
          'Date: ${_filterDateRange!.start.toString().split(' ')[0]} - ${_filterDateRange!.end.toString().split(' ')[0]}',
          () => setState(() => _filterDateRange = null),
        ),
      );
    }
    if (_filterType != null) {
      chips.add(
        _buildChip(
          'Type: ${_filterType!}',
          () => setState(() => _filterType = null),
        ),
      );
    }
    if (_filterProviderOrClient != null) {
      chips.add(
        _buildChip(
          '${_isProviderRole() ? 'Client' : 'Provider'}: ${_filterProviderOrClient!}',
          () => setState(() => _filterProviderOrClient = null),
        ),
      );
    }
    chips.add(_buildChip('Clear All', _clearAllFilters, isClear: true));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(children: chips),
    );
  }

  /// Builds a single filter chip.
  Widget _buildChip(
    String label,
    VoidCallback onDeleted, {
    bool isClear = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Chip(
        label: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isClear ? AppTheme.errorColor : AppTheme.primaryColor,
          ),
        ),
        backgroundColor: isClear
            ? AppTheme.errorColor.withAlpha((0.1 * 255).toInt())
            : AppTheme.primaryColor.withAlpha((0.1 * 255).toInt()),
        deleteIcon: Icon(
          Icons.close,
          size: 16.sp,
          color: isClear ? AppTheme.errorColor : AppTheme.primaryColor,
        ),
        onDeleted: onDeleted,
      ),
    );
  }

  /// Clears all active filters.
  void _clearAllFilters() {
    setState(() {
      _filterStatus = null;
      _filterDateRange = null;
      _filterType = null;
      _filterProviderOrClient = null;
    });
  }

  /// Returns true if the user is a provider (artist or vendor).
  bool _isProviderRole() {
    return widget.user.role == AppConstants.roleArtist ||
        widget.user.role == AppConstants.roleVendor;
  }

  /// Shows the filter bottom sheet for advanced filtering.
  void _showFilterSheet() async {
    String? tempStatus = _filterStatus;
    DateTimeRange? tempDateRange = _filterDateRange;
    String? tempType = _filterType;
    String? tempProviderOrClient = _filterProviderOrClient;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Bookings',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Status
                    DropdownButtonFormField<String>(
                      value: tempStatus,
                      decoration: InputDecoration(labelText: 'Status'),
                      items:
                          [
                                'pending',
                                'confirmed',
                                'completed',
                                'cancelled',
                                'all',
                              ]
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s.capitalize()),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setModalState(
                        () => tempStatus = v == 'all' ? null : v,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Date Range
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Date Range'),
                      subtitle: Text(
                        tempDateRange == null
                            ? 'Any'
                            : '${tempDateRange?.start.toString().split(' ')[0]} - ${tempDateRange?.end.toString().split(' ')[0]}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(now.year - 2),
                          lastDate: DateTime(now.year + 2),
                          initialDateRange: tempDateRange,
                        );
                        if (picked != null) {
                          setModalState(() => tempDateRange = picked);
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Type
                    DropdownButtonFormField<String>(
                      value: tempType,
                      decoration: InputDecoration(labelText: 'Type'),
                      items:
                          [
                                'All',
                                'Wedding',
                                'Corporate',
                                'Birthday',
                                'Festival',
                                'Concert',
                                'Party',
                              ]
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t == 'All' ? null : t,
                                  child: Text(t),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setModalState(() => tempType = v),
                    ),
                    SizedBox(height: 16.h),
                    // Provider/Client
                    TextFormField(
                      initialValue: tempProviderOrClient,
                      decoration: InputDecoration(
                        labelText: _isProviderRole()
                            ? 'Client Name'
                            : 'Provider Name',
                      ),
                      onChanged: (v) => setModalState(
                        () => tempProviderOrClient = v.isEmpty ? null : v,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _filterStatus = tempStatus;
                                _filterDateRange = tempDateRange;
                                _filterType = tempType;
                                _filterProviderOrClient = tempProviderOrClient;
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Returns the page title based on user role.
  String _getPageTitle() {
    switch (widget.user.role) {
      case AppConstants.roleArtist:
        return 'My Bookings';
      case AppConstants.roleVendor:
        return 'Rental Orders';
      case AppConstants.roleEventPlanner:
        return 'Event Projects';
      case AppConstants.roleProductionHouse:
        return 'Productions';
      default:
        return 'My Bookings';
    }
  }

  /// Builds the tab widgets for the TabBar.
  List<Widget> _buildTabs() {
    switch (widget.user.role) {
      case AppConstants.roleArtist:
      case AppConstants.roleVendor:
        return [
          Tab(text: 'Pending'),
          Tab(text: 'Confirmed'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ];
      default:
        return [
          Tab(text: 'All'),
          Tab(text: 'Pending'),
          Tab(text: 'Active'),
          Tab(text: 'History'),
        ];
    }
  }

  /// Builds the tab views for each booking status.
  List<Widget> _buildTabViews() {
    return List.generate(_getTabCount(), (index) => _buildBookingsList(index));
  }

  /// Returns true if the floating action button should be shown for the user role.
  bool _shouldShowFAB() {
    return widget.user.role == AppConstants.roleHouseholdClient ||
        widget.user.role == AppConstants.roleCorporateClient ||
        widget.user.role == AppConstants.roleEventPlanner;
  }

  List<Map<String, dynamic>> _bookings = [];
  bool _isLoadingBookings = false;
  String? _bookingsError;

  /// Fetches bookings from Firestore for the current tab and user.
  Future<void> _fetchBookings(int tabIndex) async {
    setState(() {
      _isLoadingBookings = true;
      _bookingsError = null;
    });
    try {
      final user = widget.user;
      final firestore = FirebaseFirestore.instance;
      Query query = firestore.collection('bookings');
      // Filter by user role
      if (_isProviderRole()) {
        query = query.where('providerId', isEqualTo: user.id);
      } else {
        query = query.where('clientId', isEqualTo: user.id);
      }
      // Optionally filter by status/tab
      final status = _getStatusForTab(tabIndex);
      if (status != 'all' && status != 'bookings') {
        query = query.where('status', isEqualTo: status);
      }
      final snapshot = await query.orderBy('createdAt', descending: true).get();
      setState(() {
        _bookings = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
        _isLoadingBookings = false;
      });
    } catch (e) {
      setState(() {
        _bookingsError = 'Failed to load bookings: $e';
        _isLoadingBookings = false;
      });
    }
  }

  /// Builds the bookings list for a given tab index.
  Widget _buildBookingsList(int tabIndex) {
    if (_isLoadingBookings) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_bookingsError != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.w, color: Colors.red[300]),
              SizedBox(height: 16.h),
              Text(
                'Error loading bookings',
                style: AppTextStyles.title.copyWith(color: Colors.red[600]),
              ),
              SizedBox(height: 8.h),
              Text(
                _bookingsError!,
                style: AppTextStyles.caption.copyWith(color: Colors.red[400]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    if (_bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getEmptyStateIcon(), size: 64.w, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              _getEmptyStateTitle(tabIndex),
              style: AppTextStyles.title.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              _getEmptyStateSubtitle(tabIndex),
              style: AppTextStyles.caption.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    // Show bookings list
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  /// Returns the icon for the empty state based on user role.
  IconData _getEmptyStateIcon() {
    switch (widget.user.role) {
      case AppConstants.roleArtist:
        return Icons.music_note;
      case AppConstants.roleVendor:
        return Icons.inventory;
      case AppConstants.roleEventPlanner:
        return Icons.event_note;
      case AppConstants.roleProductionHouse:
        return Icons.movie;
      default:
        return Icons.event;
    }
  }

  /// Returns the empty state title for a given tab index.
  String _getEmptyStateTitle(int tabIndex) {
    final status = _getStatusForTab(tabIndex);
    switch (widget.user.role) {
      case AppConstants.roleArtist:
        return 'No $status performances';
      case AppConstants.roleVendor:
        return 'No $status orders';
      default:
        return 'No $status bookings';
    }
  }

  /// Returns the empty state subtitle for a given tab index.
  String _getEmptyStateSubtitle(int tabIndex) {
    switch (widget.user.role) {
      case AppConstants.roleArtist:
        return 'Your performance bookings will appear here';
      case AppConstants.roleVendor:
        return 'Equipment rental orders will appear here';
      default:
        return 'Create a new booking to get started';
    }
  }

  /// Returns the booking status for a given tab index and user role.
  String _getStatusForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return widget.user.role == AppConstants.roleArtist ||
                widget.user.role == AppConstants.roleVendor
            ? 'pending'
            : 'bookings';
      case 1:
        return widget.user.role == AppConstants.roleArtist ||
                widget.user.role == AppConstants.roleVendor
            ? 'confirmed'
            : 'pending';
      case 2:
        return widget.user.role == AppConstants.roleArtist ||
                widget.user.role == AppConstants.roleVendor
            ? 'completed'
            : 'active';
      case 3:
        return widget.user.role == AppConstants.roleArtist ||
                widget.user.role == AppConstants.roleVendor
            ? 'cancelled'
            : 'history';
      default:
        return 'all';
    }
  }

  /// Builds a booking card for a single booking.
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] as String;
    final statusColor = _getStatusColor(status);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        booking['title'] ?? '',
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  _getBookingSubtitle(booking),
                  style: AppTextStyles.body.copyWith(
                    color: AppTheme.getRoleColor(widget.user.role),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      booking['date'] ?? '',
                      style: AppTextStyles.caption.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      booking['time'] ?? '',
                      style: AppTextStyles.caption.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        booking['location'] ?? '',
                        style: AppTextStyles.caption.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${booking['amount'] ?? ''}',
                      style: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                if (booking['description'] != null &&
                    (booking['description'] as String).isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    booking['description'],
                    style: AppTextStyles.body.copyWith(
                      color: AppTheme.textPrimary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Action Buttons
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: _buildActionButtons(booking),
          ),
        ],
      ),
    );
  }

  /// Returns the booking subtitle (client or provider name) for a booking.
  String _getBookingSubtitle(Map<String, dynamic> booking) {
    switch (widget.user.role) {
      case AppConstants.roleArtist:
      case AppConstants.roleVendor:
        return 'Client: ${booking['clientName']}';
      default:
        return '₹${booking['amount'] ?? ''}';
    }
  }

  /// Returns the color for a booking status.
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningColor;
      case 'confirmed':
      case 'active':
        return AppTheme.infoColor;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
      case 'rejected':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  /// Builds the action buttons for a booking card based on status and user role.
  Widget _buildActionButtons(Map<String, dynamic> booking) {
    final status = booking['status'] as String;

    switch (status.toLowerCase()) {
      case 'pending':
        if (widget.user.role == AppConstants.roleArtist ||
            widget.user.role == AppConstants.roleVendor) {
          return Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _rejectBooking(booking),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: BorderSide(color: AppTheme.errorColor),
                  ),
                  child: Text(
                    'Reject',
                    style: AppTextStyles.body.copyWith(
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _acceptBooking(booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Accept',
                    style: AppTextStyles.body.copyWith(
                      color: AppTheme.successColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _cancelBooking(booking),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.body.copyWith(
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _viewBookingDetails(booking),
                  child: Text('View Details', style: AppTextStyles.body),
                ),
              ),
            ],
          );
        }

      case 'confirmed':
      case 'active':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _contactUser(booking),
                icon: Icon(Icons.message, size: 16.sp),
                label: Text('Message', style: AppTextStyles.body),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _viewBookingDetails(booking),
                icon: Icon(Icons.visibility, size: 16.sp),
                label: Text('View Details', style: AppTextStyles.body),
              ),
            ),
          ],
        );

      default:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _viewBookingDetails(booking),
                icon: Icon(Icons.visibility, size: 16.sp),
                label: Text('View Details', style: AppTextStyles.body),
              ),
            ),
            if (status.toLowerCase() == 'completed') ...[
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _leaveReview(booking),
                  icon: Icon(Icons.star, size: 16.sp),
                  label: Text('Review', style: AppTextStyles.body),
                ),
              ),
            ],
          ],
        );
    }
  }

  /// Opens the booking form to create a new booking.
  void _createNewBooking() {
    // For demo, pass minimal artist/provider data. In production, show a selection dialog or form.
    final artist = {
      'id': 'demo_artist_id',
      'name': 'Select Artist',
      'category': 'Performer',
      'price': 10000,
      'location': 'Mumbai',
    };
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingFormPage(artist: artist)),
    );
  }

  /// Accepts a booking (demo only).
  void _acceptBooking(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking accepted!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  /// Rejects a booking (demo only).
  void _rejectBooking(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking rejected!'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  /// Cancels a booking (demo only).
  void _cancelBooking(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking cancelled!'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  /// Opens booking details (demo only).
  void _viewBookingDetails(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening booking details...'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  /// Opens chat with the other user (demo only).
  void _contactUser(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat...'),
        backgroundColor: AppTheme.getRoleColor(widget.user.role),
      ),
    );
  }

  /// Opens the review form for a completed booking (demo only).
  void _leaveReview(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening review form...'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }
}
