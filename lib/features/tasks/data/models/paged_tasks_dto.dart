import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/paged_list.dart';
import '../../domain/entities/task.dart';
import 'task_dto.dart';

part 'paged_tasks_dto.g.dart';

@JsonSerializable()
class PagedTasksDto {
  const PagedTasksDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });

  final List<TaskDto> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  factory PagedTasksDto.fromJson(Map<String, dynamic> json) =>
      _$PagedTasksDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PagedTasksDtoToJson(this);

  PagedList<Task> toEntity() {
    return PagedList<Task>(
      items: items.map((item) => item.toEntity()).toList(growable: false),
      page: page,
      pageSize: pageSize,
      total: total,
      hasMore: hasMore,
    );
  }
}
