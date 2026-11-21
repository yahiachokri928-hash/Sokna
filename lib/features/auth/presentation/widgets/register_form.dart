import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:validators/validators.dart';

import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
import '../../domain/entities/user_entity.dart';
import '../blocs/register/register_bloc.dart';
import 'auth_btn.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = AUTH_ROLE_TENANT;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
            RegisterUserEvent(
              UserEntity(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
                phone: _phoneController.text.trim().isNotEmpty
                    ? _phoneController.text.trim()
                    : null,
                role: _selectedRole,
              ),
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
          // Full Name
          TextFormField(
            controller: _nameController,
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

          // Email
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

          // Phone (optional)
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: AUTH_FIELD_PHONE,
              hintText: AUTH_FIELD_PHONE_HINT,
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 16.0),

          // Role dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedRole,
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
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedRole = value;
                });
              }
            },
          ),
          const SizedBox(height: 16.0),

          // Password
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
              if (!isLength(value.trim(), 6)) {
                return AUTH_WEAK_PASSWORD_MESSAGE;
              }
              return null;
            },
          ),
          const SizedBox(height: 24.0),

          // Submit Button
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              final isLoading = state is RegisterPendingState;
              return AuthButton(
                text: AUTH_REGISTER_BUTTON,
                isLoading: isLoading,
                onPressed: _submit,
              );
            },
          ),
          const SizedBox(height: 16.0),

          // Navigation to Login
          Center(
            child: TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                AUTH_HAVE_ACCOUNT,
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
