import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/data/auth_session_service.dart';
import 'package:booksphere_app/features/auth/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
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
      builder: (context, state) => const LoginPlaceholderScreen(),
    ),
    GoRoute(
      path: AppRoutes.main,
      builder: (context, state) => const MainPlaceholderScreen(),
    ),
  ],
  redirect: (context, state) async {
    final matchedLocation = state.matchedLocation;

    if (matchedLocation == AppRoutes.splash ||
        matchedLocation == AppRoutes.login) {
      return null;
    }

    if (matchedLocation == AppRoutes.main) {
      final status = await _authSessionService.checkSession();
      if (status == AuthSessionStatus.authenticated) {
        return null;
      }
      return AppRoutes.login;
    }

    return null;
  },
);

class LoginPlaceholderScreen extends StatelessWidget {
  const LoginPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Login Screen will be implemented in BS-APP-07',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MainPlaceholderScreen extends StatelessWidget {
  const MainPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Main Tab Screen will be implemented in BS-APP-10',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
