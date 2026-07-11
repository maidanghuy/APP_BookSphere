import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/data/auth_session_service.dart';
import 'package:booksphere_app/features/auth/presentation/login_screen.dart';
import 'package:booksphere_app/features/auth/presentation/register_screen.dart';
import 'package:booksphere_app/features/auth/presentation/splash_screen.dart';
import 'package:booksphere_app/features/borrows/presentation/borrow_create_screen.dart';
import 'package:booksphere_app/features/home/presentation/main_tab_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const borrowCreate = '/borrows/create';
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
      builder: (context, state) => const MainTabScreen(),
    ),
    GoRoute(
      path: AppRoutes.borrowCreate,
      builder: (context, state) {
        final bookId = int.tryParse(state.uri.queryParameters['bookId'] ?? '');
        return BorrowCreateScreen(bookId: bookId);
      },
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
