import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/core/widgets/sokna_logo.dart';
import 'package:sokna/features/auth/domain/entities/user_entity.dart';
import 'package:sokna/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sokna/features/favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import 'package:sokna/features/listings/presentation/blocs/listings/listings_bloc.dart';
import 'package:sokna/features/listings/presentation/blocs/theme/switchtheme_bloc.dart';
import 'package:sokna/features/listings/presentation/screens/home_screen.dart';

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
  testWidgets('HomeScreen displays SoknaLogo in AppBar and guest greeting when unauthenticated', (tester) async {
    final authBloc = MockAuthBloc(UnAuthenticatedState());
    final listingsBloc = MockListingsBloc(const ListingsLoaded(
      allListings: [],
      filteredListings: [],
      selectedCategory: CATEGORY_ALL,
    ));
    final savedBloc = MockSavedListingsBloc(const SavedListingsLoaded(savedIds: []));
    final themeBloc = SwitchthemeBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<ListingsBloc>.value(value: listingsBloc),
            BlocProvider<SavedListingsBloc>.value(value: savedBloc),
            BlocProvider<SwitchthemeBloc>.value(value: themeBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    // Verify compact SoknaLogo in AppBar
    expect(find.byType(SoknaLogo), findsOneWidget);
    // Verify guest greeting
    expect(find.text(HOME_GUEST_GREETING), findsOneWidget);
    expect(find.text(HOME_GREETING_TITLE), findsOneWidget);
  });

  testWidgets('HomeScreen displays dynamic user name and role badge when authenticated', (tester) async {
    const testUser = UserEntity(
      uid: 'user_001',
      name: 'Salma Trabelsi',
      email: 'salma.trabelsi@sokna.tn',
      role: 'Propriétaire',
    );
    final authBloc = MockAuthBloc(const AuthenticatedState(user: testUser));
    final listingsBloc = MockListingsBloc(const ListingsLoaded(
      allListings: [],
      filteredListings: [],
      selectedCategory: CATEGORY_ALL,
    ));
    final savedBloc = MockSavedListingsBloc(const SavedListingsLoaded(savedIds: []));
    final themeBloc = SwitchthemeBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<ListingsBloc>.value(value: listingsBloc),
            BlocProvider<SavedListingsBloc>.value(value: savedBloc),
            BlocProvider<SwitchthemeBloc>.value(value: themeBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    // Verify dynamic greeting with user's name
    expect(find.text('Bonjour, Salma Trabelsi 👋'), findsOneWidget);
    // Verify role badge
    expect(find.text('Propriétaire'), findsOneWidget);
  });
}
