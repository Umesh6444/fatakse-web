import '../../ai_tools/ai_tools_menu_page.dart';
import '../../../core/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';
import '../../../shared/models/user_model.dart';
import '../../client/pages/booking_management_page.dart';
import '../../search/pages/search_page.dart';

class ClientDashboard extends StatelessWidget {
  final UserModel user;

  const ClientDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Welcome ${user.firstName}',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.clientColor,
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
            // Quick Booking Card
            _buildQuickBookingCard(context),

            SizedBox(height: 16.h),

            // Event Categories
            _buildEventCategories(context),

            SizedBox(height: 16.h),

            // Your Bookings
            _buildYourBookings(context),

            SizedBox(height: 16.h),

            // Featured Artists
            _buildFeaturedArtists(),

            SizedBox(height: 16.h),

            // Recent Reviews
            _buildRecentReviews(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "client_dashboard_fab",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookingManagementPage(),
            ),
          );
        },
        backgroundColor: AppTheme.clientColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickBookingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.clientColor,
            AppTheme.clientColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book Your Next Event',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            'Find the perfect artists for your special occasions',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchPage(userRole: user.role, user: user),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.clientColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Find Artists',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchPage(userRole: user.role, user: user),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Find Vendors',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCategories(BuildContext context) {
    final categories = [
      {'name': 'Wedding', 'icon': Icons.favorite, 'color': Colors.pink},
      {'name': 'Birthday', 'icon': Icons.cake, 'color': Colors.orange},
      {'name': 'Corporate', 'icon': Icons.business, 'color': Colors.blue},
      {'name': 'Festival', 'icon': Icons.celebration, 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Categories',
          style: AppTextStyles.title.copyWith(color: AppTheme.textPrimary),
        ),

        SizedBox(height: 12.h),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchPage(userRole: user.role, user: user),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppTheme.outline),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      color: category['color'] as Color,
                      size: 32.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      category['name'] as String,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildYourBookings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Bookings',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingManagementPage(),
                  ),
                );
              },
              child: Text(
                'View All',
                style: AppTextStyles.body.copyWith(color: AppTheme.clientColor),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.outline),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildBookingItem(
                artistName: 'Rahul Sharma',
                eventType: 'Wedding Singer',
                date: 'Dec 15, 2024',
                status: 'Confirmed',
                amount: '₹25,000',
                statusColor: AppTheme.successColor,
              ),
              Divider(height: 24.h),
              _buildBookingItem(
                artistName: 'Priya Dance Group',
                eventType: 'Cultural Performance',
                date: 'Dec 20, 2024',
                status: 'Pending',
                amount: '₹35,000',
                statusColor: AppTheme.warningColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingItem({
    required String artistName,
    required String eventType,
    required String date,
    required String status,
    required String amount,
    required Color statusColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: AppTheme.clientColor.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: AppTheme.clientColor, size: 24.sp),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                artistName,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                eventType,
                style: AppTextStyles.caption.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 14.sp,
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

  Widget _buildFeaturedArtists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Artists',
          style: AppTextStyles.title.copyWith(color: AppTheme.textPrimary),
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 240.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160.w,
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
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: AppTheme.clientColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: AppTheme.clientColor,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Artist ${index + 1}',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: 4.h),

                            Text(
                              'Musician',
                              style: AppTextStyles.caption.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: 8.h),

                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14.sp,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '4.${8 + index}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildRecentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Reviews',
          style: AppTextStyles.title.copyWith(color: AppTheme.textPrimary),
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
              _buildReviewItem(
                artistName: 'Rahul Sharma',
                rating: 5,
                review: 'Amazing performance! Everyone loved the music.',
                date: '2 days ago',
              ),

              Divider(height: 24.h),

              _buildReviewItem(
                artistName: 'Priya Dance Group',
                rating: 5,
                review: 'Professional and entertaining. Highly recommended!',
                date: '1 week ago',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String artistName,
    required int rating,
    required String review,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              artistName,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                fontSize: 16.sp,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 16.sp,
                  color: Colors.amber,
                );
              }),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        Text(
          review,
          style: AppTextStyles.body.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 14.sp,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          date,
          style: AppTextStyles.caption.copyWith(
            color: AppTheme.textLight,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
