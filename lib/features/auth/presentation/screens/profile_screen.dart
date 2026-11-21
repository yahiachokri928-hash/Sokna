import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import '../../../listings/presentation/blocs/theme/switchtheme_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileModal(BuildContext context, UserEntity currentUser) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: currentUser.name ?? '');
    final phoneController =
        TextEditingController(text: currentUser.phone ?? '');
    String selectedRole = currentUser.role.isNotEmpty
        ? currentUser.role
        : AUTH_ROLE_TENANT;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20.0,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40.0,
                          height: 4.0,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        AUTH_EDIT_PROFILE_TITLE,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: AUTH_FIELD_NAME,
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return VALIDATION_REQUIRED;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: AUTH_FIELD_PHONE,
                          hintText: AUTH_FIELD_PHONE_HINT,
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: AUTH_FIELD_ROLE,
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: AUTH_ROLE_TENANT,
                            child: Text(AUTH_ROLE_TENANT),
                          ),
                          DropdownMenuItem(
                            value: AUTH_ROLE_OWNER,
                            child: Text(AUTH_ROLE_OWNER),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedRole = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(modalContext),
                              child: const Text(ACTION_CANCEL),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  final updatedUser = UserEntity(
                                    uid: currentUser.uid,
                                    name: nameController.text.trim(),
                                    email: currentUser.email,
                                    profilURL: currentUser.profilURL,
                                    phone: phoneController.text.trim().isNotEmpty
                                        ? phoneController.text.trim()
                                        : null,
                                    role: selectedRole,
                                    createdAt: currentUser.createdAt,
                                  );

                                  context.read<AuthBloc>().add(
                                        UpdateUserProfileEvent(updatedUser),
                                      );

                                  Navigator.pop(modalContext);

                                  SnackBarMessage.showSuccessSnackBar(
                                    context: context,
                                    message: AUTH_PROFILE_UPDATE_SUCCESS,
                                  );
                                }
                              },
                              child: const Text(AUTH_SAVE_PROFILE_BUTTON),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

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
                final user = isAuthenticated ? state.user : null;
                final userName = isAuthenticated &&
                        user?.name != null &&
                        user!.name!.isNotEmpty
                    ? user.name!
                    : 'Yahia Chokri';
                final userEmail = isAuthenticated &&
                        user?.email != null &&
                        user!.email!.isNotEmpty
                    ? user.email!
                    : 'yahia.chokri@isetbizerte.tn';
                final userRole = isAuthenticated && user != null
                    ? user.role
                    : '$AUTH_ROLE_TENANT / $AUTH_ROLE_LANDLORD';
                final userPhone = isAuthenticated &&
                        user?.phone != null &&
                        user!.phone!.isNotEmpty
                    ? user.phone!
                    : AUTH_NO_PHONE;
                final membershipText = isAuthenticated && user?.createdAt != null
                    ? '$AUTH_MEMBER_SINCE ${user!.createdAt!.year}'
                    : AUTH_MEMBERSHIP_DATE;

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
                          runSpacing: 8.0,
                          alignment: WrapAlignment.center,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.badge_outlined, size: 16.0),
                              label: Text(userRole),
                              visualDensity: VisualDensity.compact,
                            ),
                            if (isAuthenticated)
                              Chip(
                                avatar: const Icon(Icons.phone_outlined, size: 16.0),
                                label: Text(userPhone),
                                visualDensity: VisualDensity.compact,
                              ),
                            Chip(
                              avatar: const Icon(Icons.calendar_today_rounded, size: 16.0),
                              label: Text(membershipText),
                              visualDensity: VisualDensity.compact,
                            ),
                            if (isAuthenticated)
                              const Chip(
                                avatar: Icon(Icons.verified_user_rounded, size: 16.0),
                                label: Text(AUTH_STATUS_VERIFIED),
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        if (isAuthenticated) ...[
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showEditProfileModal(context, state.user),
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text(AUTH_EDIT_PROFILE_BUTTON),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48.0),
                            ),
                          ),
                          const SizedBox(height: 10.0),
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
                          ),
                        ] else
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      context.push(AppRoutes.login),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48.0),
                                  ),
                                  child: const Text(AUTH_LOGIN_BUTTON),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      context.push(AppRoutes.register),
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
