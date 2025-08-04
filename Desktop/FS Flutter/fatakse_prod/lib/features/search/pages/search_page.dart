import 'package:flutter/material.dart';

import '../../../config/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user_model.dart';
import '../widgets/artist_search_widget.dart';
import '../../../core/services/saved_jobs_service.dart';
import '../../../config/app_text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/vendor_search_widget.dart';
import '../widgets/job_search_widget.dart';
import '../widgets/talent_search_widget.dart';
import '../widgets/services_search_widget.dart';

class SearchPage extends StatefulWidget {
  final String userRole;
  final UserModel user;

  final FirebaseFirestore? firestore;
  final SavedJobsService? savedJobsService;

  const SearchPage({
    super.key,
    required this.userRole,
    required this.user,
    this.firestore,
    this.savedJobsService,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _getSearchTitle(),
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.getRoleColor(widget.userRole),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildSearchContent(),
    );
  }

  String _getSearchTitle() {
    switch (widget.userRole) {
      case AppConstants.roleArtist:
        return 'Find Jobs';
      case AppConstants.roleHouseholdClient:
      case AppConstants.roleCorporateClient:
        return 'Find Artists';
      case AppConstants.roleVendor:
        return 'Manage Orders';
      case AppConstants.roleEventPlanner:
        return 'Find Services';
      case AppConstants.roleProductionHouse:
        return 'Find Talent';
      default:
        return 'Search';
    }
  }

  Widget _buildSearchContent() {
    final firestore = widget.firestore ?? FirebaseFirestore.instance;
    final savedJobsService = widget.savedJobsService;
    switch (widget.userRole) {
      case AppConstants.roleArtist:
        return JobSearchWidget(
          user: widget.user,
          savedJobsService: savedJobsService,
        );
      case AppConstants.roleHouseholdClient:
      case AppConstants.roleCorporateClient:
        return ArtistSearchWidget(user: widget.user, firestore: firestore);
      case AppConstants.roleVendor:
        return VendorSearchWidget(user: widget.user);
      case AppConstants.roleEventPlanner:
        return ServicesSearchWidget(user: widget.user);
      case AppConstants.roleProductionHouse:
        return TalentSearchWidget(user: widget.user);
      default:
        return ArtistSearchWidget(user: widget.user, firestore: firestore);
    }
  }
}
