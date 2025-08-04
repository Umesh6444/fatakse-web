import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

class VendorSearchWidget extends StatefulWidget {
  final UserModel user;

  const VendorSearchWidget({super.key, required this.user});

  @override
  State<VendorSearchWidget> createState() => _VendorSearchWidgetState();
}

class _VendorSearchWidgetState extends State<VendorSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory, size: 64.sp, color: AppTheme.vendorColor),
          SizedBox(height: 16.h),
          Text(
            'Order Management',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Manage your rental orders and equipment here',
            style: TextStyle(fontSize: 16.sp, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
