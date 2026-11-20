import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/auth_service.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  //! External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(),
  );
}
