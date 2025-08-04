import 'package:flutter/material.dart';
import 'package:fatakse_prod/core/services/saved_jobs_service.dart';
import '../../../config/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';
import '../../../core/services/booking_service_interface.dart';
import '../../../get_it.dart';

class JobSearchWidget extends StatefulWidget {
  final UserModel user;
  final SavedJobsService? savedJobsService;

  const JobSearchWidget({super.key, required this.user, this.savedJobsService});

  @override
  State<JobSearchWidget> createState() => _JobSearchWidgetState();
}

class _JobSearchWidgetState extends State<JobSearchWidget> {
  late final IBookingService _bookingService;
  late final SavedJobsService _savedJobsService;
  final TextEditingController _searchController = TextEditingController();
  String _selectedEventType = 'All';
  Set<String> _savedJobIds = {};
  bool _isSavingJob = false;
  String _selectedLocation = 'All Locations';
  List<Map<String, dynamic>> _filteredJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _bookingService = getIt<IBookingService>();
    _savedJobsService = widget.savedJobsService ?? SavedJobsService();
    _listenSavedJobs();
    _loadJobs();
  }

  void _listenSavedJobs() {
    final userId = widget.user.id;
    _savedJobsService.savedJobIdsStream(userId).listen((ids) {
      setState(() {
        _savedJobIds = ids.toSet();
      });
    });
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await _bookingService.getJobOpportunities();
      setState(() {
        _filteredJobs = jobs;
        _isLoading = false;
      });
      _filterJobs();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load jobs: $e')));
      }
    }
  }

  void _filterJobs() async {
    // Reload jobs first if needed
    final jobs = await _bookingService.getJobOpportunities();
    List<Map<String, dynamic>> filtered = jobs;

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((job) {
        final query = _searchController.text.toLowerCase();
        return job['title'].toString().toLowerCase().contains(query) ||
            job['description'].toString().toLowerCase().contains(query) ||
            job['clientName'].toString().toLowerCase().contains(query);
      }).toList();
    }

    // Filter by event type
    if (_selectedEventType != 'All') {
      filtered = filtered.where((job) {
        return job['eventType'].toString() == _selectedEventType;
      }).toList();
    }

    // Filter by location
    if (_selectedLocation != 'All Locations') {
      filtered = filtered.where((job) {
        return job['location'].toString().contains(_selectedLocation);
      }).toList();
    }

    setState(() {
      _filteredJobs = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Header
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _filterJobs(),
                  decoration: InputDecoration(
                    hintText: 'Search job opportunities...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Quick Filters
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedEventType,
                      decoration: InputDecoration(
                        labelText: 'Event Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
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
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEventType = value!;
                        });
                        _filterJobs();
                      },
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      items:
                          [
                                'All Locations',
                                'Mumbai',
                                'Delhi',
                                'Bangalore',
                                'Chennai',
                                'Kolkata',
                                'Hyderabad',
                                'Pune',
                              ]
                              .map(
                                (location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value!;
                        });
                        _filterJobs();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Jobs List
        Expanded(child: _buildJobsList()),
      ],
    );
  }

  Widget _buildJobsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_off, size: 64.w, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'No jobs found',
              style: AppTextStyles.title.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your search filters',
              style: AppTextStyles.body.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _filteredJobs.length,
      itemBuilder: (context, index) {
        final job = _filteredJobs[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final urgency = job['urgency'] as String;
    final urgencyColor = urgency == 'Urgent'
        ? AppTheme.errorColor
        : urgency == 'This Week'
        ? AppTheme.warningColor
        : AppTheme.successColor;

    // Handle eventDate as Timestamp or DateTime
    String eventDateStr = '';
    final eventDateRaw = job['eventDate'];
    if (eventDateRaw != null) {
      DateTime? eventDate;
      if (eventDateRaw is DateTime) {
        eventDate = eventDateRaw;
      } else if (eventDateRaw is String) {
        eventDate = DateTime.tryParse(eventDateRaw);
      } else if (eventDateRaw is Map && eventDateRaw.containsKey('_seconds')) {
        // Firestore Timestamp serialized as map
        eventDate = DateTime.fromMillisecondsSinceEpoch(
          eventDateRaw['_seconds'] * 1000,
        );
      } else if (eventDateRaw.runtimeType.toString() == 'Timestamp') {
        // If running in an environment with Timestamp type
        try {
          eventDate = (eventDateRaw as dynamic).toDate();
        } catch (_) {}
      }
      if (eventDate != null) {
        eventDateStr = '${eventDate.day}/${eventDate.month}/${eventDate.year}';
      }
    }

    final userId = widget.user.id;
    final jobId = job['id'] ?? '';
    final isSaved = _savedJobIds.contains(jobId);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        job['title'],
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: urgencyColor.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        urgency,
                        style: AppTextStyles.caption.copyWith(
                          color: urgencyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                Text(
                  'Posted by: ${job['clientName']}',
                  style: AppTextStyles.body.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4.h),

                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      job['eventType'],
                      style: AppTextStyles.caption.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.calendar_today,
                      size: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      eventDateStr,
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
                    Text(
                      job['location'],
                      style: AppTextStyles.caption.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '₹${job['budget']}',
                      style: AppTextStyles.headline.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                Text(
                  job['description'],
                  style: AppTextStyles.body.copyWith(
                    color: AppTheme.textPrimary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12.h),

                // Requirements Tags
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: (job['requirements'] as List<String>)
                      .map(
                        (requirement) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withAlpha(
                              (0.8 * 255).toInt(),
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            requirement,
                            style: AppTextStyles.caption.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
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
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSavingJob
                        ? null
                        : () async {
                            setState(() {
                              _isSavingJob = true;
                            });
                            try {
                              if (isSaved) {
                                await _savedJobsService.unsaveJob(
                                  userId,
                                  jobId,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Job removed from saved'),
                                    backgroundColor: AppTheme.primaryColor,
                                  ),
                                );
                              } else {
                                await _savedJobsService.saveJob(
                                  userId,
                                  jobId,
                                  job,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Job saved'),
                                    backgroundColor: AppTheme.primaryColor,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to update saved jobs: $e',
                                  ),
                                  backgroundColor: AppTheme.errorColor,
                                ),
                              );
                            } finally {
                              setState(() {
                                _isSavingJob = false;
                              });
                            }
                          },
                    icon: isSaved
                        ? Icon(Icons.bookmark, size: 16.sp)
                        : Icon(Icons.bookmark_border, size: 16.sp),
                    label: Text(isSaved ? 'Saved' : 'Save'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showApplicationDialog(job);
                    },
                    icon: Icon(Icons.send, size: 16.sp),
                    label: Text('Apply Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicationDialog(Map<String, dynamic> job) {
    final TextEditingController messageController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Apply for Job'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job: ${job['title']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text('Budget: ₹${job['budget']}'),
                SizedBox(height: 8.h),
                Text('Client: ${job['clientName']}'),
                SizedBox(height: 16.h),

                // Message field
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Your Proposal Message',
                    hintText: 'Describe your experience and approach...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.h),

                // Rate field
                TextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Your Rate (₹)',
                    hintText: 'Enter your proposed rate',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                ),
                SizedBox(height: 16.h),

                // Date picker
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Preferred Start Date'),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (messageController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a proposal message'),
                    ),
                  );
                  return;
                }

                if (rateController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your rate')),
                  );
                  return;
                }

                try {
                  Navigator.pop(context);

                  // Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  final rate = double.tryParse(rateController.text.trim()) ?? 0;

                  await _bookingService.createBookingRequest(
                    jobId: job['id'] ?? '',
                    clientId: job['clientId'] ?? 'client_1',
                    clientName: job['clientName'] ?? 'Unknown Client',
                    artistId: widget.user.id,
                    artistName: widget.user.displayName,
                    message: messageController.text.trim(),
                    proposedDate: selectedDate,
                    proposedRate: rate,
                    eventTitle: job['title'] ?? 'Job Application',
                    location: job['location'] ?? 'Location TBD',
                  );

                  Navigator.pop(context); // Close loading

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Application submitted successfully!'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context); // Close loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to submit application: $e'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }
}
