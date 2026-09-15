import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/core/utils/pagination_controller.dart';

void main() {
  test('prevents duplicate load-more while a request is in flight', () {
    final controller = PaginationController();
    controller.beginInitialLoad();
    expect(controller.canLoadMore, isFalse);

    controller.onSuccess(nextHasMore: true);
    expect(controller.canLoadMore, isTrue);
    expect(controller.page, 2);

    controller.beginLoadMore();
    expect(controller.canLoadMore, isFalse);

    controller.onSuccess(nextHasMore: false);
    expect(controller.canLoadMore, isFalse);
    expect(controller.hasMore, isFalse);
  });

  test('refresh resets to the first page', () {
    final controller = PaginationController();
    controller
      ..beginInitialLoad()
      ..onSuccess(nextHasMore: true)
      ..beginRefresh();
    expect(controller.page, 1);
    expect(controller.canLoadMore, isFalse);
  });

  test('failure clears in-flight flags', () {
    final controller = PaginationController()..beginLoadMore();
    controller.onFailure();
    expect(controller.isLoadingMore, isFalse);
  });
}
