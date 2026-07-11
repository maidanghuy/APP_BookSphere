import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/fines/data/fine_api.dart';
import 'package:booksphere_app/features/fines/data/fine_models.dart';
import 'package:booksphere_app/features/fines/data/fine_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Providers ────────────────────────────────────────────────

final _fineApiProvider = Provider<FineApi>((ref) {
  return FineApi(ref.watch(_dioClientProvider));
});

final _dioClientProvider = Provider<DioClient>((ref) => DioClient());

final _storageProvider = Provider<SecureStorageService>(
  (_) => SecureStorageService(),
);

final fineRepositoryProvider = Provider<FineRepository>((ref) {
  return FineRepository(
    fineApi: ref.watch(_fineApiProvider),
    storageService: ref.watch(_storageProvider),
  );
});

// ── My Fines list (paginated, filterable) ────────────────────

final myFinesProvider =
    StateNotifierProvider<MyFinesNotifier, AsyncValue<List<FineResponse>>>(
  (ref) => MyFinesNotifier(ref.watch(fineRepositoryProvider)),
);

class MyFinesNotifier extends StateNotifier<AsyncValue<List<FineResponse>>> {
  MyFinesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFines();
  }

  final FineRepository _repository;
  String? _currentFilter;

  String? get currentFilter => _currentFilter;

  Future<void> loadFines({String? status}) async {
    state = const AsyncValue.loading();
    _currentFilter = status;
    try {
      final fines = await _repository.getMyFines(status: status);
      state = AsyncValue.data(fines);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => loadFines(status: _currentFilter);
}

// ── Fine detail ───────────────────────────────────────────────

final fineDetailProvider = FutureProvider.family<FineResponse, String>(
  (ref, fineId) => ref.watch(fineRepositoryProvider).getFineById(fineId),
);
