class PagedList<T> {
  const PagedList({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });

  final List<T> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  factory PagedList.empty({int page = 1, int pageSize = 10}) {
    return PagedList<T>(
      items: const [],
      page: page,
      pageSize: pageSize,
      total: 0,
      hasMore: false,
    );
  }
}
