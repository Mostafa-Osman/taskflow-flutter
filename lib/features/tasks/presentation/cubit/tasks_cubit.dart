import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/pagination_controller.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit(this._getTasks, {TaskFilter initialFilter = const TaskFilter()})
    : _filter = initialFilter,
      super(const TasksState.initial());

  final GetTasksUseCase _getTasks;
  final PaginationController _pagination = PaginationController(
    pageSize: AppConstants.defaultPageSize,
  );
  TaskFilter _filter;

  TaskFilter get filter => _filter;

  Future<void> load({TaskFilter? filter}) async {
    if (filter != null) {
      _filter = filter;
    }
    _pagination.beginInitialLoad();
    emit(TasksState.loading(filter: _filter));
    await _fetch(reset: true);
  }

  Future<void> search(String query) {
    return load(filter: _filter.copyWith(query: query));
  }

  Future<void> applyFilter(TaskFilter filter) => load(filter: filter);

  Future<void> refresh() async {
    if (!_pagination.canRefresh) {
      return;
    }
    final current = state;
    if (current is TasksSuccess) {
      emit(current.copyWith(refreshing: true, loadMoreFailure: null));
    }
    _pagination.beginRefresh();
    await _fetch(reset: true);
  }

  Future<void> loadMore() async {
    if (!_pagination.canLoadMore) {
      return;
    }
    final current = state;
    if (current is! TasksSuccess) {
      return;
    }
    _pagination.beginLoadMore();
    emit(current.copyWith(loadingMore: true, loadMoreFailure: null));
    await _fetch(reset: false);
  }

  Future<void> retry() => load(filter: _filter);

  Future<void> retryLoadMore() => loadMore();

  Future<void> _fetch({required bool reset}) async {
    final result = await _getTasks(
      GetTasksParams(
        page: _pagination.page,
        pageSize: _pagination.pageSize,
        filter: _filter,
      ),
    );
    result.fold(
      (failure) {
        _pagination.onFailure();
        final current = state;
        if (!reset && current is TasksSuccess) {
          emit(current.copyWith(loadingMore: false, loadMoreFailure: failure));
          return;
        }
        emit(TasksState.error(failure, filter: _filter));
      },
      (page) {
        _pagination.onSuccess(nextHasMore: page.hasMore);
        if (reset && page.items.isEmpty) {
          emit(TasksState.empty(filter: _filter));
          return;
        }
        final current = state;
        final existing = !reset && current is TasksSuccess
            ? current.items
            : const <Task>[];
        emit(
          TasksState.success(
            items: [...existing, ...page.items],
            filter: _filter,
            hasMore: page.hasMore,
          ),
        );
      },
    );
  }
}
