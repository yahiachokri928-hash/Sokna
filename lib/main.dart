import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/strings/messages.dart';
import 'core/themes/theme_manager.dart';
import 'features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'features/auth/presentation/blocs/register/register_bloc.dart';
import 'features/favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import 'features/listings/presentation/blocs/listings/listings_bloc.dart';
import 'features/listings/presentation/blocs/theme/switchtheme_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Allows offline and desktop/mock execution when Firebase is not provisioned
  }

  await initServiceLocator();

  runApp(const SoknaApp());
}

class SoknaApp extends StatelessWidget {
  const SoknaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ListingsBloc>(
          create: (_) => sl<ListingsBloc>()..add(const GetListingsEvent()),
        ),
        BlocProvider<SavedListingsBloc>(
          create: (_) => sl<SavedListingsBloc>()..add(const LoadSavedListingsEvent()),
        ),
        BlocProvider<SwitchthemeBloc>(
          create: (_) => sl<SwitchthemeBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => sl<RegisterBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthenticatedState || current is UnAuthenticatedState,
        listener: (context, state) {
          context.read<SavedListingsBloc>().add(const LoadSavedListingsEvent());
        },
        child: BlocBuilder<SwitchthemeBloc, SwitchthemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: APP_TITLE,
              debugShowCheckedModeBanner: false,
              theme: ThemeManager.lightTheme,
              darkTheme: ThemeManager.darkTheme,
              themeMode: state.themeMode,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
