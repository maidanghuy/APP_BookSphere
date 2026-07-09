import 'package:booksphere_app/core/config/app_config.dart';
import 'package:booksphere_app/features/auth/data/auth_session_service.dart';
import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  var _hasConnectionError = false;
  var _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    if (mounted) {
      setState(() {
        _hasConnectionError = false;
        _isCheckingSession = true;
      });
    }

    final sessionService = ref.read(authSessionServiceProvider);
    final status = await sessionService.checkSession();

    if (!mounted) {
      return;
    }

    switch (status) {
      case AuthSessionStatus.authenticated:
        context.go('/main');
      case AuthSessionStatus.unauthenticated:
        context.go('/login');
      case AuthSessionStatus.connectionError:
        setState(() {
          _hasConnectionError = true;
          _isCheckingSession = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppConfig.appName,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                if (_isCheckingSession) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Checking session...'),
                ] else if (_hasConnectionError) ...[
                  const Icon(Icons.wifi_off, size: 40),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to connect to the server. Please try again.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _checkSession,
                    child: const Text('Try again'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
