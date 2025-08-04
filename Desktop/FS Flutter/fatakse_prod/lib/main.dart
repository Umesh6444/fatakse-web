import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'core/services/security_service.dart';
import 'core/services/error_service.dart';
import 'core/services/performance_service.dart';
import 'core/services/cache_service.dart';
import 'core/services/logger_service.dart';
import 'firebase_options.dart';
import 'config/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/onboarding/pages/get_started_page.dart';
import 'features/home/pages/home_page.dart';
import 'get_it.dart';
// ...existing code...

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Only initialize Crashlytics on non-web platforms
    if (!kIsWeb) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    setupDependencies();
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization error: $error');
    debugPrint('Stack trace: $stackTrace');
  }

  runApp(const Fatakse());
}

class Fatakse extends StatelessWidget {
  const Fatakse({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        Widget app = BlocProvider(
          create: (context) => AuthBloc(
            firebaseAuth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
            securityService: SecurityService(),
            errorService: ErrorService(),
            performanceService: PerformanceService(),
            cacheService: CacheService(),
            loggerService: LoggerService(),
          ),
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, mode, _) {
              return MaterialApp(
                title: 'Fatakse',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: mode,
                home: const AuthWrapper(),
              );
            },
          ),
        );
        // On web, constrain to mobile size and center
        if (kIsWeb) {
          app = Center(
            child: Container(
              width: 390, // iPhone 14 Pro width
              height: 844, // iPhone 14 Pro height
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: app,
              ),
            ),
          );
        }
        return app;
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasCheckedAuth = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Only trigger auth check once, not on every build
        if (!_hasCheckedAuth && state is! AuthLoading) {
          _hasCheckedAuth = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<AuthBloc>().add(const AuthCheckStatus());
            }
          });
        }

        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          return const HomePage();
        } else {
          // For initial state and unauthenticated state, show get started page
          return const GetStartedPage();
        }
      },
    );
  }
}
