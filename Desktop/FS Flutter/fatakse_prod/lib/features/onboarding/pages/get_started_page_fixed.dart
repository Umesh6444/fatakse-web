import 'package:flutter/material.dart';
import 'package:fatakse_prod/config/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/pages/signin_page.dart';
import '../../auth/presentation/pages/role_selection_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                // Logo Image - Clean without glow (Double Size)
                SizedBox(
                  width: 480.w,
                  height: 280.h,
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 440.w,
                      height: 240.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Welcome text
                Text('Welcome to Fatakse', style: AppTextStyles.headline),

                SizedBox(height: 10.h),

                Text(
                  'The backstage platform powering the show',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 35.h),

                // Feature Cards
                _buildFeatureCard(
                  context: context,
                  icon: Icons.people_outline,
                  iconColor: AppTheme.primaryColor,
                  title: 'Connect Artists & Clients',
                  description:
                      'Find the perfect artist for your event or get booked for gigs',
                ),

                SizedBox(height: 18.h),

                _buildFeatureCard(
                  context: context,
                  icon: Icons.inventory_outlined,
                  iconColor: AppTheme.primaryColor,
                  title: 'Equipment Rental',
                  description:
                      'Rent or provide equipment for events and productions',
                ),

                SizedBox(height: 18.h),

                _buildFeatureCard(
                  context: context,
                  icon: Icons.event_note_outlined,
                  iconColor: AppTheme.primaryColor,
                  title: 'Event Planning',
                  description:
                      'Manage events, bookings, and collaborate with teams',
                ),

                SizedBox(height: 40.h),

                // Get Started Button
                Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Get Started',
                      style: AppTextStyles.title.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Sign In Button
                Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: BlocProvider.of<AuthBloc>(context),
                            child: const SignInPage(),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: AppTextStyles.title.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2D).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.w),
          ),

          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title),
                SizedBox(height: 6.h),
                Text(description, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
