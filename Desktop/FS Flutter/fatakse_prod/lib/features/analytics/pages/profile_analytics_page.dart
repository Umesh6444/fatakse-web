import 'package:flutter/material.dart';
import '../../../config/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

/// ProfileAnalyticsPage displays analytics and statistics for a user's profile.
///
/// Shows overview cards, booking stats, engagement metrics, and profile view trends.
class ProfileAnalyticsPage extends StatefulWidget {
  /// The user whose analytics are displayed.
  final UserModel user;

  const ProfileAnalyticsPage({super.key, required this.user});

  @override
  State<ProfileAnalyticsPage> createState() => _ProfileAnalyticsPageState();
}

/// State for [ProfileAnalyticsPage]. Handles loading and displaying analytics data.
class _ProfileAnalyticsPageState extends State<ProfileAnalyticsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> _analytics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  /// Loads analytics data from Firestore for the current user.
  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    try {
      final doc = await _firestore
          .collection('user_analytics')
          .doc(widget.user.id)
          .get();
      setState(() {
        _analytics = doc.data() ?? {};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _analytics = {};
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile Analytics',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCards(),
                  SizedBox(height: 24.h),
                  _buildProfileViewsChart(),
                  SizedBox(height: 24.h),
                  _buildBookingStats(),
                  SizedBox(height: 24.h),
                  _buildEngagementMetrics(),
                ],
              ),
            ),
    );
  }

  /// Builds the overview cards for profile views, bookings, revenue, and rating.
  Widget _buildOverviewCards() {
    final profileViews = _analytics['profileViews'] ?? {};
    final bookings = _analytics['bookings'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTextStyles.headline.copyWith(color: AppTheme.textPrimary),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Profile Views',
                '${profileViews['total'] ?? 0}',
                '+${profileViews['growth']?.toStringAsFixed(1) ?? 0}%',
                Icons.visibility,
                Colors.blue,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'Total Bookings',
                '${bookings['total'] ?? 0}',
                '${bookings['completed'] ?? 0} completed',
                Icons.event,
                Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Revenue',
                '₹${_formatNumber(bookings['revenue'] ?? 0)}',
                'This month',
                Icons.currency_rupee,
                Colors.orange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'Rating',
                '${bookings['averageRating'] ?? 0}',
                '⭐ Average',
                Icons.star,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a single stat card for the overview section.
  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withAlpha((0.2 * 255).toInt())),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.sp),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: color),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: AppTextStyles.headline.copyWith(color: AppTheme.textPrimary),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the profile views trend chart section.
  Widget _buildProfileViewsChart() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.primaryColor.withAlpha((0.2 * 255).toInt()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Views Trend',
            style: AppTextStyles.title.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 150.h,
            child: Center(
              child: Text(
                'Chart visualization would go here\n(Views over last 7 days)',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the booking statistics section.
  Widget _buildBookingStats() {
    final bookings = _analytics['bookings'] ?? {};

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.primaryColor.withAlpha((0.2 * 255).toInt()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Statistics',
            style: AppTextStyles.title.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBookingStat(
                'Completed',
                '${bookings['completed'] ?? 0}',
                Colors.green,
              ),
              _buildBookingStat(
                'Pending',
                '${bookings['pending'] ?? 0}',
                Colors.orange,
              ),
              _buildBookingStat(
                'Rating',
                '${bookings['averageRating'] ?? 0}★',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a single booking stat for the booking statistics section.
  Widget _buildBookingStat(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).toInt()),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  /// Builds the engagement metrics section.
  Widget _buildEngagementMetrics() {
    final engagement = _analytics['engagement'] ?? {};

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.primaryColor.withAlpha((0.2 * 255).toInt()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Engagement Metrics',
            style: AppTextStyles.title.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildEngagementRow(
            'Inquiries Received',
            '${engagement['inquiries'] ?? 0}',
          ),
          _buildEngagementRow(
            'Response Rate',
            '${engagement['responseRate'] ?? 0}%',
          ),
          _buildEngagementRow(
            'Avg. Response Time',
            '${engagement['averageResponseTime'] ?? 'N/A'}',
          ),
        ],
      ),
    );
  }

  /// Builds a single engagement metric row.
  Widget _buildEngagementRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: AppTheme.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats large numbers for display (e.g., 1.2K, 3.4L).
  String _formatNumber(int number) {
    if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
