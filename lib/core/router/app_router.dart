import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import '../../features/favorites/presentation/screens/saved_screen.dart';
import '../../features/listings/domain/entities/listing_entity.dart';
import '../../features/listings/presentation/screens/home_screen.dart';
import '../../features/listings/presentation/screens/listing_detail_screen.dart';
import '../../features/listings/presentation/screens/post_listing_screen.dart';
import '../../features/listings/presentation/screens/search_screen.dart';
import '../strings/messages.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          final String location = state.uri.path;
          int selectedIndex = 0;
          if (location.startsWith(AppRoutes.search)) {
            selectedIndex = 1;
          } else if (location.startsWith(AppRoutes.saved)) {
            selectedIndex = 2;
          } else if (location.startsWith(AppRoutes.profile)) {
            selectedIndex = 3;
          }

          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go(AppRoutes.home);
                    break;
                  case 1:
                    context.go(AppRoutes.search);
                    break;
                  case 2:
                    context.go(AppRoutes.saved);
                    break;
                  case 3:
                    context.go(AppRoutes.profile);
                    break;
                }
              },
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: NAV_HOME,
                ),
                const NavigationDestination(
                  icon: Icon(Icons.search_rounded),
                  selectedIcon: Icon(Icons.saved_search_rounded),
                  label: NAV_SEARCH,
                ),
                NavigationDestination(
                  icon: BlocBuilder<SavedListingsBloc, SavedListingsState>(
                    builder: (context, state) {
                      final count = state is SavedListingsLoaded ? state.count : 0;
                      if (count > 0) {
                        return Badge.count(
                          count: count,
                          child: const Icon(Icons.favorite_outline_rounded),
                        );
                      }
                      return const Icon(Icons.favorite_outline_rounded);
                    },
                  ),
                  selectedIcon: BlocBuilder<SavedListingsBloc, SavedListingsState>(
                    builder: (context, state) {
                      final count = state is SavedListingsLoaded ? state.count : 0;
                      if (count > 0) {
                        return Badge.count(
                          count: count,
                          child: const Icon(Icons.favorite_rounded),
                        );
                      }
                      return const Icon(Icons.favorite_rounded);
                    },
                  ),
                  label: NAV_SAVED,
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: NAV_PROFILE,
                ),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.saved,
            builder: (context, state) => const SavedScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.postListing,
        builder: (context, state) => const PostListingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.listingDetail,
        builder: (context, state) {
          final extraListing = state.extra as ListingEntity?;
          final id = state.uri.queryParameters['id'];
          return ListingDetailScreen(
            listing: extraListing,
            listingId: id,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}
