import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:booksphere_app/features/fines/data/fine_api.dart';
import 'package:booksphere_app/features/fines/data/fine_models.dart';
import 'package:booksphere_app/features/fines/data/fine_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Providers ────────────────────────────────────────────────

final _fineApiProvider = Provider<FineApi>((ref) {
  return FineApi(ref.watch(dioClientProvider));
});

final _storageProvider = Provider<SecureStorageService>(
  (_) => SecureStorageService(),
);

final fineRepositoryProvider = Provider<FineRepository>((ref) {
  return FineRepository(
    fineApi: ref.watch(_fineApiProvider),
    storageService: ref.watch(_storageProvider),
  );
});

// ── My Fines list (filterable) ────────────────────────────────

final myFinesProvider =
    NotifierProvider<MyFinesNotifier, AsyncValue<List<FineResponse>>>(
      MyFinesNotifier.new,
    );

class MyFinesNotifier extends Notifier<AsyncValue<List<FineResponse>>> {
  String? _currentFilter;
  bool _isRequestInFlight = false;

  String? get currentFilter => _currentFilter;
  bool get isRequestInFlight => _isRequestInFlight;

  @override
  AsyncValue<List<FineResponse>> build() {
    Future.microtask(() => loadFines());
    return const AsyncValue.loading();
  }

  Future<void> loadFines({String? status, bool isRefresh = false}) async {
    if (_isRequestInFlight) {
      return;
    }
    _isRequestInFlight = true;
    final previousFines = state.value;
    if (!isRefresh) {
      state = const AsyncValue.loading();
    }
    _currentFilter = status;
    try {
      final fines = await ref
          .read(fineRepositoryProvider)
          .getMyFines(status: status);
      state = AsyncValue.data(fines);
    } catch (e, st) {
      if (isRefresh && previousFines != null) {
        state = AsyncValue.data(previousFines);
        rethrow;
      }
      state = AsyncValue.error(e, st);
    } finally {
      _isRequestInFlight = false;
    }
  }

  Future<void> refresh() => loadFines(status: _currentFilter, isRefresh: true);
}

// ── Fine detail ───────────────────────────────────────────────

final fineDetailProvider = FutureProvider.family<FineResponse, String>(
  (ref, fineId) => ref.watch(fineRepositoryProvider).getFineById(fineId),
);
