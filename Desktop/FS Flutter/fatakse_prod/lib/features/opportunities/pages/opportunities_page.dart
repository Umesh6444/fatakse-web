import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

class OpportunitiesPage extends StatefulWidget {
  final UserModel user;

  const OpportunitiesPage({super.key, required this.user});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _opportunities = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _selectedLocation = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOpportunities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOpportunities() async {
    setState(() => _isLoading = true);

    try {
      // Create sample opportunities if none exist
      await _createSampleOpportunities();

      final snapshot = await _firestore
          .collection('opportunities')
          .where('isActive', isEqualTo: true)
          .orderBy('postedAt', descending: true)
          .get();

      setState(() {
        _opportunities = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _opportunities = _getSampleOpportunities();
        _isLoading = false;
      });
    }
  }

  Future<void> _createSampleOpportunities() async {
    try {
      final existingOpportunities = await _firestore
          .collection('opportunities')
          .limit(1)
          .get();

      if (existingOpportunities.docs.isEmpty) {
        final sampleOpportunities = _getSampleOpportunities();

        for (final opportunity in sampleOpportunities) {
          await _firestore.collection('opportunities').add({
            ...opportunity,
            'postedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      debugPrint('Error creating sample opportunities: $e');
    }
  }

  List<Map<String, dynamic>> _getSampleOpportunities() {
    return [
      {
        'title': 'Wedding Dancers Needed for Grand Celebration',
        'type': 'Gig',
        'category': 'Dance',
        'location': 'Mumbai, Maharashtra',
        'budget': '₹25,000 - ₹40,000',
        'duration': '3 days',
        'deadline': 'Dec 20, 2024',
        'clientName': 'The Wedding Company',
        'clientRating': 4.8,
        'description':
            'Looking for experienced classical and folk dancers for a 3-day wedding celebration. Must be comfortable with traditional Indian dance forms.',
        'requirements': [
          '5+ years experience',
          'Traditional costumes',
          'Own transportation',
        ],
        'postedAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 2)),
        ),
        'isActive': true,
        'applicants': 12,
        'isUrgent': false,
        'tags': ['Wedding', 'Classical Dance', 'Folk Dance'],
      },
      {
        'title': 'Corporate Event Performers',
        'type': 'Contract',
        'category': 'Music',
        'location': 'Delhi, NCR',
        'budget': '₹50,000 - ₹75,000',
        'duration': '1 day',
        'deadline': 'Dec 15, 2024',
        'clientName': 'TechCorp Solutions',
        'clientRating': 4.9,
        'description':
            'Seeking talented musicians and performers for annual corporate event. Mix of traditional and contemporary performances required.',
        'requirements': [
          'Professional equipment',
          'Stage experience',
          'Crowd engagement skills',
        ],
        'postedAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 5)),
        ),
        'isActive': true,
        'applicants': 8,
        'isUrgent': true,
        'tags': ['Corporate', 'Music', 'Entertainment'],
      },
      {
        'title': 'Bollywood Choreographer for Film Project',
        'type': 'Project',
        'category': 'Dance',
        'location': 'Mumbai, Maharashtra',
        'budget': '₹2,00,000 - ₹3,50,000',
        'duration': '2 months',
        'deadline': 'Jan 10, 2025',
        'clientName': 'Star Productions',
        'clientRating': 4.7,
        'description':
            'Leading production house seeks experienced Bollywood choreographer for upcoming film. Must have film industry experience.',
        'requirements': [
          'Film industry experience',
          'Portfolio of work',
          'Team management skills',
        ],
        'postedAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        'isActive': true,
        'applicants': 25,
        'isUrgent': false,
        'tags': ['Bollywood', 'Film', 'Choreography'],
      },
      {
        'title': 'Festival Cultural Program Artists',
        'type': 'Gig',
        'category': 'Mixed',
        'location': 'Jaipur, Rajasthan',
        'budget': '₹15,000 - ₹30,000',
        'duration': '5 days',
        'deadline': 'Dec 25, 2024',
        'clientName': 'Rajasthan Tourism',
        'clientRating': 4.6,
        'description':
            'Traditional and folk artists needed for heritage festival. Multiple performance categories available.',
        'requirements': [
          'Traditional skills',
          'Cultural knowledge',
          'Group coordination',
        ],
        'postedAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'isActive': true,
        'applicants': 18,
        'isUrgent': false,
        'tags': ['Festival', 'Traditional', 'Folk'],
      },
      {
        'title': 'Online Content Creator for Dance Tutorials',
        'type': 'Remote',
        'category': 'Dance',
        'location': 'Remote/Work from home',
        'budget': '₹30,000 - ₹50,000',
        'duration': '1 month',
        'deadline': 'Dec 30, 2024',
        'clientName': 'DanceUp Academy',
        'clientRating': 4.5,
        'description':
            'Create engaging dance tutorial content for online platform. Modern and classical dance forms preferred.',
        'requirements': [
          'Video creation skills',
          'Teaching experience',
          'Good internet',
        ],
        'postedAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 3)),
        ),
        'isActive': true,
        'applicants': 15,
        'isUrgent': false,
        'tags': ['Online', 'Tutorials', 'Content Creation'],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Gigs'),
            Tab(text: 'Projects'),
            Tab(text: 'Remote'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildQuickFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOpportunitiesList('All'),
                _buildOpportunitiesList('Gig'),
                _buildOpportunitiesList('Project'),
                _buildOpportunitiesList('Remote'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createOpportunityAlert,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.notification_add),
        label: const Text('Create Alert'),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: AppTheme.surface,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
              ),
              items: ['All', 'Dance', 'Music', 'Mixed', 'Theater'].map((
                category,
              ) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
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
              ),
              items: ['All', 'Mumbai', 'Delhi', 'Bangalore', 'Remote'].map((
                location,
              ) {
                return DropdownMenuItem(value: location, child: Text(location));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunitiesList(String filter) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Map<String, dynamic>> filteredOpportunities = _opportunities;

    if (filter != 'All') {
      filteredOpportunities = _opportunities
          .where((opp) => opp['type'] == filter)
          .toList();
    }

    // Apply category and location filters
    if (_selectedCategory != 'All') {
      filteredOpportunities = filteredOpportunities
          .where((opp) => opp['category'] == _selectedCategory)
          .toList();
    }

    if (_selectedLocation != 'All') {
      filteredOpportunities = filteredOpportunities
          .where(
            (opp) => opp['location'].toString().contains(_selectedLocation),
          )
          .toList();
    }

    if (filteredOpportunities.isEmpty) {
      return _buildEmptyState(filter);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: filteredOpportunities.length,
      itemBuilder: (context, index) {
        final opportunity = filteredOpportunities[index];
        return _buildOpportunityCard(opportunity);
      },
    );
  }

  Widget _buildEmptyState(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, size: 64.w, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No opportunities found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters or check back later',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(Map<String, dynamic> opportunity) {
    final isUrgent = opportunity['isUrgent'] ?? false;
    final applicants = opportunity['applicants'] ?? 0;
    final postedAt = opportunity['postedAt'];

    DateTime timestamp;
    if (postedAt is Timestamp) {
      timestamp = postedAt.toDate();
    } else if (postedAt is DateTime) {
      timestamp = postedAt;
    } else {
      timestamp = DateTime.now();
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isUrgent)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'URGENT',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              opportunity['title'] ?? '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            opportunity['clientName'] ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14.sp,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '${opportunity['clientRating'] ?? 0}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTypeChip(opportunity['type'] ?? 'Gig'),
                    SizedBox(height: 4.h),
                    Text(
                      _formatTimestamp(timestamp),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Description
            Text(
              opportunity['description'] ?? '',
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 12.h),

            // Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        Icons.location_on,
                        opportunity['location'] ?? '',
                      ),
                      SizedBox(height: 4.h),
                      _buildDetailRow(
                        Icons.access_time,
                        opportunity['duration'] ?? '',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        Icons.attach_money,
                        opportunity['budget'] ?? '',
                      ),
                      SizedBox(height: 4.h),
                      _buildDetailRow(
                        Icons.schedule,
                        'Due: ${opportunity['deadline'] ?? ''}',
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Tags
            if (opportunity['tags'] != null)
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: (opportunity['tags'] as List<dynamic>).map((tag) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(
                        (0.1 * 255).toInt(),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      tag.toString(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

            SizedBox(height: 12.h),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$applicants applicants',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _viewOpportunity(opportunity),
                      child: const Text('View Details'),
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: () => _applyToOpportunity(opportunity),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    Color chipColor;
    switch (type) {
      case 'Gig':
        chipColor = Colors.green;
        break;
      case 'Project':
        chipColor = Colors.blue;
        break;
      case 'Contract':
        chipColor = Colors.orange;
        break;
      case 'Remote':
        chipColor = Colors.purple;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: chipColor.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12.sp,
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppTheme.textSecondary),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just posted';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filters',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            const Text('Advanced filtering options will be available here'),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _viewOpportunity(Map<String, dynamic> opportunity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OpportunityDetailPage(opportunity: opportunity, user: widget.user),
      ),
    );
  }

  void _applyToOpportunity(Map<String, dynamic> opportunity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply to Opportunity'),
        content: Text('Apply to "${opportunity['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Application submitted successfully!'),
                ),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _createOpportunityAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Job Alert'),
        content: const Text(
          'Set up notifications for opportunities matching your criteria.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job alert created!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

// Placeholder for opportunity detail page
class OpportunityDetailPage extends StatelessWidget {
  final Map<String, dynamic> opportunity;
  final UserModel user;

  const OpportunityDetailPage({
    super.key,
    required this.opportunity,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(opportunity['title'] ?? 'Opportunity'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity['title'] ?? '',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Text(
              opportunity['description'] ?? '',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            Text(
              'Requirements:',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            if (opportunity['requirements'] != null)
              ...((opportunity['requirements'] as List<dynamic>).map((req) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16.sp,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(child: Text(req.toString())),
                    ],
                  ),
                );
              }).toList()),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Application submitted!')),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
          ),
          child: const Text('Apply Now'),
        ),
      ),
    );
  }
}
