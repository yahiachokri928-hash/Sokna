import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import '../../../listings/presentation/blocs/theme/switchtheme_bloc.dart';
import '../blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AUTH_PROFILE_TITLE),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Header Card (Dynamic Auth state)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isAuthenticated = state is AuthenticatedState;
                final userName = isAuthenticated &&
                        state.user.name != null &&
                        state.user.name!.isNotEmpty
                    ? state.user.name!
                    : 'Yahia Chokri';
                final userEmail = isAuthenticated &&
                        state.user.email != null &&
                        state.user.email!.isNotEmpty
                    ? state.user.email!
                    : 'yahia.chokri@isetbizerte.tn';

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            userName.isNotEmpty
                                ? userName.substring(0, 1).toUpperCase()
                                : 'Y',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        Text(
                          userName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          userEmail,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.verified_user_rounded, size: 16.0),
                              label: Text(
                                isAuthenticated
                                    ? AUTH_STATUS_VERIFIED
                                    : '$AUTH_ROLE_TENANT / $AUTH_ROLE_LANDLORD',
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            const Chip(
                              avatar: Icon(Icons.calendar_today_rounded, size: 16.0),
                              label: Text(AUTH_MEMBERSHIP_DATE),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        if (isAuthenticated)
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<AuthBloc>().add(const LogoutEvent());
                              SnackBarMessage.showSuccessSnackBar(
                                context: context,
                                message: AUTH_LOGOUT_SUCCESS,
                              );
                            },
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text(AUTH_LOGOUT_BUTTON),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48.0),
                              foregroundColor: theme.colorScheme.error,
                              side: BorderSide(color: theme.colorScheme.error),
                            ),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => context.push(AppRoutes.login),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48.0),
                                  ),
                                  child: const Text(AUTH_LOGIN_BUTTON),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => context.push(AppRoutes.register),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48.0),
                                  ),
                                  child: const Text(AUTH_REGISTER_BUTTON),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16.0),

            // Saved Listings Card (Connected to SavedListingsBloc)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: BlocBuilder<SavedListingsBloc, SavedListingsState>(
                builder: (context, state) {
                  final count = state is SavedListingsLoaded ? state.count : 0;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.favorite_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: const Text(SAVED_APP_BAR_TITLE),
                    subtitle: Text('$count $SEARCH_RESULTS_SUFFIX'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16.0),
                    onTap: () => context.go(AppRoutes.saved),
                  );
                },
              ),
            ),

            const SizedBox(height: 12.0),

            // Theme Switcher Card (Connected to SwitchthemeBloc)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: BlocBuilder<SwitchthemeBloc, SwitchthemeState>(
                builder: (context, state) {
                  final isDark = state.themeMode == ThemeMode.dark;
                  return SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 4.0,
                    ),
                    secondary: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: const Text(THEME_TOGGLE_TOOLTIP),
                    subtitle: Text(isDark ? 'Mode sombre' : 'Mode clair'),
                    value: isDark,
                    onChanged: (val) {
                      context.read<SwitchthemeBloc>().add(const ToggleThemeEvent());
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12.0),

            // Academic Info Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.school_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$APP_TITLE v1.0.0',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'ISET Bizerte — DSI 3 • Yahia Chokri',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
