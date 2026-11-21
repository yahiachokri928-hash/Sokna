import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sokna/features/auth/presentation/screens/profile_screen.dart';
import 'package:sokna/features/listings/presentation/blocs/theme/switchtheme_bloc.dart';

class MockAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  MockAuthBloc(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('ProfileScreen renders Mode Invité and Tunisian demo accounts when in unauthenticated guest mode', (tester) async {
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
    expect(find.text(PROFILE_DEMO_ACCOUNTS_EXPANSION_TITLE), findsOneWidget);
  });
}
