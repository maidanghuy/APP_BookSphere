import 'dart:developer' as dev;
import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:booksphere_app/features/books/data/book_models.dart';
import 'package:booksphere_app/features/borrows/data/borrow_api.dart';
import 'package:booksphere_app/features/borrows/data/borrow_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final borrowApiProvider = Provider<BorrowApi>((ref) {
  return BorrowApi(ref.watch(dioClientProvider));
});

final borrowRepositoryProvider = Provider<BorrowRepository>((ref) {
  return BorrowRepository(ref.watch(borrowApiProvider));
});

final bookDetailProvider = FutureProvider.family.autoDispose<BookDetailResponse, int>((ref, bookId) async {
  return ref.read(borrowRepositoryProvider).getBookDetail(bookId);
});

class BorrowCreateState {
  const BorrowCreateState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorCode,
    this.errorMessage,
    this.errorStatusCode,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorCode;
  final String? errorMessage;
  final int? errorStatusCode;

  BorrowCreateState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorCode,
    String? errorMessage,
    int? errorStatusCode,
    bool clearError = false,
  }) {
    return BorrowCreateState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      errorStatusCode: clearError ? null : errorStatusCode ?? this.errorStatusCode,
    );
  }
}

class BorrowCreateController extends Notifier<BorrowCreateState> {
  @override
  BorrowCreateState build() {
    return const BorrowCreateState();
  }

  Future<bool> createBorrow({
    required int bookId,
    required int quantity,
    required DateTime dueDate,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await ref.read(borrowRepositoryProvider).createBorrow(
        bookId: bookId,
        quantity: quantity,
        dueDate: dueDate,
      );
      state = const BorrowCreateState(isSuccess: true);
      return true;
    } on BorrowException catch (error) {
      dev.log('BorrowCreateController.createBorrow BorrowException: ${error.code} - ${error.message}');
      state = BorrowCreateState(
        errorCode: error.code,
        errorMessage: error.message,
        errorStatusCode: error.statusCode,
      );
      return false;
    } catch (error, stackTrace) {
      dev.log('BorrowCreateController.createBorrow Unexpected Error: $error', error: error, stackTrace: stackTrace);
      state = const BorrowCreateState(errorCode: 'UNKNOWN_ERROR');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final borrowCreateControllerProvider =
    NotifierProvider<BorrowCreateController, BorrowCreateState>(
  BorrowCreateController.new,
);
