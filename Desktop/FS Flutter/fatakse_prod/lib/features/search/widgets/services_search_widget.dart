import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

class ServicesSearchWidget extends StatefulWidget {
  final UserModel user;

  const ServicesSearchWidget({super.key, required this.user});

  @override
  State<ServicesSearchWidget> createState() => _ServicesSearchWidgetState();
}

class _ServicesSearchWidgetState extends State<ServicesSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_center,
            size: 64.sp,
            color: AppTheme.plannerColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'Services Directory',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Find vendors and services for your events',
            style: TextStyle(fontSize: 16.sp, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
