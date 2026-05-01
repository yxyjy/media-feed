import '../models/moment.dart';

enum FeedStatus {
  initial,
  loadingFirst,
  loadingMore,
  loaded,
  error,
  noMoreData,
}

class FeedState {
  final List<Moment> moments;
  final FeedStatus status;
  final String? errorMessage;
  final String? nextTag;

  const FeedState({
    required this.moments,
    required this.status,
    this.errorMessage,
    this.nextTag,
  });

  const FeedState.initial()
    : moments = const [],
      status = FeedStatus.initial,
      errorMessage = null,
      nextTag = null;

  FeedState copyWith({
    List<Moment>? moments,
    FeedStatus? status,
    String? errorMessage,
    String? nextTag,
    bool clearError = false,
    bool clearNextTag = false,
  }) {
    return FeedState(
      moments: moments ?? this.moments,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      nextTag: clearNextTag ? null : (nextTag ?? this.nextTag),
    );
  }
}
