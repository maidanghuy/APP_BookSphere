import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/core/widgets/app_top_left_actions.dart';
import 'package:booksphere_app/core/widgets/app_loading_button.dart';
import 'package:booksphere_app/features/auth/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();
    final didLogin = await ref
        .read(loginControllerProvider.notifier)
        .login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted || !didLogin) {
      return;
    }

    context.go('/main');
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final errorMessage = loginState.errorCode == null
        ? null
        : ErrorMessageMapper.mapCode(
            context,
            loginState.errorCode,
            statusCode: loginState.errorStatusCode,
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
                          l10n.welcomeBack,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _usernameController,
                          enabled: !loginState.isLoading,
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
                          onChanged: (_) {
                            if (loginState.errorCode != null) {
                              ref
                                  .read(loginControllerProvider.notifier)
                                  .clearError();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !loginState.isLoading,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) {
                            if (!loginState.isLoading) {
                              _submit();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: l10n.password,
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? l10n.showPassword
                                  : l10n.hidePassword,
                              onPressed: loginState.isLoading
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
                            if (value == null || value.isEmpty) {
                              return l10n.passwordRequired;
                            }

                            return null;
                          },
                          onChanged: (_) {
                            if (loginState.errorCode != null) {
                              ref
                                  .read(loginControllerProvider.notifier)
                                  .clearError();
                            }
                          },
                        ),
                        if (errorMessage != null) ...[
                          const SizedBox(height: 16),
                          _LoginErrorMessage(message: errorMessage),
                        ],
                        const SizedBox(height: 24),
                        AppLoadingButton(
                          label: l10n.login,
                          icon: Icons.login,
                          isLoading: loginState.isLoading,
                          onPressed: loginState.isLoading ? null : _submit,
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: loginState.isLoading
                              ? null
                              : () => context.go('/register'),
                          icon: const Icon(Icons.person_add_alt_1),
                          label: Text(l10n.createAccount),
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
}

class _LoginErrorMessage extends StatelessWidget {
  const _LoginErrorMessage({required this.message});

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
