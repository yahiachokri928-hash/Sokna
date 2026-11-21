import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/core/widgets/guest_auth_prompt.dart';
import 'package:sokna/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:sokna/features/listings/presentation/screens/post_listing_screen.dart';

class MockAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  MockAuthBloc(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('PostListingScreen renders GuestAuthPrompt when in unauthenticated guest mode', (tester) async {
    final mockAuthBloc = MockAuthBloc(UnAuthenticatedState());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const PostListingScreen(),
        ),
      ),
    );

    expect(find.byType(GuestAuthPrompt), findsOneWidget);
    expect(find.text(GUEST_POST_TITLE), findsOneWidget);
    expect(find.text(GUEST_POST_SUBTITLE), findsOneWidget);
    expect(find.text(AUTH_LOGIN_BUTTON), findsOneWidget);
    expect(find.text(AUTH_CREATE_ACCOUNT_BUTTON), findsOneWidget);
  });
}
