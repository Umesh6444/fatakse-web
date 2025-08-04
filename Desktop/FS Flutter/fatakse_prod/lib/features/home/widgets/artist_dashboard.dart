import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/widgets/accessible_widgets.dart';
import '../../../config/app_text_styles.dart';

import '../../../core/services/performance_optimization_service.dart';
import '../../ai_tools/ai_tools_menu_page.dart';
import '../../../core/services/openai_service.dart';

import '../../artist/pages/availability_page.dart';
import '../../artist/pages/portfolio_page.dart';
import '../../artist/pages/pricing_page.dart';
import '../../bookings/pages/bookings_page.dart';
import '../../notifications/pages/notifications_page.dart';
import '../../messaging/pages/message_center_page.dart';
import '../../analytics/pages/profile_analytics_page.dart';
import '../../opportunities/pages/opportunities_page.dart';
import '../../community/pages/community_feed_tab.dart';

class ArtistDashboard extends StatefulWidget {
  final UserModel user;
  const ArtistDashboard({super.key, required this.user});

  @override
  State<ArtistDashboard> createState() => _ArtistDashboardState();
}

class _ArtistDashboardState extends State<ArtistDashboard> {
  late final PageController _pageController;
  int _pageIndex = 1; // 0: Community, 1: Dashboard, 2: Portfolio (optional)

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final performanceService = PerformanceService();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Semantics(
          label: 'Artist dashboard for ${widget.user.firstName}',
          child: Text('Welcome ${widget.user.firstName}'),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          AccessibleButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(user: widget.user),
                ),
              );
            },
            semanticLabel: 'Notifications',
            semanticHint: 'View your notifications',
            child: Icon(Icons.notifications, color: Colors.white, size: 24.sp),
          ),
          IconButton(
            icon: const Icon(Icons.smart_toy),
            tooltip: 'AI Tools',
            onPressed: () {
              final openAIService = OpenAIService(
                apiKey:
                    "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",
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AIToolsMenuPage(
                    openAIService: openAIService,
                    userRole: widget.user.role,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _pageIndex = i),
        children: [
          // Left: Community Feed
          const CommunityFeedTab(),
          // Center: Dashboard
          performanceService.createOptimizedListView(
            itemCount: 1,
            itemBuilder: (context, index) => SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCompletionCard(context),
                  SizedBox(height: 16.h),
                  _buildQuickStats(),
                  SizedBox(height: 16.h),
                  _buildActionCards(context),
                  SizedBox(height: 16.h),
                  _buildRecentActivity(),
                  SizedBox(height: 16.h),
                  _buildUpcomingBookings(context),
                ],
              ),
            ),
          ),
          // Right: Portfolio (optional, can add more tabs)
          PortfolioPage(),
        ],
      ),
      floatingActionButton: _pageIndex == 1
          ? AccessibleButton(
              onPressed: () {
                _showAddServiceDialog(context);
              },
              semanticLabel: 'Add new service',
              semanticHint: 'Create a new service or update availability',
              isPrimary: true,
              child: Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
    );
  }

  Widget _buildProfileCompletionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle,
                color: AppTheme.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Complete Your Profile',
                style: AppTextStyles.title.copyWith(
                  color: AppTheme.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Text(
            'Add your portfolio, skills, and availability to get more bookings',
            style: AppTextStyles.body.copyWith(
              color: AppTheme.textSecondaryDark,
            ),
          ),

          SizedBox(height: 12.h),

          // Progress Bar
          Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.4, // 40% completion
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),

          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '40% Complete',
                style: AppTextStyles.caption.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showAddServiceDialog(context);
                      },
                      child: Text(
                        'Complete Now',
                        style: AppTextStyles.caption.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            title: 'Rating',
            value: '4.8',
            subtitle: '12 reviews',
            color: Colors.amber,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: _buildStatCard(
            icon: Icons.event_available,
            title: 'Bookings',
            value: '8',
            subtitle: 'This month',
            color: AppTheme.successColor,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: _buildStatCard(
            icon: Icons.account_balance_wallet,
            title: 'Earnings',
            value: '₹45K',
            subtitle: 'This month',
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyles.headline.copyWith(
              color: AppTheme.textPrimaryDark,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppTheme.textSecondaryDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              fontSize: 10.sp,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.title.copyWith(
            color: AppTheme.textPrimaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.calendar_today,
                title: 'Manage\nAvailability',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AvailabilityPage()),
                  );
                },
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildActionCard(
                icon: Icons.photo_library,
                title: 'Update\nPortfolio',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PortfolioPage()),
                  );
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.price_change,
                title: 'Update\nPricing',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PricingPage()),
                  );
                },
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildActionCard(
                icon: Icons.message,
                title: 'Message\nCenter',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MessageCenterPage(user: widget.user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.search,
                title: 'Browse\nOpportunities',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OpportunitiesPage(user: widget.user),
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildActionCard(
                icon: Icons.analytics,
                title: 'Profile\nAnalytics',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileAnalyticsPage(user: widget.user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return AccessibleButton(
      onPressed: onTap,
      semanticLabel: title.replaceAll('\n', ' '),
      semanticHint: 'Navigate to $title section',
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppTheme.outline),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color:
                    AppTheme.textPrimaryDark, // White text for dark background
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryDark, // White text for dark background
          ),
        ),

        SizedBox(height: 12.h),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppTheme.outline),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                icon: Icons.event,
                title: 'New booking request',
                subtitle: 'Wedding ceremony - Dec 15',
                time: '2 hours ago',
                color: AppTheme.primaryColor,
              ),

              Divider(height: 24.h),

              _buildActivityItem(
                icon: Icons.star,
                title: 'New review received',
                subtitle: '5 stars from Priya Sharma',
                time: '1 day ago',
                color: Colors.amber,
              ),

              Divider(height: 24.h),

              _buildActivityItem(
                icon: Icons.payment,
                title: 'Payment received',
                subtitle: '₹15,000 for corporate event',
                time: '2 days ago',
                color: AppTheme.successColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),

        Text(
          time,
          style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Bookings',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color:
                    AppTheme.textPrimaryDark, // White text for dark background
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingsPage(user: widget.user),
                  ),
                );
              },
              child: Text(
                'View All',
                style: TextStyle(fontSize: 14.sp, color: AppTheme.primaryColor),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppTheme.outline),
          ),
          child: Column(
            children: [
              _buildBookingItem(
                title: 'Wedding Ceremony',
                client: 'Rajesh & Priya',
                date: 'Dec 15, 2024',
                time: '6:00 PM - 10:00 PM',
                amount: '₹25,000',
                status: 'Confirmed',
              ),

              Divider(height: 24.h),

              _buildBookingItem(
                title: 'Corporate Event',
                client: 'TechCorp Solutions',
                date: 'Dec 20, 2024',
                time: '7:00 PM - 9:00 PM',
                amount: '₹15,000',
                status: 'Pending',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingItem({
    required String title,
    required String client,
    required String date,
    required String time,
    required String amount,
    required String status,
  }) {
    Color statusColor = status == 'Confirmed'
        ? AppTheme.successColor
        : AppTheme.warningColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        Text(
          'Client: $client',
          style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
        ),

        SizedBox(height: 4.h),

        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 14.sp,
              color: AppTheme.textSecondary,
            ),
            SizedBox(width: 4.w),
            Text(
              date,
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
            ),
            SizedBox(width: 16.w),
            Icon(Icons.access_time, size: 14.sp, color: AppTheme.textSecondary),
            SizedBox(width: 4.w),
            Text(
              time,
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        Text(
          amount,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.work_outline),
              title: const Text('Update Portfolio'),
              subtitle: const Text('Add new work samples and projects'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PortfolioPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.price_change_outlined),
              title: const Text('Update Pricing'),
              subtitle: const Text('Modify your service rates and packages'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PricingPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today_outlined),
              title: const Text('Update Availability'),
              subtitle: const Text('Set your available dates and times'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AvailabilityPage()),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
