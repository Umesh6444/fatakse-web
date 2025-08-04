import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/pages/signin_page.dart';
import '../../auth/presentation/pages/role_selection_page.dart';

class GetStartedPage extends StatelessWidget {
  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title),
                SizedBox(height: 2.h),
                Text(description, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
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
              SizedBox(height: 12.h),
              Text('Welcome to Fatakse', style: AppTextStyles.headline),
              SizedBox(height: 6.h),
              Text(
                'The backstage platform powering the show',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              _buildFeatureCard(
                context: context,
                icon: Icons.people_outline,
                iconColor: AppTheme.primaryColor,
                title: 'Connect Artists & Clients',
                description:
                    'Find the perfect artist for your event or get booked for gigs',
              ),
              SizedBox(height: 10.h),
              _buildFeatureCard(
                context: context,
                icon: Icons.inventory_outlined,
                iconColor: AppTheme.primaryColor,
                title: 'Equipment Rental',
                description:
                    'Rent or provide equipment for events and productions',
              ),
              SizedBox(height: 10.h),
              _buildFeatureCard(
                context: context,
                icon: Icons.event_note_outlined,
                iconColor: AppTheme.primaryColor,
                title: 'Event Planning',
                description:
                    'Manage events, bookings, and collaborate with teams',
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withAlpha((0.8 * 255).toInt()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withAlpha(
                        (0.2 * 255).toInt(),
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
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
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor, width: 1.2),
                  borderRadius: BorderRadius.circular(10.r),
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
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
