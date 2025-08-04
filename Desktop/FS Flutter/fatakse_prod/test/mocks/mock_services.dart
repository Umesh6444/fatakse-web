import 'package:mockito/annotations.dart';

@GenerateMocks([
  SecurityService,
  ErrorService,
  PerformanceService,
  LoggerService,
])
import 'package:fatakse_prod/core/services/security_service.dart';
import 'package:fatakse_prod/core/services/error_service.dart';
import 'package:fatakse_prod/core/services/performance_service.dart';
import 'package:fatakse_prod/core/services/logger_service.dart';
// Import your service interfaces here
// import 'package:fatakse_prod/core/services/booking_service_interface.dart';
// import 'package:fatakse_prod/features/payments/services/payment_service.dart';
// import 'package:fatakse_prod/features/auth/presentation/bloc/auth_bloc.dart';

// Example mock classes:
// class MockBookingService extends Mock implements IBookingService {}
// class MockPaymentService extends Mock implements PaymentService {}
// class MockAuthBloc extends Mock implements AuthBloc {}

// Add more mocks as needed for each feature
