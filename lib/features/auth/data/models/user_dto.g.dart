// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  tenantId: json['tenantId'] as String? ?? 'tenant-a',
  role: json['role'] as String? ?? 'teacher',
  organizationId: json['organizationId'] as String?,
  assignedClassIds:
      (json['assignedClassIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  assignedSubject: json['assignedSubject'] as String?,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'tenantId': instance.tenantId,
  'role': instance.role,
  'organizationId': instance.organizationId,
  'assignedClassIds': instance.assignedClassIds,
  'assignedSubject': instance.assignedSubject,
  'permissions': instance.permissions,
};
