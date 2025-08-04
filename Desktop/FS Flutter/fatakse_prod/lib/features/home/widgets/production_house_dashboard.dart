import '../../ai_tools/ai_tools_menu_page.dart';
import '../../../core/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';
import '../../../shared/models/user_model.dart';

class ProductionHouseDashboard extends StatelessWidget {
  final UserModel user;

  const ProductionHouseDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          '${user.firstName} Productions',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.productionColor,
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
            // Production Studio Overview
            _buildStudioOverviewCard(),

            SizedBox(height: 16.h),

            // Active Productions
            _buildActiveProductions(),

            SizedBox(height: 16.h),

            // Crew Management
            _buildCrewManagement(),

            SizedBox(height: 16.h),

            // Casting & Talent
            _buildCastingTalent(),

            SizedBox(height: 16.h),

            // Revenue Analytics
            _buildRevenueAnalytics(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "production_house_dashboard_fab",
        onPressed: () {
          // TODO: Navigate to create new production
        },
        backgroundColor: AppTheme.productionColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStudioOverviewCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.productionColor,
            AppTheme.productionColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.movie, color: Colors.white, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Production Studio',
                style: AppTextStyles.headline.copyWith(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            'Manage productions, coordinate crews, and deliver exceptional content',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: _buildStudioStat(
                  title: 'Active Projects',
                  value: '7',
                  icon: Icons.video_camera_back,
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: _buildStudioStat(
                  title: 'Crew Members',
                  value: '35',
                  icon: Icons.groups,
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: _buildStudioStat(
                  title: 'This Quarter',
                  value: '₹85L',
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudioStat({
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
          Icon(icon, color: Colors.white, size: 18.sp),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProductions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Productions',
              style: AppTextStyles.title.copyWith(
                color: AppTheme.textPrimary,
                fontSize: 18.sp,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all productions
              },
              child: Text(
                'View All',
                style: AppTextStyles.body.copyWith(
                  color: AppTheme.productionColor,
                  fontSize: 14.sp,
                ),
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
              _buildProductionItem(
                title: 'TechCorp Brand Film',
                type: 'Commercial',
                phase: 'Post-Production',
                budget: '₹15,00,000',
                completion: 0.85,
                daysLeft: 8,
                director: 'Arjun Malhotra',
                phaseColor: AppTheme.warningColor,
              ),

              Divider(height: 24.h),

              _buildProductionItem(
                title: 'Wedding Highlight Reel',
                type: 'Event',
                phase: 'Shooting',
                budget: '₹3,50,000',
                completion: 0.45,
                daysLeft: 15,
                director: 'Priya Sharma',
                phaseColor: AppTheme.infoColor,
              ),

              Divider(height: 24.h),

              _buildProductionItem(
                title: 'Music Video - Fusion',
                type: 'Music Video',
                phase: 'Pre-Production',
                budget: '₹8,00,000',
                completion: 0.25,
                daysLeft: 22,
                director: 'Vikram Singh',
                phaseColor: AppTheme.productionColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductionItem({
    required String title,
    required String type,
    required String phase,
    required String budget,
    required double completion,
    required int daysLeft,
    required String director,
    required Color phaseColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: phaseColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                phase,
                style: AppTextStyles.caption.copyWith(
                  color: phaseColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        Row(
          children: [
            Text(
              'Type: $type',
              style: AppTextStyles.body.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            Spacer(),
            Text(
              budget,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        Text(
          'Director: $director',
          style: AppTextStyles.body.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 14.sp,
          ),
        ),

        SizedBox(height: 8.h),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress: ${(completion * 100).toInt()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        '$daysLeft days left',
                        style: AppTextStyles.caption.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: completion,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: phaseColor,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCrewManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crew Management',
          style: AppTextStyles.title.copyWith(
            color: AppTheme.textPrimary,
            fontSize: 18.sp,
          ),
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _buildCrewCard(
                icon: Icons.videocam,
                title: 'Cinematographers',
                count: '8',
                available: '5',
                color: AppTheme.infoColor,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildCrewCard(
                icon: Icons.headphones,
                title: 'Sound Engineers',
                count: '4',
                available: '3',
                color: AppTheme.successColor,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _buildCrewCard(
                icon: Icons.edit,
                title: 'Video Editors',
                count: '6',
                available: '4',
                color: AppTheme.warningColor,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildCrewCard(
                icon: Icons.flash_on,
                title: 'Lighting Crew',
                count: '10',
                available: '7',
                color: AppTheme.productionColor,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to crew management
          },
          icon: Icon(Icons.people, size: 18.sp),
          label: Text('Manage All Crew'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.productionColor,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 44.h),
          ),
        ),
      ],
    );
  }

  Widget _buildCrewCard({
    required IconData icon,
    required String title,
    required String count,
    required String available,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to specific crew category
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppTheme.outline),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              count,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                fontSize: 18.sp,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '$available available',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCastingTalent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Casting & Talent',
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
              _buildTalentRequest(
                project: 'TechCorp Brand Film',
                role: 'Lead Actor (Male, 25-35)',
                applications: 45,
                deadline: 'Dec 18, 2024',
                status: 'Reviewing',
                priority: 'High',
              ),

              Divider(height: 20.h),

              _buildTalentRequest(
                project: 'Music Video - Fusion',
                role: 'Backup Dancers (6 needed)',
                applications: 28,
                deadline: 'Dec 20, 2024',
                status: 'Open',
                priority: 'Medium',
              ),

              Divider(height: 20.h),

              _buildTalentRequest(
                project: 'Wedding Highlight',
                role: 'Voice-over Artist',
                applications: 12,
                deadline: 'Dec 15, 2024',
                status: 'Shortlisted',
                priority: 'Low',
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to post casting call
                      },
                      icon: Icon(Icons.post_add, size: 16.sp),
                      label: Text('Post Casting'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.productionColor,
                        side: BorderSide(color: AppTheme.productionColor),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to talent pool
                      },
                      icon: Icon(Icons.search, size: 16.sp),
                      label: Text('Browse Talent'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.productionColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTalentRequest({
    required String project,
    required String role,
    required int applications,
    required String deadline,
    required String status,
    required String priority,
  }) {
    Color priorityColor = priority == 'High'
        ? AppTheme.errorColor
        : priority == 'Medium'
        ? AppTheme.warningColor
        : AppTheme.successColor;

    Color statusColor = status == 'Open'
        ? AppTheme.infoColor
        : status == 'Reviewing'
        ? AppTheme.warningColor
        : AppTheme.successColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                role,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                priority,
                style: AppTextStyles.caption.copyWith(
                  color: priorityColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        Text(
          'Project: $project',
          style: AppTextStyles.caption.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 13.sp,
          ),
        ),

        SizedBox(height: 8.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.people, size: 14.sp, color: AppTheme.textSecondary),
                SizedBox(width: 4.w),
                Text(
                  '$applications applications',
                  style: AppTextStyles.caption.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14.sp,
                  color: AppTheme.textSecondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  deadline,
                  style: AppTextStyles.caption.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                status,
                style: AppTextStyles.caption.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
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
                children: [
                  Expanded(
                    child: _buildRevenueCard(
                      title: 'This Month',
                      amount: '₹28,50,000',
                      change: '+15%',
                      isPositive: true,
                      icon: Icons.trending_up,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: _buildRevenueCard(
                      title: 'Avg per Project',
                      amount: '₹9,50,000',
                      change: '+8%',
                      isPositive: true,
                      icon: Icons.movie,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: _buildRevenueCard(
                      title: 'Outstanding',
                      amount: '₹5,75,000',
                      change: '-3%',
                      isPositive: false,
                      icon: Icons.pending,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: _buildRevenueCard(
                      title: 'Crew Costs',
                      amount: '₹12,30,000',
                      change: '+12%',
                      isPositive: false,
                      icon: Icons.people,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to detailed analytics
                },
                icon: Icon(Icons.analytics, size: 18.sp),
                label: Text('View Detailed Reports'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.productionColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 44.h),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueCard({
    required String title,
    required String amount,
    required String change,
    required bool isPositive,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: AppTheme.textSecondary),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            amount,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              fontSize: 16.sp,
            ),
          ),
          Text(
            change,
            style: AppTextStyles.caption.copyWith(
              color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
