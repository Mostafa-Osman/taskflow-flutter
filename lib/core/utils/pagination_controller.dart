/// Tracks page index and in-flight guards. Cubits own UI state; this only
/// prevents duplicate requests and encodes page arithmetic.
class PaginationController {
  PaginationController({this.pageSize = 10});

  final int pageSize;

  int page = 1;
  bool hasMore = true;
  bool isInitialLoading = false;
  bool isRefreshing = false;
  bool isLoadingMore = false;

  bool get canLoadMore =>
      hasMore && !isInitialLoading && !isRefreshing && !isLoadingMore;

  bool get canRefresh => !isInitialLoading && !isRefreshing;

  void beginInitialLoad() {
    page = 1;
    hasMore = true;
    isInitialLoading = true;
    isLoadingMore = false;
  }

  void beginRefresh() {
    page = 1;
    isRefreshing = true;
    isLoadingMore = false;
  }

  void beginLoadMore() {
    isLoadingMore = true;
  }

  void onSuccess({required bool nextHasMore}) {
    hasMore = nextHasMore;
    if (nextHasMore) {
      page += 1;
    }
    isInitialLoading = false;
    isRefreshing = false;
    isLoadingMore = false;
  }

  void onFailure() {
    isInitialLoading = false;
    isRefreshing = false;
    isLoadingMore = false;
  }
}
