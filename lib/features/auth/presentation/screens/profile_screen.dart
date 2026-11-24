import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/image_encoding_helper.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../../core/widgets/sokna_logo.dart';
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

  Future<void> _pickAndUploadAvatar(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 320,
        maxHeight: 320,
        imageQuality: 70,
      );

      if (picked == null || !mounted) return;

      context.read<AuthBloc>().add(UpdateUserAvatarEvent(File(picked.path)));

      SnackBarMessage.showSuccessSnackBar(
        context: context,
        message: PROFILE_AVATAR_UPDATE_SUCCESS,
      );
    } catch (_) {
      if (mounted) {
        SnackBarMessage.showErrorSnackBar(
          context: context,
          message: PROFILE_UPDATE_FAILURE_MESSAGE,
        );
      }
    }
  }

  void _showAvatarPickerSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  PROFILE_AVATAR_SHEET_TITLE,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.camera_alt_rounded, color: theme.colorScheme.primary),
                  ),
                  title: const Text(PROFILE_AVATAR_TAKE_PHOTO),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickAndUploadAvatar(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.photo_library_rounded, color: theme.colorScheme.primary),
                  ),
                  title: const Text(PROFILE_AVATAR_CHOOSE_GALLERY),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickAndUploadAvatar(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
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
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              return _buildAuthenticatedProfile(context, theme, state.user);
            }
            return _buildGuestProfile(context, theme);
          },
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
                const SoknaLogo(),
                const SizedBox(height: 16.0),
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
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 44.0,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      backgroundImage: ImageEncodingHelper.getAvatarImageProvider(user.profilURL),
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        color: theme.colorScheme.primary,
                        shape: const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _showAvatarPickerSheet(),
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 18.0,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
