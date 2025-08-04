import '../../ai_tools/ai_tools_menu_page.dart';
import '../../../core/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';
import '../../../shared/models/user_model.dart';

class VendorDashboard extends StatelessWidget {
  final UserModel user;

  const VendorDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Welcome ${user.firstName}',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.vendorColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement notifications
            },
            icon: const Icon(Icons.notifications),
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
                    userRole: user.role,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Overview Card
            _buildBusinessOverviewCard(),

            SizedBox(height: 16.h),

            // Quick Stats
            _buildQuickStats(),

            SizedBox(height: 16.h),

            // Your Listings
            _buildYourListings(),

            SizedBox(height: 16.h),

            // Recent Orders
            _buildRecentOrders(),

            SizedBox(height: 16.h),

            // Revenue Analytics
            _buildRevenueAnalytics(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "vendor_dashboard_fab",
        onPressed: () {
          // TODO: Navigate to add new listing
        },
        backgroundColor: AppTheme.vendorColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBusinessOverviewCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.vendorColor,
            AppTheme.vendorColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.store, color: Colors.white, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Your Business',
                style: AppTextStyles.headline.copyWith(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            'Manage your equipment and services marketplace',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: _buildOverviewStat(
                  title: 'Total Listings',
                  value: '12',
                  icon: Icons.inventory,
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: _buildOverviewStat(
                  title: 'Active Rentals',
                  value: '8',
                  icon: Icons.handshake,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20.sp),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
            ),
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
            icon: Icons.trending_up,
            title: 'Revenue',
            value: '₹1.2L',
            subtitle: 'This month',
            color: AppTheme.successColor,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            title: 'Rating',
            value: '4.7',
            subtitle: '45 reviews',
            color: Colors.amber,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: _buildStatCard(
            icon: Icons.schedule,
            title: 'Pending',
            value: '3',
            subtitle: 'Orders',
            color: AppTheme.warningColor,
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
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              fontSize: 18.sp,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Listings',
              style: AppTextStyles.title.copyWith(
                color: AppTheme.textPrimary,
                fontSize: 18.sp,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all listings
              },
              child: Text(
                'Manage All',
                style: AppTextStyles.body.copyWith(
                  color: AppTheme.vendorColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 140.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppTheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: AppTheme.vendorColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getEquipmentIcon(index),
                          size: 32.sp,
                          color: AppTheme.vendorColor,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getEquipmentName(index),
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                              fontSize: 13.sp,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            '₹${_getEquipmentPrice(index)}/day',
                            style: AppTextStyles.caption.copyWith(
                              color: AppTheme.vendorColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Available',
                              style: AppTextStyles.caption.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getEquipmentIcon(int index) {
    const icons = [Icons.speaker, Icons.lightbulb, Icons.camera_alt, Icons.mic];
    return icons[index % icons.length];
  }

  String _getEquipmentName(int index) {
    const names = ['Sound System', 'LED Lights', 'Camera Setup', 'Microphone'];
    return names[index % names.length];
  }

  String _getEquipmentPrice(int index) {
    const prices = ['2,500', '1,800', '3,200', '800'];
    return prices[index % prices.length];
  }

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Orders',
          style: AppTextStyles.title.copyWith(
            color: AppTheme.textPrimary,
            fontSize: 18.sp,
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
              _buildOrderItem(
                equipment: 'Sound System Pro',
                client: 'Rahul Weddings',
                date: 'Dec 15-16, 2024',
                amount: '₹5,000',
                status: 'Confirmed',
                statusColor: AppTheme.successColor,
              ),

              Divider(height: 24.h),

              _buildOrderItem(
                equipment: 'LED Light Setup',
                client: 'Corporate Events Co.',
                date: 'Dec 20, 2024',
                amount: '₹3,600',
                status: 'Pending',
                statusColor: AppTheme.warningColor,
              ),

              Divider(height: 24.h),

              _buildOrderItem(
                equipment: 'Camera Equipment',
                client: 'Photography Studio',
                date: 'Dec 22-23, 2024',
                amount: '₹6,400',
                status: 'In Use',
                statusColor: AppTheme.infoColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String equipment,
    required String client,
    required String date,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppTheme.vendorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(
            Icons.inventory_2,
            color: AppTheme.vendorColor,
            size: 20.sp,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                equipment,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                'Client: $client',
                style: AppTextStyles.caption.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                date,
                style: AppTextStyles.caption.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                status,
                style: AppTextStyles.caption.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              amount,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Analytics',
          style: AppTextStyles.title.copyWith(
            color: AppTheme.textPrimary,
            fontSize: 18.sp,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRevenueItem(
                    title: 'Today',
                    amount: '₹8,500',
                    growth: '+12%',
                    isPositive: true,
                  ),

                  _buildRevenueItem(
                    title: 'This Week',
                    amount: '₹45,200',
                    growth: '+8%',
                    isPositive: true,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRevenueItem(
                    title: 'This Month',
                    amount: '₹1,23,000',
                    growth: '+15%',
                    isPositive: true,
                  ),

                  _buildRevenueItem(
                    title: 'Total Earned',
                    amount: '₹8,45,000',
                    growth: '',
                    isPositive: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueItem({
    required String title,
    required String amount,
    required String growth,
    required bool isPositive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 12.sp,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          amount,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontSize: 16.sp,
          ),
        ),

        if (growth.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                size: 12.sp,
                color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
              ),
              SizedBox(width: 2.w),
              Text(
                growth,
                style: AppTextStyles.caption.copyWith(
                  color: isPositive
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
