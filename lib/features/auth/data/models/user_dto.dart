import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/user_role.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.tenantId = 'tenant-a',
    this.role = 'teacher',
    this.organizationId,
    this.assignedClassIds = const [],
    this.assignedSubject,
    this.permissions = const [],
  });

  final String id;
  final String name;
  final String email;
  final String tenantId;
  final String role;
  final String? organizationId;
  final List<String> assignedClassIds;
  final String? assignedSubject;
  final List<String> permissions;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    tenantId: tenantId,
    role: UserRole.fromApi(role),
    organizationId: organizationId,
    assignedClassIds: assignedClassIds,
    assignedSubject: assignedSubject,
    permissions: permissions,
  );

  factory UserDto.fromEntity(User user) {
    return UserDto(
      id: user.id,
      name: user.name,
      email: user.email,
      tenantId: user.tenantId,
      role: user.role.apiValue,
      organizationId: user.organizationId,
      assignedClassIds: user.assignedClassIds,
      assignedSubject: user.assignedSubject,
      permissions: user.permissions,
    );
  }
}
