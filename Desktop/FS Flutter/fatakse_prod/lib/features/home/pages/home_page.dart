import '../../ai_tools/ai_tools_menu_page.dart';
import '../../../core/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../../main.dart' show themeModeNotifier;
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user_model.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../bookings/pages/bookings_page.dart';
import '../../messaging/pages/messages_page.dart';
import '../../onboarding/pages/get_started_page.dart';
import '../../search/pages/search_page.dart';
import '../widgets/artist_dashboard.dart';
import '../widgets/client_dashboard.dart';
import '../widgets/vendor_dashboard.dart';
import '../widgets/event_planner_dashboard.dart';
import '../widgets/production_house_dashboard.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/saved_jobs_service.dart';

typedef BookingsPageBuilder = Widget Function(String role);

/// HomePage is the main landing page after authentication.
///
/// Displays dashboards, navigation, and role-based content for all user types.
class HomePage extends StatefulWidget {
  /// Optional Firestore instance for dependency injection/testing.
  final FirebaseFirestore? firestore;

  /// Optional SavedJobsService for dependency injection/testing.
  final SavedJobsService? savedJobsService;

  /// Optional builder for BookingsPage, used for test overrides.
  final BookingsPageBuilder? bookingsPageBuilder;

  /// Creates a HomePage.
  ///
  /// [firestore], [savedJobsService], and [bookingsPageBuilder] are optional and used for testing or dependency injection.
  const HomePage({
    super.key,
    this.firestore,
    this.savedJobsService,
    this.bookingsPageBuilder,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for [HomePage]. Handles navigation, role-based dashboards, and user actions.
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const GetStartedPage()),
              (route) => false,
            );
          });
          return const Scaffold(body: SizedBox.shrink());
        }

        final user = state.user;
        final role = user.role;

        final isRoleSelection = role == 'unknown' || role.isEmpty;
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text('Fatakse'),
            actions: [
              IconButton(
                icon: Icon(_themeIcon(themeModeNotifier.value)),
                tooltip: 'Toggle Theme',
                onPressed: () {
                  setState(() {
                    themeModeNotifier.value = _nextThemeMode(
                      themeModeNotifier.value,
                    );
                  });
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: [
                  _buildDashboard(role, user),
                  _buildSearchPage(role),
                  _buildMessagesPage(),
                  _buildBookingsPage(role),
                  _buildProfilePage(user),
                ],
              ),
              if (!isRoleSelection)
                Positioned(
                  right: 16,
                  bottom: 32,
                  child: Builder(
                    builder: (context) => FloatingActionButton.extended(
                      icon: const Icon(Icons.smart_toy),
                      label: const Text('AI Tools'),
                      onPressed: () {
                        final openAIService = OpenAIService(
                          apiKey:
                              "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",
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AIToolsMenuPage(
                              openAIService: openAIService,
                              userRole: role,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavBar(role),
        );
      },
    );
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      default:
        return Icons.brightness_auto;
    }
  }

  ThemeMode _nextThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return ThemeMode.light;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
    }
  }

  /// Returns the dashboard widget for the given user role.
  Widget _buildDashboard(String role, UserModel user) {
    switch (role) {
      case AppConstants.roleArtist:
        return ArtistDashboard(user: user);
      case AppConstants.roleHouseholdClient:
      case AppConstants.roleCorporateClient:
      case 'client': // Handle generic client role
        return ClientDashboard(user: user);
      case AppConstants.roleVendor:
        return VendorDashboard(user: user);
      case AppConstants.roleEventPlanner:
        return EventPlannerDashboard(user: user);
      case AppConstants.roleProductionHouse:
        return ProductionHouseDashboard(user: user);
      case 'unknown':
        return _buildRoleSelectionPrompt(user);
      default:
        return _buildDefaultDashboard(user);
    }
  }

  /// Builds the default dashboard for users with unknown or unsupported roles.
  Widget _buildDefaultDashboard(UserModel user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.firstName}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Icon(Icons.dashboard, size: 80, color: AppTheme.primaryColor),
              const SizedBox(height: 24),
              Text(
                'Welcome to Fatakse!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your professional creative marketplace',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Explore the tabs below to discover artists, manage bookings, and connect with the creative community.',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Prompts the user to select a primary role if not set.
  Widget _buildRoleSelectionPrompt(UserModel user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.firstName}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Icon(
                Icons.person_pin_rounded,
                size: 60.sp,
                color: AppTheme.primaryColor,
              ),
              SizedBox(height: 20.h),
              Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Please select your primary role:',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Role selection buttons
              _buildRoleButton(
                'Artist/Performer',
                AppConstants.roleArtist,
                Icons.mic,
                AppTheme.artistColor,
              ),
              SizedBox(height: 8.h),
              _buildRoleButton(
                'Client',
                'client',
                Icons.business,
                AppTheme.clientColor,
              ),
              SizedBox(height: 8.h),
              _buildRoleButton(
                'Vendor',
                AppConstants.roleVendor,
                Icons.store,
                AppTheme.vendorColor,
              ),
              SizedBox(height: 8.h),
              _buildRoleButton(
                'Event Planner',
                AppConstants.roleEventPlanner,
                Icons.event,
                AppTheme.plannerColor,
              ),
              SizedBox(height: 8.h),
              _buildRoleButton(
                'Production House',
                AppConstants.roleProductionHouse,
                Icons.movie,
                AppTheme.productionColor,
              ),

              SizedBox(height: 24.h),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthSignOutRequested());
                },
                child: Text(
                  'Sign Out Instead',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a button for selecting a user role during onboarding.
  Widget _buildRoleButton(
    String title,
    String role,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _selectRole(role),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: color),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Updates the user's role in the profile.
  void _selectRole(String role) {
    // Update the user's role
    final currentState = context.read<AuthBloc>().state;
    if (currentState is AuthAuthenticated) {
      final updatedUser = currentState.user.copyWith(role: role);
      context.read<AuthBloc>().add(AuthUpdateProfile(updatedData: updatedUser));
    }
  }

  /// Returns the search page for the given user role.
  Widget _buildSearchPage(String role) {
    return SearchPage(
      userRole: role,
      user: context.read<AuthBloc>().state is AuthAuthenticated
          ? (context.read<AuthBloc>().state as AuthAuthenticated).user
          : UserModel(
              id: '',
              firstName: '',
              lastName: '',
              email: '',
              role: role,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      firestore: widget.firestore,
      savedJobsService: widget.savedJobsService,
    );
  }

  /// Returns the messages page for the current user.
  Widget _buildMessagesPage() {
    final user = context.read<AuthBloc>().state is AuthAuthenticated
        ? (context.read<AuthBloc>().state as AuthAuthenticated).user
        : UserModel(
            id: '',
            firstName: '',
            lastName: '',
            email: '',
            role: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

    return MessagesPage(user: user);
  }

  /// Returns the bookings page for the given user role.
  Widget _buildBookingsPage(String role) {
    if (widget.bookingsPageBuilder != null) {
      return widget.bookingsPageBuilder!(role);
    }
    final user = context.read<AuthBloc>().state is AuthAuthenticated
        ? (context.read<AuthBloc>().state as AuthAuthenticated).user
        : UserModel(
            id: '',
            firstName: '',
            lastName: '',
            email: '',
            role: role,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
    return BookingsPage(user: user);
  }

  /// Returns the profile page for the current user.
  Widget _buildProfilePage(UserModel user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                user.firstName.isNotEmpty
                    ? user.firstName[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            Text(
              user.email,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppTheme.getRoleColor(user.role).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                _getRoleDisplayName(user.role),
                style: TextStyle(
                  color: AppTheme.getRoleColor(user.role),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the bottom navigation bar with role-based labels.
  BottomNavigationBar _buildBottomNavBar(String role) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.textSecondary,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: _getSearchLabel(role),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Bookings',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  /// Returns the label for the search tab based on user role.
  String _getSearchLabel(String role) {
    switch (role) {
      case AppConstants.roleArtist:
        return 'Jobs';
      case AppConstants.roleHouseholdClient:
      case AppConstants.roleCorporateClient:
        return 'Artists';
      case AppConstants.roleVendor:
        return 'Orders';
      case AppConstants.roleEventPlanner:
        return 'Services';
      case AppConstants.roleProductionHouse:
        return 'Talent';
      default:
        return 'Search';
    }
  }

  /// Returns the display name for a given user role.
  String _getRoleDisplayName(String role) {
    switch (role) {
      case AppConstants.roleArtist:
        return 'Artist/Performer';
      case AppConstants.roleHouseholdClient:
        return 'Individual Client';
      case AppConstants.roleCorporateClient:
        return 'Corporate Client';
      case AppConstants.roleVendor:
        return 'Vendor';
      case AppConstants.roleEventPlanner:
        return 'Event Planner';
      case AppConstants.roleProductionHouse:
        return 'Production House';
      default:
        return 'User';
    }
  }
}
