import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/project.dart';

part 'project_dto.g.dart';

@JsonSerializable()
class ProjectDto {
  const ProjectDto({
    required this.id,
    required this.name,
    required this.description,
    required this.taskCount,
    required this.completedTaskCount,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final int taskCount;
  final int completedTaskCount;
  final DateTime updatedAt;

  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDtoToJson(this);

  Project toEntity() {
    return Project(
      id: id,
      name: name,
      description: description,
      taskCount: taskCount,
      completedTaskCount: completedTaskCount,
      updatedAt: updatedAt,
    );
  }
}
