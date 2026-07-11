import 'dart:developer' as dev;
import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:booksphere_app/features/books/data/book_models.dart';
import 'package:booksphere_app/features/borrows/data/borrow_api.dart';
import 'package:booksphere_app/features/borrows/data/borrow_models.dart';
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

class BorrowListState {
  final bool isLoading;
  final bool isRefreshing;
  final List<BorrowResponse> borrows;
  final String? selectedStatus;
  final String? errorCode;
  final String? errorMessage;

  const BorrowListState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.borrows = const [],
    this.selectedStatus,
    this.errorCode,
    this.errorMessage,
  });

  BorrowListState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<BorrowResponse>? borrows,
    String? selectedStatus,
    String? errorCode,
    String? errorMessage,
    bool clearStatus = false,
    bool clearError = false,
  }) {
    return BorrowListState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      borrows: borrows ?? this.borrows,
      selectedStatus: clearStatus ? null : selectedStatus ?? this.selectedStatus,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class BorrowListNotifier extends Notifier<BorrowListState> {
  @override
  BorrowListState build() {
    Future.microtask(() => loadBorrows());
    return const BorrowListState();
  }

  Future<void> loadBorrows({bool isRefreshing = false}) async {
    state = state.copyWith(
      isLoading: !isRefreshing,
      isRefreshing: isRefreshing,
      clearError: true,
    );

    try {
      final response = await ref.read(borrowRepositoryProvider).searchBorrows(
        status: state.selectedStatus,
        size: 50,
      );
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        borrows: response.content,
      );
    } on BorrowException catch (error) {
      dev.log('BorrowListNotifier.loadBorrows BorrowException: ${error.code}');
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorCode: error.code,
        errorMessage: error.message,
      );
    } catch (error, stackTrace) {
      dev.log('BorrowListNotifier.loadBorrows Unexpected Error: $error', error: error, stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  Future<void> changeFilter(String? status) async {
    if (state.selectedStatus == status) return;
    state = state.copyWith(
      selectedStatus: status,
      clearStatus: status == null,
      borrows: const [],
    );
    await loadBorrows();
  }

  Future<void> refresh() async {
    await loadBorrows(isRefreshing: true);
  }
}

final borrowListProvider = NotifierProvider<BorrowListNotifier, BorrowListState>(
  BorrowListNotifier.new,
);
