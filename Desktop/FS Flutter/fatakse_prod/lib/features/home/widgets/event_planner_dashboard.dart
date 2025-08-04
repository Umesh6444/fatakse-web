import '../../ai_tools/ai_tools_menu_page.dart';
import '../../../core/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';
import '../../../shared/models/user_model.dart';

class EventPlannerDashboard extends StatelessWidget {
  final UserModel user;

  const EventPlannerDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Welcome ${user.firstName}'),
        backgroundColor: AppTheme.plannerColor,
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
            // Event Planning Hub
            _buildPlanningHubCard(),

            SizedBox(height: 16.h),

            // Active Projects
            _buildActiveProjects(),

            SizedBox(height: 16.h),

            // Resource Management
            _buildResourceManagement(),

            SizedBox(height: 16.h),

            // Team Collaboration
            _buildTeamCollaboration(),

            SizedBox(height: 16.h),

            // Client Communications
            _buildClientCommunications(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "event_planner_dashboard_fab",
        onPressed: () {
          // TODO: Navigate to create new event
        },
        backgroundColor: AppTheme.plannerColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPlanningHubCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.plannerColor,
            AppTheme.plannerColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: Colors.white, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Event Planning Hub',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Text(
            'Manage events, coordinate teams, and deliver exceptional experiences',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: _buildHubStat(
                  title: 'Active Events',
                  value: '5',
                  icon: Icons.event,
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: _buildHubStat(
                  title: 'This Month',
                  value: '12',
                  icon: Icons.calendar_month,
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: _buildHubStat(
                  title: 'Team Members',
                  value: '8',
                  icon: Icons.group,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHubStat({
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
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Projects',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all projects
              },
              child: Text(
                'View All',
                style: TextStyle(fontSize: 14.sp, color: AppTheme.plannerColor),
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
              _buildProjectItem(
                title: 'Sharma Wedding Celebration',
                client: 'Rajesh & Priya Sharma',
                date: 'Dec 15, 2024',
                progress: 0.8,
                status: 'In Progress',
                budget: '₹8,50,000',
                statusColor: AppTheme.infoColor,
              ),

              Divider(height: 24.h),

              _buildProjectItem(
                title: 'TechCorp Annual Summit',
                client: 'TechCorp Solutions',
                date: 'Dec 22, 2024',
                progress: 0.6,
                status: 'Planning',
                budget: '₹12,00,000',
                statusColor: AppTheme.warningColor,
              ),

              Divider(height: 24.h),

              _buildProjectItem(
                title: 'Cultural Festival 2024',
                client: 'City Cultural Committee',
                date: 'Dec 28, 2024',
                progress: 0.3,
                status: 'Initial',
                budget: '₹5,50,000',
                statusColor: AppTheme.plannerColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectItem({
    required String title,
    required String client,
    required String date,
    required double progress,
    required String status,
    required String budget,
    required Color statusColor,
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
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
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
            Spacer(),
            Text(
              budget,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress: ${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: statusColor,
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

  Widget _buildResourceManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resource Management',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _buildResourceCard(
                icon: Icons.people,
                title: 'Artists\n& Performers',
                count: '45',
                action: 'Find More',
                color: AppTheme.artistColor,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildResourceCard(
                icon: Icons.inventory,
                title: 'Equipment\n& Vendors',
                count: '28',
                action: 'Browse',
                color: AppTheme.vendorColor,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _buildResourceCard(
                icon: Icons.location_on,
                title: 'Venues\n& Locations',
                count: '15',
                action: 'Explore',
                color: AppTheme.infoColor,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: _buildResourceCard(
                icon: Icons.restaurant,
                title: 'Catering\n& Services',
                count: '32',
                action: 'View All',
                color: AppTheme.successColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceCard({
    required IconData icon,
    required String title,
    required String count,
    required String action,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to resource category
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
            Icon(icon, color: color, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              count,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              action,
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCollaboration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Collaboration',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
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
              _buildTeamMember(
                name: 'Sarah Johnson',
                role: 'Lead Coordinator',
                status: 'Online',
                avatar: 'SJ',
                isOnline: true,
              ),

              Divider(height: 20.h),

              _buildTeamMember(
                name: 'Mike Chen',
                role: 'Vendor Manager',
                status: 'Busy',
                avatar: 'MC',
                isOnline: false,
              ),

              Divider(height: 20.h),

              _buildTeamMember(
                name: 'Priya Patel',
                role: 'Client Relations',
                status: 'Online',
                avatar: 'PP',
                isOnline: true,
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to team chat
                      },
                      icon: Icon(Icons.chat, size: 16.sp),
                      label: Text('Team Chat'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.plannerColor,
                        side: BorderSide(color: AppTheme.plannerColor),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to add team member
                      },
                      icon: Icon(Icons.person_add, size: 16.sp),
                      label: Text('Add Member'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.plannerColor,
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

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String status,
    required String avatar,
    required bool isOnline,
  }) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppTheme.plannerColor,
              child: Text(
                avatar,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isOnline
                      ? AppTheme.successColor
                      : AppTheme.textSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),

        Text(
          status,
          style: TextStyle(
            fontSize: 12.sp,
            color: isOnline ? AppTheme.successColor : AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildClientCommunications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Client Communications',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
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
              _buildCommunicationItem(
                icon: Icons.message,
                title: 'New message from Rajesh Sharma',
                subtitle: 'Regarding venue decoration changes...',
                time: '2 hours ago',
                isUnread: true,
              ),

              Divider(height: 20.h),

              _buildCommunicationItem(
                icon: Icons.phone,
                title: 'Scheduled call with TechCorp',
                subtitle: 'Audio-visual requirements discussion',
                time: 'Tomorrow 3 PM',
                isUnread: false,
              ),

              Divider(height: 20.h),

              _buildCommunicationItem(
                icon: Icons.email,
                title: 'Contract approval pending',
                subtitle: 'Cultural Festival event contract',
                time: '1 day ago',
                isUnread: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommunicationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppTheme.plannerColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(icon, color: AppTheme.plannerColor, size: 20.sp),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isUnread
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
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

        SizedBox(width: 8.w),

        Text(
          time,
          style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
