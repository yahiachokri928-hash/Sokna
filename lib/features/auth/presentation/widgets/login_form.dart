import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:validators/validators.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
import '../blocs/auth/auth_bloc.dart';
import 'auth_btn.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: AUTH_FIELD_EMAIL,
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return VALIDATION_REQUIRED;
              }
              if (!isEmail(value.trim())) {
                return AUTH_INVALID_EMAIL_MESSAGE;
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: AUTH_FIELD_PASSWORD,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return VALIDATION_REQUIRED;
              }
              if (value.trim().length < 6) {
                return AUTH_WEAK_PASSWORD_MESSAGE;
              }
              return null;
            },
          ),
          const SizedBox(height: 24.0),

          // Submit Button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is LoginPendingState;
              return AuthButton(
                text: AUTH_LOGIN_BUTTON,
                isLoading: isLoading,
                onPressed: _submit,
              );
            },
          ),
          const SizedBox(height: 16.0),

          // Navigation to Register
          Center(
            child: TextButton(
              onPressed: () {
                context.push(AppRoutes.register);
              },
              child: Text(
                AUTH_NO_ACCOUNT,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
