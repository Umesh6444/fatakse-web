import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';
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
