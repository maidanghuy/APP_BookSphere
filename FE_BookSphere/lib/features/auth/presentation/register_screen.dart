import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/core/widgets/app_top_left_actions.dart';
import 'package:booksphere_app/features/auth/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _obscurePassword = true;
  var _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();
    final didRegister = await ref
        .read(registerControllerProvider.notifier)
        .register(
          fullName: _fullNameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted || !didRegister) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.registerSuccess)));
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerControllerProvider);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final errorMessage = registerState.errorCode == null
        ? null
        : ErrorMessageMapper.mapCode(
            context,
            registerState.errorCode,
            statusCode: registerState.errorStatusCode,
          );

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.appName,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.createAccount,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _fullNameController,
                          enabled: !registerState.isLoading,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          decoration: InputDecoration(
                            labelText: l10n.fullName,
                            prefixIcon: const Icon(Icons.badge_outlined),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.fullNameRequired;
                            }

                            return null;
                          },
                          onChanged: (_) => _clearError(registerState),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _usernameController,
                          enabled: !registerState.isLoading,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          decoration: InputDecoration(
                            labelText: l10n.username,
                            prefixIcon: const Icon(Icons.person_outline),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.usernameRequired;
                            }

                            return null;
                          },
                          onChanged: (_) => _clearError(registerState),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          enabled: !registerState.isLoading,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: l10n.email,
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) {
                              return l10n.emailRequired;
                            }
                            if (!_isValidEmail(email)) {
                              return l10n.invalidEmail;
                            }

                            return null;
                          },
                          onChanged: (_) => _clearError(registerState),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          enabled: !registerState.isLoading,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          decoration: InputDecoration(
                            labelText: l10n.phone,
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final phone = value?.trim() ?? '';
                            if (phone.isEmpty) {
                              return l10n.phoneRequired;
                            }
                            if (!_isValidPhone(phone)) {
                              return l10n.invalidPhone;
                            }

                            return null;
                          },
                          onChanged: (_) => _clearError(registerState),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !registerState.isLoading,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            labelText: l10n.password,
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? l10n.showPassword
                                  : l10n.hidePassword,
                              onPressed: registerState.isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            final password = value ?? '';
                            if (password.isEmpty) {
                              return l10n.passwordRequired;
                            }
                            if (password.length < 6) {
                              return l10n.passwordMinLength;
                            }

                            return null;
                          },
                          onChanged: (_) => _clearError(registerState),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          enabled: !registerState.isLoading,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                          onFieldSubmitted: (_) {
                            if (!registerState.isLoading) {
                              _submit();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: l10n.confirmPassword,
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              tooltip: _obscureConfirmPassword
                                  ? l10n.showPassword
                                  : l10n.hidePassword,
                              onPressed: registerState.isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            final confirmPassword = value ?? '';
                            if (confirmPassword.isEmpty) {
                              return l10n.confirmPasswordRequired;
                            }
                            if (confirmPassword != _passwordController.text) {
                              return l10n.confirmPasswordNotMatch;
                            }

                            return null;
                          },
                          onChanged: (_) => _clearError(registerState),
                        ),
                        if (errorMessage != null) ...[
                          const SizedBox(height: 16),
                          _RegisterErrorMessage(message: errorMessage),
                        ],
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: registerState.isLoading ? null : _submit,
                          icon: registerState.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.person_add_alt_1),
                          label: Text(l10n.register),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(l10n.alreadyHaveAccount),
                            TextButton(
                              onPressed: registerState.isLoading
                                  ? null
                                  : () => context.go('/login'),
                              child: Text(l10n.goToLogin),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const AppTopLeftActions(),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?\d{9,15}$').hasMatch(phone);
  }

  void _clearError(RegisterState registerState) {
    if (registerState.errorCode != null) {
      ref.read(registerControllerProvider.notifier).clearError();
    }
  }
}

class _RegisterErrorMessage extends StatelessWidget {
  const _RegisterErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
