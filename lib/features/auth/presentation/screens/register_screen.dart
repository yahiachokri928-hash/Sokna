import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../../core/widgets/sokna_logo.dart';
import '../blocs/register/register_bloc.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AUTH_REGISTER_TITLE),
      ),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterUserFailState) {
            SnackBarMessage.showErrorSnackBar(
              context: context,
              message: state.message,
            );
          } else if (state is RegisterUserSuccessState) {
            SnackBarMessage.showSuccessSnackBar(
              context: context,
              message: AUTH_REGISTER_SUCCESS,
            );
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16.0),
                const Center(child: SoknaLogo()),
                const SizedBox(height: 24.0),
                Text(
                  AUTH_REGISTER_TITLE,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  AUTH_REGISTER_SUBTITLE,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32.0),
                const RegisterForm(),
              ],
            ),
          );
        },
      ),
    );
  }
}
