import 'package:get_it/get_it.dart';
import 'core/services/booking_service.dart';
import 'core/services/booking_service_interface.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<IBookingService>(() => BookingService());
  // Register other services, repositories, and blocs here as needed
}
