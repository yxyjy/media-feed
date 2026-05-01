import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/feed_repo.dart';
import '../services/api_client.dart';
import 'feed_state.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  ref.onDispose(client.dispose);
  return client;
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(apiClient: ref.watch(apiClientProvider));
});

final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  return FeedNotifier(repository: ref.watch(feedRepositoryProvider));
});

class FeedNotifier extends StateNotifier<FeedState> {
  final FeedRepository _repository;

  bool _isFetching = false;

  FeedNotifier({required FeedRepository repository})
    : _repository = repository,
      super(const FeedState.initial()) {
    fetchFirstPage();
  }
  Future<void> fetchFirstPage() async {
    if (_isFetching) return;
    _isFetching = true;
    state = const FeedState(moments: [], status: FeedStatus.loadingFirst);

    try {
      final result = await _repository.fetchPage(tag: null);

      state = FeedState(
        moments: result.moments,
        status: result.nextTag != null
            ? FeedStatus.loaded
            : FeedStatus.noMoreData,
        nextTag: result.nextTag,
      );
    } catch (e) {
      state = FeedState(
        moments: const [],
        status: FeedStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> fetchNextPage() async {
    if (state.status == FeedStatus.loadingMore ||
        state.status == FeedStatus.noMoreData) {
      return;
    }

    state = state.copyWith(status: FeedStatus.loadingMore);

    try {
      final result = await _repository.fetchPage(tag: state.nextTag);
      if (result.moments.isEmpty) {
        state = state.copyWith(status: FeedStatus.noMoreData);
        return;
      }

      state = state.copyWith(
        status: FeedStatus.loaded,
        moments: [...state.moments, ...result.moments],
        nextTag: result.nextTag,
      );
    } catch (e) {
      state = state.copyWith(
        status: FeedStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> retry() async {
    if (state.moments.isEmpty) {
      await fetchFirstPage();
    } else {
      await fetchNextPage();
    }
  }
}
