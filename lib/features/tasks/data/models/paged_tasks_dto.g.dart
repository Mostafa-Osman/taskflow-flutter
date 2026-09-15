// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_tasks_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedTasksDto _$PagedTasksDtoFromJson(Map<String, dynamic> json) =>
    PagedTasksDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$PagedTasksDtoToJson(PagedTasksDto instance) =>
    <String, dynamic>{
      'items': instance.items,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'total': instance.total,
      'hasMore': instance.hasMore,
    };
