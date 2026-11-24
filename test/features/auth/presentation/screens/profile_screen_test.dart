import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/features/auth/domain/entities/user_entity.dart';
import 'package:sokna/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sokna/features/auth/presentation/screens/profile_screen.dart';
import 'package:sokna/features/favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import 'package:sokna/features/listings/presentation/blocs/listings/listings_bloc.dart';
import 'package:sokna/features/listings/presentation/blocs/theme/switchtheme_bloc.dart';

class MockAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  MockAuthBloc(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockListingsBloc extends Bloc<ListingsEvent, ListingsState> implements ListingsBloc {
  MockListingsBloc(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockSavedListingsBloc extends Bloc<SavedListingsEvent, SavedListingsState> implements SavedListingsBloc {
  MockSavedListingsBloc(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('ProfileScreen renders clean Mode Invité view without demo accounts when unauthenticated', (tester) async {
    final mockAuthBloc = MockAuthBloc(UnAuthenticatedState());
    final switchThemeBloc = SwitchthemeBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            BlocProvider<SwitchthemeBloc>.value(value: switchThemeBloc),
          ],
          child: const ProfileScreen(),
        ),
      ),
    );

    expect(find.text(PROFILE_GUEST_TITLE), findsOneWidget);
    expect(find.text(PROFILE_GUEST_SUBTITLE), findsOneWidget);
    expect(find.text(PROFILE_GUEST_FEATURE_FAVORITES), findsOneWidget);
    expect(find.text(PROFILE_GUEST_FEATURE_POST), findsOneWidget);
    expect(find.text(PROFILE_GUEST_FEATURE_REVIEWS), findsOneWidget);
    expect(find.text(AUTH_LOGIN_BUTTON), findsOneWidget);
    expect(find.text(AUTH_CREATE_ACCOUNT_BUTTON), findsOneWidget);

    // Verify demo quick-login expansion tile is not present
    expect(find.byType(ExpansionTile), findsNothing);
  });

  testWidgets('ProfileScreen renders authenticated profile with camera edit badge and opens sheet', (tester) async {
    const testUser = UserEntity(
      uid: 'user_authenticated',
      name: 'Youssef Gharbi',
      email: 'youssef.gharbi@sokna.tn',
      role: 'Propriétaire',
      phone: '+216 50 345 678',
      profilURL: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
    );

    final mockAuthBloc = MockAuthBloc(const AuthenticatedState(user: testUser));
    final mockListingsBloc = MockListingsBloc(const ListingsLoaded(allListings: [], filteredListings: []));
    final mockSavedBloc = MockSavedListingsBloc(const SavedListingsLoaded(savedIds: []));
    final switchThemeBloc = SwitchthemeBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: mockAuthBloc),
            BlocProvider<ListingsBloc>.value(value: mockListingsBloc),
            BlocProvider<SavedListingsBloc>.value(value: mockSavedBloc),
            BlocProvider<SwitchthemeBloc>.value(value: switchThemeBloc),
          ],
          child: const ProfileScreen(),
        ),
      ),
    );

    expect(find.text('Youssef Gharbi'), findsOneWidget);
    expect(find.text('youssef.gharbi@sokna.tn'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);

    // Tap camera edit badge to open modal bottom sheet
    await tester.tap(find.byIcon(Icons.camera_alt_rounded));
    await tester.pumpAndSettle();

    expect(find.text(PROFILE_AVATAR_SHEET_TITLE), findsOneWidget);
    expect(find.text(PROFILE_AVATAR_TAKE_PHOTO), findsOneWidget);
    expect(find.text(PROFILE_AVATAR_CHOOSE_GALLERY), findsOneWidget);
  });
}
