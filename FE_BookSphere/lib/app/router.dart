import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/data/auth_session_service.dart';
import 'package:booksphere_app/features/auth/presentation/login_screen.dart';
import 'package:booksphere_app/features/auth/presentation/register_screen.dart';
import 'package:booksphere_app/features/auth/presentation/splash_screen.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_route_args.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_screen.dart';
import 'package:booksphere_app/features/borrow_cart/presentation/borrow_cart_screen.dart';
import 'package:booksphere_app/features/borrows/presentation/borrow_create_screen.dart';
import 'package:booksphere_app/features/borrows/presentation/borrow_detail_screen.dart';
import 'package:booksphere_app/features/home/presentation/main_tab_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const bookDetail = '/books/:bookId';
  static const borrowCart = '/borrow-cart';
  static const borrowCreate = '/borrows/create';
  static const borrowDetail = '/borrows/:id';
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
      path: AppRoutes.bookDetail,
      name: 'book-detail',
      builder: (context, state) {
        final bookId = state.pathParameters['bookId'] ?? '';
        final args = state.extra is BookDetailRouteArgs
            ? state.extra! as BookDetailRouteArgs
            : const BookDetailRouteArgs(mode: BookDetailMode.add);
        return BookDetailScreen(bookId: bookId, args: args);
      },
    ),
    GoRoute(
      path: AppRoutes.borrowCart,
      name: 'borrow-cart',
      builder: (context, state) => const BorrowCartScreen(),
    ),
    GoRoute(
      path: AppRoutes.borrowCreate,
      builder: (context, state) {
        final bookId = int.tryParse(state.uri.queryParameters['bookId'] ?? '');
        return BorrowCreateScreen(bookId: bookId);
      },
    ),
    GoRoute(
      path: AppRoutes.borrowDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return BorrowDetailScreen(borrowId: int.tryParse(id ?? ''));
      },
    ),
  ],
  redirect: (context, state) async {
    final matchedLocation = state.matchedLocation;

    if (matchedLocation == AppRoutes.splash) {
      return null;
    }

    final isBookDetail = matchedLocation.startsWith('/books/');
    final isBorrowCart = matchedLocation == AppRoutes.borrowCart;
    final isProtected =
        matchedLocation == AppRoutes.login ||
        matchedLocation == AppRoutes.register ||
        matchedLocation == AppRoutes.main ||
        isBookDetail ||
        isBorrowCart;

    if (isProtected) {
      final status = await _authSessionService.checkSession();
      if (status == AuthSessionStatus.authenticated) {
        return matchedLocation == AppRoutes.login ||
                matchedLocation == AppRoutes.register
            ? AppRoutes.main
            : null;
      }
      if (matchedLocation == AppRoutes.main || isBookDetail || isBorrowCart) {
        return AppRoutes.login;
      }
      return null;
    }

    return null;
  },
);
