import 'package:get_it/get_it.dart';
import 'Bloc/auth/auth_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register services
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Register any other services here
}