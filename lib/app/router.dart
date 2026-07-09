import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/core/widgets/app_top_left_actions.dart';
import 'package:booksphere_app/features/auth/data/auth_session_service.dart';
import 'package:booksphere_app/features/auth/presentation/login_screen.dart';
import 'package:booksphere_app/features/auth/presentation/register_screen.dart';
import 'package:booksphere_app/features/auth/presentation/splash_screen.dart';
import 'package:booksphere_app/features/auth/presentation/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
}

final _authSessionService = AuthSessionService(
  secureStorageService: SecureStorageService(),
  dioClient: DioClient(),
);

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.main,
      builder: (context, state) => const MainPlaceholderScreen(),
    ),
  ],
  redirect: (context, state) async {
    final matchedLocation = state.matchedLocation;

    if (matchedLocation == AppRoutes.splash) {
      return null;
    }

    if (matchedLocation == AppRoutes.login ||
        matchedLocation == AppRoutes.register ||
        matchedLocation == AppRoutes.main) {
      final status = await _authSessionService.checkSession();
      if (status == AuthSessionStatus.authenticated) {
        return matchedLocation == AppRoutes.login ||
                matchedLocation == AppRoutes.register
            ? AppRoutes.main
            : null;
      }
      return matchedLocation == AppRoutes.main ? AppRoutes.login : null;
    }

    return null;
  },
);

class MainPlaceholderScreen extends StatelessWidget {
  const MainPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.mainScreenPlaceholder,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const LogoutButton(),
                    ],
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
