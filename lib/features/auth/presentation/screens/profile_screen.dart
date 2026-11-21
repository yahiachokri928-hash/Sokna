import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/firebase/firestore_cloud_seeder.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import '../../../listings/domain/entities/listing_entity.dart';
import '../../../listings/presentation/blocs/listings/listings_bloc.dart';
import '../../../listings/presentation/blocs/theme/switchtheme_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDemoExpanded = true;
  String? _loggingInEmail;

  void _confirmDeleteListing(BuildContext context, ListingEntity listing) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text(LISTING_DELETE_CONFIRM_TITLE),
        content: const Text(LISTING_DELETE_CONFIRM_MESSAGE),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(ACTION_CANCEL),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () {
              context.read<ListingsBloc>().add(DeleteListingEvent(listing.id));
              Navigator.pop(dialogCtx);
              SnackBarMessage.showSuccessSnackBar(
                context: context,
                message: LISTING_DELETE_SUCCESS,
              );
            },
            child: const Text(ACTION_CONFIRM),
          ),
        ],
      ),
    );
  }

  void _loginAsDemoAccount(BuildContext ctx, TunisianDemoAccount account) {
    setState(() => _loggingInEmail = account.email);
    ctx.read<AuthBloc>().add(
          LoginEvent(
            email: account.email,
            password: account.password,
          ),
        );
  }

  void _showEditProfileModal(BuildContext context, UserEntity currentUser) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: currentUser.name ?? '');
    final phoneController = TextEditingController(text: currentUser.phone ?? '');
    String selectedRole = currentUser.role.isNotEmpty ? currentUser.role : AUTH_ROLE_TENANT;

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
                        decoration: InputDecoration(
                          labelText: AUTH_FIELD_NAME,
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
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
                        decoration: InputDecoration(
                          labelText: AUTH_FIELD_PHONE,
                          hintText: AUTH_FIELD_PHONE_HINT,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: InputDecoration(
                          labelText: AUTH_FIELD_ROLE,
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: AUTH_ROLE_TENANT,
                            child: Text(AUTH_ROLE_TENANT),
                          ),
                          DropdownMenuItem(
                            value: AUTH_ROLE_LANDLORD,
                            child: Text(AUTH_ROLE_LANDLORD),
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
                                if (formKey.currentState?.validate() ?? false) {
                                  final updatedUser = UserEntity(
                                    uid: currentUser.uid,
                                    name: nameController.text.trim(),
                                    email: currentUser.email,
                                    profilURL: currentUser.profilURL,
                                    phone: phoneController.text.trim(),
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState && _loggingInEmail != null) {
            setState(() => _loggingInEmail = null);
            SnackBarMessage.showSuccessSnackBar(
              context: context,
              message: PROFILE_DEMO_LOGIN_SUCCESS,
            );
          } else if (state is AuthErrorState && _loggingInEmail != null) {
            setState(() => _loggingInEmail = null);
            SnackBarMessage.showErrorSnackBar(
              context: context,
              message: state.message,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthenticatedState) {
                return _buildAuthenticatedProfile(context, theme, state.user);
              }
              return _buildGuestProfile(context, theme);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Guest Avatar & Features Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36.0,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 44.0,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 14.0),
                Text(
                  PROFILE_GUEST_TITLE,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  PROFILE_GUEST_SUBTITLE,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Checklist of member features
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureRow(theme, PROFILE_GUEST_FEATURE_FAVORITES),
                      const SizedBox(height: 10.0),
                      _buildFeatureRow(theme, PROFILE_GUEST_FEATURE_POST),
                      const SizedBox(height: 10.0),
                      _buildFeatureRow(theme, PROFILE_GUEST_FEATURE_REVIEWS),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.login),
                  icon: const Icon(Icons.login_rounded, size: 20.0),
                  label: const Text(AUTH_LOGIN_BUTTON),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.register),
                  icon: const Icon(Icons.person_add_outlined, size: 20.0),
                  label: const Text(AUTH_CREATE_ACCOUNT_BUTTON),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16.0),

        // Read-Only Tunisian Test Accounts Selector for APK Testers
        _buildDemoAccountsCard(context, theme),

        const SizedBox(height: 12.0),

        // Theme Switcher Card
        _buildThemeCard(theme),

        const SizedBox(height: 12.0),

        // Academic Info Card
        _buildAcademicCard(theme),
      ],
    );
  }

  Widget _buildFeatureRow(ThemeData theme, String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 18.0,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoAccountsCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isDemoExpanded,
          onExpansionChanged: (expanded) {
            setState(() => _isDemoExpanded = expanded);
          },
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.switch_account_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          title: Text(
            PROFILE_DEMO_ACCOUNTS_EXPANSION_TITLE,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          subtitle: Text(
            PROFILE_DEMO_ACCOUNTS_EXPANSION_SUBTITLE,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          children: [
            const Divider(height: 16.0),
            // Landlords Header
            Row(
              children: [
                const Icon(Icons.home_work_rounded, size: 16.0),
                const SizedBox(width: 6.0),
                Text(
                  PROFILE_DEMO_OWNERS_SECTION,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...FirestoreCloudSeeder.demoLandlords.map(
              (account) => _buildDemoAccountTile(context, theme, account),
            ),
            const Divider(height: 24.0),
            // Tenants Header
            Row(
              children: [
                const Icon(Icons.person_rounded, size: 16.0),
                const SizedBox(width: 6.0),
                Text(
                  PROFILE_DEMO_TENANTS_SECTION,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...FirestoreCloudSeeder.demoTenants.map(
              (account) => _buildDemoAccountTile(context, theme, account),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoAccountTile(
    BuildContext context,
    ThemeData theme,
    TunisianDemoAccount account,
  ) {
    final isCurrent = _loggingInEmail == account.email;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16.0,
        backgroundImage: NetworkImage(account.avatarUrl),
        onBackgroundImageError: (_, _) {},
        backgroundColor: theme.colorScheme.primaryContainer,
        child: (account.avatarUrl.isEmpty)
            ? Text(
                account.name.isNotEmpty ? account.name[0] : 'U',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              )
            : null,
      ),
      title: Text(
        account.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(account.subtitle),
      trailing: ElevatedButton(
        onPressed: _loggingInEmail != null ? null : () => _loginAsDemoAccount(context, account),
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
        ),
        child: isCurrent
            ? const SizedBox(
                width: 14.0,
                height: 14.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              )
            : const Text(AUTH_LOGIN_BUTTON),
      ),
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context, ThemeData theme, UserEntity user) {
    final userName = (user.name != null && user.name!.isNotEmpty) ? user.name! : 'Utilisateur';
    final userEmail = (user.email != null && user.email!.isNotEmpty) ? user.email! : '';
    final userRole = user.role.isNotEmpty ? user.role : AUTH_ROLE_TENANT;
    final userPhone = (user.phone != null && user.phone!.isNotEmpty) ? user.phone! : AUTH_NO_PHONE;
    final membershipText = user.createdAt != null
        ? '$AUTH_MEMBER_SINCE ${user.createdAt!.year}'
        : AUTH_MEMBERSHIP_DATE;

    return Column(
      children: [
        // User Header Card
        Card(
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
                  backgroundImage: (user.profilURL != null && user.profilURL!.isNotEmpty)
                      ? NetworkImage(user.profilURL!)
                      : null,
                  onBackgroundImageError: (_, _) {},
                  child: (user.profilURL == null || user.profilURL!.isEmpty)
                      ? Text(
                          userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : null,
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
                    const Chip(
                      avatar: Icon(Icons.verified_user_rounded, size: 16.0),
                      label: Text(AUTH_STATUS_VERIFIED),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                  onPressed: () => _showEditProfileModal(context, user),
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
              ],
            ),
          ),
        ),

        const SizedBox(height: 16.0),

        // My Published Listings Card
        _buildMyListingsCard(context, theme, user.uid),

        const SizedBox(height: 12.0),

        // Saved Listings Card
        _buildSavedListingsCard(context, theme),

        const SizedBox(height: 12.0),

        // Theme Switcher Card
        _buildThemeCard(theme),

        const SizedBox(height: 12.0),

        // Academic Info Card
        _buildAcademicCard(theme),
      ],
    );
  }

  Widget _buildMyListingsCard(BuildContext context, ThemeData theme, String? uid) {
    if (uid == null) return const SizedBox.shrink();

    return BlocBuilder<ListingsBloc, ListingsState>(
      builder: (context, listingsState) {
        final myListings = listingsState is ListingsLoaded
            ? listingsState.allListings.where((item) => item.ownerId == uid).toList()
            : <ListingEntity>[];

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.home_work_outlined,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        PROFILE_MY_LISTINGS_TITLE,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Badge.count(
                      count: myListings.length,
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                if (myListings.isEmpty) ...[
                  Text(
                    PROFILE_NO_LISTINGS,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.postListing),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text(PROFILE_PUBLISH_FIRST_LISTING),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44.0),
                    ),
                  ),
                ] else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myListings.length,
                    separatorBuilder: (context, index) => const Divider(height: 16.0),
                    itemBuilder: (context, index) {
                      final item = myListings[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            item.imagePath,
                            width: 56.0,
                            height: 56.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 56.0,
                              height: 56.0,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.image_not_supported_rounded),
                            ),
                          ),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${item.city} • ${item.price} TND / mois',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: theme.colorScheme.error,
                          ),
                          tooltip: LISTING_DELETE_BUTTON,
                          onPressed: () => _confirmDeleteListing(context, item),
                        ),
                        onTap: () => context.push(
                          AppRoutes.listingDetail,
                          extra: item,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedListingsCard(BuildContext context, ThemeData theme) {
    return Card(
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
    );
  }

  Widget _buildThemeCard(ThemeData theme) {
    return Card(
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
    );
  }

  Widget _buildAcademicCard(ThemeData theme) {
    return Card(
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
    );
  }
}
