import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

class TalentSearchWidget extends StatefulWidget {
  final UserModel user;

  const TalentSearchWidget({super.key, required this.user});

  @override
  State<TalentSearchWidget> createState() => _TalentSearchWidgetState();
}

class _TalentSearchWidgetState extends State<TalentSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie, size: 64.sp, color: AppTheme.productionColor),
          SizedBox(height: 16.h),
          Text(
            'Talent Pool',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Discover actors, crew, and production talent',
            style: TextStyle(fontSize: 16.sp, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
