import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_bloc.dart';
import 'signup_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Select Your Role'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StageLink Logo
              Center(
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: const DecorationImage(
                      image: AssetImage('assets/logobolt.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Header
              Text(
                'What brings you to Fatakse?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                'Choose your role to get personalized features and recommendations',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              ),

              SizedBox(height: 30.h),

              // Role Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildRoleCard(
                      role: AppConstants.roleArtist,
                      title: 'Artist/Performer',
                      description:
                          'Singer, dancer, DJ, photographer, makeup artist, musician',
                      icon: Icons.mic,
                      color: AppTheme.artistColor,
                    ),

                    SizedBox(height: 16.h),

                    _buildRoleCard(
                      role: AppConstants.roleHouseholdClient,
                      title: 'Individual Client',
                      description:
                          'Book artists for personal events like birthdays, anniversaries',
                      icon: Icons.home,
                      color: AppTheme.clientColor,
                    ),

                    SizedBox(height: 16.h),

                    _buildRoleCard(
                      role: AppConstants.roleCorporateClient,
                      title: 'Corporate Client',
                      description:
                          'Organize corporate events, launches, conferences',
                      icon: Icons.business,
                      color: AppTheme.clientColor,
                    ),

                    SizedBox(height: 16.h),

                    _buildRoleCard(
                      role: AppConstants.roleVendor,
                      title: 'Vendor',
                      description:
                          'Rent equipment like sound systems, lights, cameras',
                      icon: Icons.inventory,
                      color: AppTheme.vendorColor,
                    ),

                    SizedBox(height: 16.h),

                    _buildRoleCard(
                      role: AppConstants.roleEventPlanner,
                      title: 'Event Planner',
                      description:
                          'Professional event organizer and coordinator',
                      icon: Icons.event,
                      color: AppTheme.plannerColor,
                    ),

                    SizedBox(height: 16.h),

                    _buildRoleCard(
                      role: AppConstants.roleProductionHouse,
                      title: 'Production House',
                      description: 'Film, TV, and media production company',
                      icon: Icons.movie,
                      color: AppTheme.productionColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedRole != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<AuthBloc>(context),
                                child: SignUpPageFixed(role: selectedRole!),
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ]
              : AppTheme.lightShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24.w,
              ),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppTheme.textPrimary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected) Icon(Icons.check_circle, color: color, size: 24.w),
          ],
        ),
      ),
    );
  }
}
