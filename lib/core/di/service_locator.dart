import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/user_data_source.dart';
import '../../features/auth/data/repositories/user_repository_impl.dart';
import '../../features/auth/domain/repositories/user_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_profile.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/sign_in_user.dart';
import '../../features/auth/domain/usecases/sign_out_user.dart';
import '../../features/auth/domain/usecases/update_user.dart';
import '../../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../../features/auth/presentation/blocs/register/register_bloc.dart';
import '../../features/favorites/data/datasources/favorites_local_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_saved_listing_ids.dart';
import '../../features/favorites/domain/usecases/toggle_saved_listing.dart';
import '../../features/favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import '../../features/listings/data/datasources/listing_data_source.dart';
import '../../features/listings/data/repositories/listing_repository_impl.dart';
import '../../features/listings/domain/repositories/listing_repository.dart';
import '../../features/listings/domain/usecases/add_listing.dart';
import '../../features/listings/domain/usecases/get_listings.dart';
import '../../features/listings/domain/usecases/search_listings.dart';
import '../../features/listings/presentation/blocs/listings/listings_bloc.dart';
import '../../features/listings/presentation/blocs/theme/switchtheme_bloc.dart';
import '../firebase/auth_service.dart';
import '../firebase/firestore_service.dart';
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

  sl.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  sl.registerLazySingleton<FirestoreService>(
    () => FirestoreService(),
  );

  //! Feature: Listings
  // Data Sources
  sl.registerLazySingleton<ListingDataSource>(
    () => ListingDataSourceImpl(client: sl<http.Client>()),
  );

  // Repositories
  sl.registerLazySingleton<ListingRepository>(
    () => ListingRepositoryImpl(
      dataSource: sl<ListingDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetListingsUseCase(sl<ListingRepository>()));
  sl.registerLazySingleton(() => SearchListingsUseCase(sl<ListingRepository>()));
  sl.registerLazySingleton(() => AddListingUseCase(sl<ListingRepository>()));

  // BLoCs
  sl.registerFactory(
    () => ListingsBloc(
      getListingsUseCase: sl<GetListingsUseCase>(),
      addListingUseCase: sl<AddListingUseCase>(),
    ),
  );

  sl.registerFactory(
    () => SwitchthemeBloc(),
  );

  //! Feature: Favorites
  // Data Sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repositories
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl<FavoritesLocalDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetSavedListingIdsUseCase(sl<FavoritesRepository>()));
  sl.registerLazySingleton(() => ToggleSavedListingUseCase(sl<FavoritesRepository>()));

  // BLoC
  sl.registerFactory(
    () => SavedListingsBloc(
      getSavedListingIdsUseCase: sl<GetSavedListingIdsUseCase>(),
      toggleSavedListingUseCase: sl<ToggleSavedListingUseCase>(),
    ),
  );

  //! Feature: Auth
  // Data Sources
  sl.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(
      authService: sl<AuthService>(),
      firestoreService: sl<FirestoreService>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => SignInUserUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => SignOutUserUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(
    () => GetCurrentUserProfileUseCase(sl<UserRepository>()),
  );

  // BLoCs
  sl.registerFactory(
    () => AuthBloc(
      signInUserUseCase: sl<SignInUserUseCase>(),
      signOutUserUseCase: sl<SignOutUserUseCase>(),
      getCurrentUserProfileUseCase: sl<GetCurrentUserProfileUseCase>(),
      updateUserUseCase: sl<UpdateUserUseCase>(),
      authService: sl<AuthService>(),
    ),
  );

  sl.registerFactory(
    () => RegisterBloc(
      registerUserUseCase: sl<RegisterUserUseCase>(),
    ),
  );
}
